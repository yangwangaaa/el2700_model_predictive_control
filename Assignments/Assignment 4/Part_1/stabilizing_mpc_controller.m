function F = stabilizing_mpc_controller(current_state, t)
    persistent controller
    if t == 0
        %% Parameters
        % =============================================================== %
        load('pendulum_parameters.mat', 'params')    
        m   = params.m;          % Mass of the inverted pendulum
        l   = params.l;          % length to the pendulum center of mass
        I   = params.I;          % moment of inertia of the pendulum
        bp  = params.b;          % coefficient of friction for pendulum
        g   = params.g;          % acceleration due to gravity
        h   = params.h;          % Sampline time
        % =============================================================== %
        %% Compute linearized dynamics and select control parameters
        % =============================================================== %
        % Continous time dynamics matrices Ac, Bc
        Ac = [[0                 1];
              [m*g*l/(I+m*l^2), -bp/(I+m*l^2)]];

        Bc = [0;
             m*l/(I+m*l^2)];

        N          = 2;                % Prediction horizon
        Q          = diag([1 0]);       % State penalty
        R          = 1;                 % Control penalty
        [nx, nu]   = size(Bc);          % State and input dimension     
        
        % Discretize the model: 
        Ts = 0.100;
        [A,B] = c2d(Ac,Bc,Ts);

        xmin = [-pi/4; -pi/2];
        xmax = [pi/4; pi/2];
        umin = -5;
        umax = 5;
        
        % Define the system as a MPT toolbox LTISystem
        % The control constraints will be defined later. 
        sys = LTISystem('A', A, 'B', B);
        sys.x.min =  xmin;
        sys.x.max =  xmax;
        sys.u.min =  umin;
        sys.u.max =  umax;
        sys.x.penalty = QuadFunction(Q);
        sys.u.penalty = QuadFunction(R);

        % =============================================================== %
        %% MPC control constraints
        % Constraints on states and input
        % =============================================================== %

        % State and input costraints as matrices
        % Should be on form 
        %    Hx*x <= hx
        %    Hu*x <= hu
        Hx   = [1 0; -1 0; 0 1; 0 -1];
        hx   = [pi/4;pi/4;pi/2;pi/2];
        Hu   = [1;-1];
        hu   = [5;5];
        
        % =============================================================== %
        % Terminal penalty and terminal constraint 
        % =============================================================== %
        invariant_set_type = 'lqr'; 
        switch (invariant_set_type)
            case 'zero'
               Xf = Polyhedron([-eye(nx); eye(nx)], zeros(nx*2, 1));
               Qf = zeros(nx); % if terminal set is zero, the terminal cost is not important.
            case 'lqr'
               Xf = sys.LQRSet();
               [Qf,~,~] = dare(A,B,Q,R);
            otherwise
               msg = "Please set the variable invariant_set_type to either 'lqr' or 'zero'.";
               close; error(msg);
        end    
        % Write terminal set on H-polyhedron form 
        % Hx <= h
        H = Xf.A;
        h = Xf.b;

        % Avoid explosion of internally defined variables in YALMIP
        yalmip('clear')
        
        % Introduce decision variables
        for k = 1: N
            x{k} = sdpvar(nx,1); 
            u{k} = sdpvar(nu,1);
        end
        
        
        % Formulate constrained optimization problem
        constraints = [];
        objective = 0;
        for k = 1: N-1
            % penalizing incremental state and incremental input
            objective = objective + x{k}'*Q*x{k} + u{k}'*R*u{k};
            % state evolution
            constraints = [constraints, x{k+1}==A*x{k}+B*u{k}];
            % input constraints
            constraints = [constraints, Hu*u{k}<=hu];
            % state constraints
            constraints = [constraints, Hx*x{k}<=hx];
        end
        
        % terminal penalty
        objective = objective + x{N}'*Qf*x{N};
        
        % terminal constriant
        constraints = [constraints, H*x{N}<=h];
        
        controller = optimizer(constraints, objective, [], x{1}, u{1});
        F = controller(current_state);
        
    else
        F = controller(current_state);
    end
    
    % ============================================================================== %
    %% Q.1 set N = 20. Simulate your controller with the zero and LQR terminal sets. 
    % ============================================================================== %
    % Do the initial state remains inside the KNS set you computed in the
    % last task?
    % Answer: For the terminal set type zero, we observed that the initial
    % state converged to zero which lies inside the KNS set. Similarly, for
    % lqr terminal set, the extreme states were (0.2, -0.37) and the system
    % converged to 0. We observed all the states to be inside the KNS set.
    % ============================================================================== %
    %% Q.2 set N = 3. Simulate your controller with the zero and lqr terminal sets. 
    % ============================================================================== %
    % Do both controllers work? Can you explain what is happening?
    % Answer: The controller for zero-terminal set does not work but the
    % controller works for lqr terminal set. This may be because the
    % initial state for zero terminal set is very near to the edge and
    % might result in the system to evolve outside the KNS set and diverge.
    % But, it is not the case with any control horizon N >=4. 
    % ============================================================================== %
end

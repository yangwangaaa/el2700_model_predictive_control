function F = tracking_mpc_controller(current_state, current_reference, t)
    
    persistent controller
    
    if t == 0
        % =============================================================== %
        %% System Modeling
        % =============================================================== %
        % load model parameters
        load('pendulum_parameters.mat', 'params')
        M   = params.M;          % Mass of the cart      
        m   = params.m;          % Mass of the inverted pendulum
        bc  = params.bc;         % coefficient of friction for cart
        l   = params.l;          % length to the pendulum center of mass
        I   = params.I;          % moment of inertia of the pendulum
        bp  = params.b;          % coefficient of friction for pendulum
        g   = params.g;          % acceleration due to gravity
        h   = params.h;          % Sampling time
        % --------------------------------------------------------------- %
        % continuous time state space model of the system
        % --------------------------------------------------------------- %
        % Ac matrix
        v1   = (M + m)/(I*(M + m) + m*M*l^2);
        v2   = (I + m*l^2)/(I*(M + m) + m*M*l^2);
        a11  = 0; a12  = 1; a13  = 0; a14  = 0;
        a21  = 0; a22  = -bc*v2; a23  = (m*l)^2*g*v2/(I + m*l^2);
        a24  = -(m*l*bp*v2)/(I + m*l^2);
        a31  = 0; a32  = 0; a33  = 0; a34  = 1;
        a41  = 0; a42  = -(m*l*bc*v1)/(m+M); a43  = m*g*l*v1; a44  = -bp*v1;
        Ac   = [ a11 a12 a13 a14;
                 a21 a22 a23 a24;
                 a31 a32 a33 a34;
                 a41 a42 a43 a44];
        % Bc vector
        b1   = 0; b2   = v2; b3   = 0; b4   = m*l*v1/(M+m);
        Bc   = [b1; b2; b3; b4];
        % Cc vector
        Cc   = [1 0 0 0];
        % Dc vector
        Dc   = 0;
        % --------------------------------------------------------------- %
        % dimensionality of state, input and control
        % --------------------------------------------------------------- %
        nx = size(Bc, 1);
        nu = size(Bc, 2);
        ny = size(Cc, 1);
        % --------------------------------------------------------------- %
        % discrete-time state space model of the system
        % --------------------------------------------------------------- %
        sys  = ss(Ac, Bc, Cc, Dc);
        sysd = c2d(sys, h);
        A    = sysd.A; 
        B    = sysd.B; 
        C    = sysd.C;
        % =============================================================== %
        %% MPC controller parameters
        % =============================================================== %
        % state and control constraints
        % --------------------------------------------------------------- %
        x_min        = -100;          x_max        = 100;
        xdot_min     = -5;            xdot_max     = 5;
        theta_min    = -10*pi/180;    theta_max    = 10*pi/180;
        thetadot_min = -pi/2;         thetadot_max = pi/2;
        Xmin         = [x_min; xdot_min; theta_min; thetadot_min];
        Xmax         = [x_max; xdot_max; theta_max; thetadot_max];
        u_min = -5;            u_max  = 5;
        
        Hx           = [-eye(nx); eye(nx)];
        hx           = [-Xmin; Xmax];

        Hu           = [-eye(nu); eye(nu)];
        hu           = [-u_min; u_max];
        
        % =============================================================== %
        % Prediction horizon, state and control penalty, terminal
        % penalty
        % =============================================================== %
        N          = 5;
        Nc         = 5;
        Q          = diag([10 10 180/pi*100 180/pi*100]);
        Qslack     = 1000;
        R          = 0.01;
        [L, Qf, ~] = dlqr(A, B, Q, R);
        % =============================================================== %
        % Avoid explosion of internally defined variables in YALMIP
        yalmip('clear')
        % =============================================================== %           
        %% Formulate finite horizon planning problem
        % =============================================================== %
        % Introduce decision variables
        % --------------------------------------------------------------- %
        % Incremental states and inputs
        deltaU  = sdpvar(repmat(nu, 1, N-1), repmat(1, 1, N-1));
        deltaX  = sdpvar(repmat(nx, 1, N),   repmat(1, 1, N));
        Xslack  = sdpvar(repmat(2*nx, 1, N), repmat(1, 1, N));
        % System state and input at steady state
        Xbar    = sdpvar(nx, 1);
        Ubar    = sdpvar(nu, 1);
        % Reference
        r       = sdpvar(ny, 1);
        % Current state and computed Input
        Xt      = sdpvar(nx, 1);
        Ut      = sdpvar(nu, 1);
        % =============================================================== %
        % Formulate constrained optimization problem
        constraints = [];
        constraints = [constraints, Xt == deltaX{1} + Xbar];
        constraints = [constraints, A*Xbar == Xbar + B*Ubar];
        constraints = [constraints, C*Xbar == r ];
        objective = 0;
        for k = 1: N-1
            % penalizing incremental state and incremental input
            objective = objective + deltaX{k}'*Q*deltaX{k} + deltaU{k}'*R*deltaU{k}+ Qslack*Xslack{k}'*Xslack{k};
            % state evolution
            constraints = [constraints, deltaX{k+1} == A*deltaX{k} + B*deltaU{k}];
            % input constraints
            constraints = [constraints, Hu*(deltaU{k} + Ubar) <= hu];
            % state constraints
            constraints = [constraints, Hx*(deltaX{k} + Xbar) <= hx + Xslack{k}];
        end
        % terminal penalty
        objective = objective + deltaX{N}'*Qf*deltaX{N};
        % terminal constraints
        for k = 1: Nc
            constraints = [constraints, -Hu*L*(A - B*L)^(k-1)*deltaX{N} + Hu*Ubar <= hu];
            constraints = [constraints, Hx*(A - B*L)^k*deltaX{N} + Hx*Xbar <= hx];
        end
        % computed input
        constraints = [constraints, Ut == deltaU{1} + Ubar];
        options = sdpsettings('solver', 'gurobi');
        controller = optimizer(constraints, objective, options, {Xt, r}, Ut);
        F = controller{{current_state, current_reference}};             
    else
        F = controller{{current_state, current_reference}};
    end
    
    % ============================================================================== %
     %% Q.1 Verify that the system is reachable
    % ============================================================================== %
%     R = [A-eye(4) B; C zeros(4,2)];
%     if rank(R) == 6
%         display('The system is reachable')
%     end
    % Verify that the system is reachable and that we can find 
    % xbar, ubar for every reference signal r
    % Answer: The system is reachable as the R matrix defined above has
    % full rank
    % ============================================================================== %
    %% Q.2 Tracking abilities
    % ============================================================================== %
    % How does this controller track the constant reference? Are the state and control constraints satisfied? 
    % Answer: The controller tracks the reference with no steady state
    % error but with some overshoot. Also, the input constraints were within the specified range of
    % [-5,5] and the state constraints too, were within the limits.
    % ============================================================================== %
    % ============================================================================== %
    %% Q.3 Tracking abilities
    % ============================================================================== %
    % Add both positive and negative small constant disturbances 
    % (e.g. w_t = +- 0.05) to mimic the presence of the horizontal wind force 
    % on the inverted pendulum. 
    % Comment on the tracking ability of the controller in this scenario. 
    % Answer: When positive or negative disturbance is added, we found that
    % even though the system is converging there is a lot of steady state
    % error (around 7.16 for +0.05 and around 12.8 for -0.05). But the
    % input and state constraints are satisfied in either cases. This
    % performance can be improved by either modelling the disturbance(as
    % this is a step disturbance) or by using integral action to remove the
    % steady state error.
    % ============================================================================== %

end
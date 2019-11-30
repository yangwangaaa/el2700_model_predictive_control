function [A,b] = EconstraintMatrix(obj,x_cur)
    x0 = x_cur'; % the size is as stored in system object.
    n = size(obj.Q,1);
    m = size(obj.R,1);
    N = obj.N;
    b = zeros(n*N,1);
    A = zeros(n*N,(n+m)*N);
    b(1:n,1) = obj.pre_model.A*x0;
    A(1:2,1:2) = eye(2);
    A(1:2,1+n*N) = -obj.pre_model.B;
    
    for i = 1:N-1
        row       = (1 + n*i    ) : (n + n*i    );
        x_col     = (1 + n*(i-1)) : (n + n*(i-1));
        x_col_n   = x_col + n;
        u_col     = n*N+1+i;
        A(row,x_col_n) = eye(n);
        A(row,x_col)   = -obj.pre_model.A;
        A(row,u_col)   = -obj.pre_model.B;
    end
    
    if obj.disturbance_flag
        % --- INCLUDING DITURBANCE IN THE PREDICTION MODEL --- %
        b = b+kron(ones(N,1),obj.NN*1e-3*eye(2))*obj.disturbance;
    end
    
    
end
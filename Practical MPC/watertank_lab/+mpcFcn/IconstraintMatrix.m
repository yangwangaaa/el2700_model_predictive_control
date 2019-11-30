function [A,b] = IconstraintMatrix(obj,x_cur)
    x0 = x_cur'; % the size is as stored in system object.
    n = size(obj.Q,1);
    m = size(obj.R,1);
    N = obj.N;
    b = zeros(2*n*N,1);
    A = zeros(2*n*N,(n+m)*N);
    b(1:2*n,1) = [obj.model.A*x0;-obj.model.A*x0];
    A(1:4,1:2) = [eye(2);-eye(2)];
    A(1:4,1+n*N) = -[obj.model.B;-obj.model.B];
    
    neg_index = false(size(A,1),1);
    
    for i = 1:N-1
        row       = (1 + 2*n*i    ) :    (2*n + 2*n*i    );
        x_col     = (1 +   n*(i-1)) :    (  n +   n*(i-1));
        x_col_n = x_col + n;
        u_col = (n*N+1 +   m*(i-1)) : ( n*N+m +   m*(i-1));
        A(row,x_col_n) = [eye(n);eye(n)];
        A(row,x_col)   = -[obj.model.A;obj.model.A];
        A(row,u_col)   = -[obj.model.B;obj.model.B];
        neg_index(row(3:4),1) = true;
    end
    A(neg_index,:) = -A(neg_index,:);
end
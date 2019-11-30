function H = costMatrix(obj)
    Q = obj.Q;
    R = obj.R;
    Qf = obj.Qf;
    N = obj.N;
    H = [kron(ones(N-1,1),diag(Q));
         [0;0];
         kron(ones(N,1),diag(R))];
    H = diag(H);
    H(2*(N-1)+1:2*N,2*(N-1)+1:2*N) = Qf;
end
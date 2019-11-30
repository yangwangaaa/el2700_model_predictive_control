%% Task (a)
Q = diag([1,1,1]);
A = [-1 -1 -1; -2 1 0];
b = [-3;-1];

x = sdpvar(3,1);
cost =  0.5*x'*Q*x;
constraints = [A*x <= b];

optimize(constraints,cost)
double(cost)

%% Task (b)
x = sdpvar(2,1);
cost =  2*x(1) + 3*x(2) + 4*(x(1)^2) + 2*x(1)*x(2) + x(2)^2;
constraints = [x(1) - x(2) >= 0; x(1) + x(2) <= 4; x(1) <=3];

optimize(constraints,cost)
double(cost)
double(x)

%% Task (c)
x0 = 3;

x = sdpvar(4,1);
cost =  0.5*(x(1)^2+x(2)^2+x(3)^2+x(4)^2);
constraints = [x(1)== 0.5*x0 + x(3); x(2)==0.5*x(1) + x(4); ...
                2<=x(1)<=5; -2<=x(2)<=2; -1<=x(3)<=1; -1<=x(4)<=1];

optimize(constraints,cost)
double(cost)
double(x)
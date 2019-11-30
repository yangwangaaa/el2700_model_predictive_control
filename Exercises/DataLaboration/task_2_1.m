%% Transportation Problem
x = sdpvar(4,3);
constraints = [];
for i = 1:4
    x_sum = 0;
    for j = 1:3
        c = 1+(i-j)^2;
        s = i*i;
        
        cost = cost + c*x(i,j);
        x_sum = x_sum + x(i,j);
        constraints = [constraints ; x(i,j) >= 0];
    end
    constraints = [constraints ; x_sum <= s];
end
d = 10;
for j = 1:3
    y_sum = 0;
    for i = 1:4
        y_sum = y_sum + x(i,j);
    end
    constraints = [constraints ; y_sum >= d];
end

optimize(constraints,cost)
double(cost)
double(x)
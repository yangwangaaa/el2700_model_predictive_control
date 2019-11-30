A = [1 1; 2 0];
B = [0;1];
Q2 = 1;
Q1 = eye(2,2);
Qf = eye(2,2);
n = 100;
M = cell(n,1);
L = cell(n,1);
%% task (a)
Pt = eye(2,2);
for i = 1:n
    Pr = Q1 + A'*Pt*A - A'*Pt*B*inv(Q2+(B'*Pt*B))*B'*Pt*A;
    Lt = inv(Q2 + B'*Pr*B)*B'*Pr*A;
    L{n-i+1} = Lt;
    M{i} = Pr;
    Pt = Pr;
end

for i = 1:n
    k1 = [k M{i}(1,1)];
    k2 = [k M{i}(1,2)];
    k3 = [k M{i}(2,1)];
    k4 = [k M{i}(2,2)];
end
subplot(2,2,1)
plot(k1)
subplot(2,2,2)
plot(k2)
subplot(2,2,3)
plot(k3)
subplot(2,2,4)
plot(k4)

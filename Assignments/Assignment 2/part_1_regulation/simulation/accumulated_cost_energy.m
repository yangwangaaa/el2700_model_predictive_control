function [J, E] = accumulated_cost_energy(x, u, Q, R)
J = zeros(size(u));
E = zeros(size(u));
Js = 0;
Es = 0;
for i = 1 : length(u)
    J(i) = Js + x(:,i)'*Q*x(:,i) + u(i)'*R*u(i);
    Js = J(i);
    E(i) = Es + u(i)'*u(i);
    Es = E(i);
end
end


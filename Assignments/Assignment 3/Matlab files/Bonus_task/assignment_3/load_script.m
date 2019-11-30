load('../data/pendulum_parameters.mat', 'params')
M   = params.M;          % Mass of the cart      
m   = params.m;          % Mass of the inverted pendulum
bc  = params.bc;         % coefficient of friction for cart
l   = params.l;          % length to the pendulum center of mass
I   = params.I;          % moment of inertia of the pendulum
bp  = params.b;          % coefficient of friction for pendulum
g   = params.g;          % acceleration due to gravity
h   = params.h;          % Sampline time
% =============================================================== %
%% I. System modeling 
% =============================================================== %
% Reuse your model in assignment 1
% Linearize continuous-time dynamics around the upright position
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
% Disturbance matrix
Bwc = [0; -I*v2/(I + m*l^2); 0; M*l*v1/(M+m)];
% Convert to continuous-time system
sys = ss(Ac, Bc, Cc, Dc);
% -------------------------------------------------------------- %
% Discretize the continous-time linear system
% -------------------------------------------------------------- %
sysd = c2d(sys, h);
A = sysd.A;
B = sysd.B;
C = sysd.C; 
% compute disturbance matrix in discrete-time doamin
Bw = integral(@(s) expm(Ac*s)*Bwc, 0, h, 'ArrayValued',true);

[nx, nu] = size(B);
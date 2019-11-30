%% Paths
% =============================================================== %
addpath('../assignment_3')
% =============================================================== %
%% Load parameters of the cart-pendulum System
% =============================================================== %
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
% A matrix
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
Cc   = [1 0 0 0;
        0 0 1 0];
% Dc vector
Dc   = [0;
        0];
% Disturbance matrix
Bwc = [0; -I*v2/(I + m*l^2); 0; M*l*v1/(M+m)];
% ============================================================= %
%% Implemented state space model in SIMULINK
% ============================================================= %
% In this model, we have implemented continuous-time dynamics 
% of cart pendulum system around the upright position
% X_dot = Ac X + Bc u + Bwc w
%     y = Cc X + Dc u + Dwc w
% Here, we have considered full state as output and new input v as
% the stacked vector of u and w
% v = [u; w]; 
% Therefore, the above dynamical system can be rewritten as
% X_dot = A X + B v
%     y = C X + D v
% with A = Ac, B = [Bc Bwc], C = eye(4), D = zeros(4,2) 
% -------------------------------------------------------------- %
A = Ac;
B = [Bc Bwc];
C = eye(4);
D = zeros(4,2);
% ============================================================= %
% Initial conditiom
% ============================================================= %
X0  = [0; 0; pi/6; 0];
% ============================================================= %

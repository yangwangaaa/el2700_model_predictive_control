%% Design Project II, EL2700: Dynamic Programming
% ======================================================================= %
% Learning Outcome:
% ----------------
% Dynamic programming through gridding
% Project Summary:
% ---------------
% In this project, we will implement a numerical dynamic programming
% strategy to compute a finite horizon optimal control strategy for the
% cart-pendulum problem.
% ======================================================================= %
% Clear
clear all; close all; clc;
% ======================================================================= %
%% Parameters for cart and pendulum assembly
% ======================================================================= %
load('../data/pendulum_parameters.mat', 'params')
M   = params.M;          % Mass of the cart
m   = params.m;          % Mass of the inverted pendulum
bc  = params.bc;         % coefficient of friction for cart
l   = params.l;          % length to the pendulum center of mass
I   = params.I;          % moment of inertia of the pendulum
bp  = params.b;          % coefficient of friction for pendulum
g   = params.g;          % acceleration due to gravity
h   = params.h;          % Sampline time
% ======================================================================= %
%% Design of controller by Dynamic Programming through gridding
% ======================================================================= %
%% Step I : Discrete-time linear model of the system for prediction
% ----------------------------------------------------------------------- %
% Ac matrix
v1   = (M + m)/(I*(M + m) + m*M*l^2);
v2   = (I + m*l^2)/(I*(M + m) + m*M*l^2);
a11  = 0; a12  = 1; a13  = 0; a14  = 0;
a21  = 0; a22  = -bc*v2;
a23  = (m*l)^2*g*v2/(I + m*l^2);
a24  = -(m*l*bp*v2)/(I + m*l^2);
a31  = 0; a32  = 0; a33  = 0; a34  = 1;
a41  = 0; a42  = -(m*l*bc*v1)/(m+M);
a43  = m*g*l*v1; a44  = -bp*v1;
Ac   = [ a11 a12 a13 a14;
         a21 a22 a23 a24;
         a31 a32 a33 a34;
         a41 a42 a43 a44];
% Bc matrix
b1   = 0; b2   = v2; b3   = 0; b4   = m*l*v1/(M+m);
Bc   = [b1; b2; b3; b4];
% Cc matrix
Cc   = [1 0 0 0];
% D matrix
Dc   = 0;
% dimensionality of state and input
[nx, nu] = size(Bc);
% discretize the continuous time linear state space model using zero order
% hold
sys = ss(Ac, Bc, Cc, Dc);
sysd = c2d(sys, h);
A = sysd.A;
B = sysd.B;
% ======================================================================= %
%% STEP III : Controller parameters
% ======================================================================= %
% for stabilizing control and reference tracking control
Q    = diag([1 1 10 1000]);
R    = 0.01;
N    = 200;
uint = 0;
% For reference tracking: Reference point
xr = [10; 0; 0; 0];
% ======================================================================= %
%% Step II: Gridding the state space
% ======================================================================= %
X1 = linspace (-2, 12, 10);
X2 = linspace (-2,  2, 5);
X3 = linspace (-pi/4, pi/4, 10);
X4 = linspace (-pi/2, pi/2, 5);
U  = zeros(length(X1), length(X2), length(X3), length(X4), N);
J  = zeros(length(X1), length(X2), length(X3), length(X4), N);
% ======================================================================= %
%% STEP IV: Stage Cost and cost-to-go
% ======================================================================= %
Jstage = @(x,u) (x-xr)'*Q*(x-xr) + u'*R*u;
[K, P] = dlqr(A, B, Q, R);
Jtogo = @(x) (x-xr)'*P*(x-xr);
options = optimoptions(@fminunc,'Display','iter',...
                       'Algorithm','quasi-newton');
for n = 1 : N
    % calculate cost-to-go at each grid point
    for i = 1 : length(X1)
        for j = 1 : length(X2)
            for k = 1 : length(X3)
                for l = 1: length(X4)
                    % current state
                    x = [X1(i); X2(j); X3(k); X4(l)];
                    % calculate optimal control and cost to go
                    [U(i,j, k, l, n), J(i,j, k, l, n)] = fminunc(@(u)...
                        Jstage(x,u) + Jtogo(A*x + B*u), uint, options);
                end
            end
        end
    end
    Jtogo = @(x) interpn(X1, X2, X3, X4, J(:, :, :, :, n), x(1), x(2), ...
                         x(3), x(4), 'spline');
end
% ======================================================================= %
%% STEP VI: Save optimal control
% ======================================================================= %
save("DP_TV_L_FS.mat","U", "X1", "X2", "X3", "X4")
% ======================================================================= %
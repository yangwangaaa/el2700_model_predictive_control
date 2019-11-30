%% Design Project II, EL2700: Dynamic Programming
% ======================================================================= %
% Learning Outcome:
% ----------------
% Dynamic programming through gridding
% Project Summary:
% ---------------
% In this project, we will implement a numerical dynamic programming
% strategy to compute a finite horizon optimal control strategy for the
% inverted pendulum problem.
% ======================================================================= %
% Clear
clear all; close all; clc;
% ======================================================================= %
%% Parameters for inverted pendulum
% ======================================================================= %
load('../data/pendulum_parameters.mat', 'params')
m   = params.m;          % Mass of the inverted pendulum
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
a0 = -(m*g*l)/(I+(m*l^2));
a1 = bp/(I+(m*l^2));
Ac  = [0 1; -a0 -a1];
% Bc matrix
b0 = (m*l)/(I+(m*l^2));
Bc  =[0; b0];
% dimensionality of state and input
[nx, nu] = size(Bc);
% discretize the continuous time linear state space model
h = 0.1;
[A, B] = c2d(Ac,Bc,h);
% ======================================================================= %
%% STEP II : Controller parameters
% ======================================================================= %
% for stabilizing control and reference tracking control
Q    = diag([100,10]);
R    = 1;
N    = 50;
uint = 0;
% infinite horizon cost (P can be used as initial cost-to-go for
% convergence improvements)
% [K, P] = dlqr(A, B, Q, R);
% ======================================================================= %
%% Step III: Gridding the state space
% ======================================================================= %
x1 = linspace (-pi/4, pi/4, 10);
x2 = linspace (-pi/2, pi/2, 5);
U  = zeros(length(x1), length(x2), N);
J  = zeros(length(x1), length(x2), N);
% Convenient options for fminunc
% ======================================================================= %
options = optimoptions(@fminunc,'Display','off',...
                       'Algorithm','quasi-newton');
% ======================================================================= %
%% STEP IV: Stage Cost and cost-to-go
% =======================================================================
% %
% Stage cost
Jstage = @(x,u) x'*Q*x + u'*R*u;
% Cost-to-go
Jtogo = @(x) x'*Q*x;
%Jtogo = @(x) x'*P*x;

% DP recursion
% Start timer
tic
for n = 1 : N
    disp(n)
    for i = 1:length(x1)
        for j = 1:length(x2)
            % Current State
            x = [x1(i); x2(j)];
            % Optimal control and Cost-to-go
            u0 = 0;
            opt_func = @(u) Jstage(x,u) + Jtogo(A*x + B*u);
            [U(i,j,n),J(i,j,n)] = fminunc(opt_func,u0,options);
        end
    end
    % Interpolated cost to go
    Jtogo = @(x) interp2(x1,x2,J(:,:,n)',x(1),x(2),'spline');
end
% Stop timer
toc
% ======================================================================= %
%% STEP V: Save optimal control
% ======================================================================= %
save("DP_TV_L.mat", "U", "x1", "x2")
% ======================================================================= %
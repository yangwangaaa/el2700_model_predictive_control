% Paths
% =================================== %
addpath('../assignment_1')
% =================================== %

% Parameters of Cart-Pendulum System
% =================================== %
load('../data/pendulum_parameters.mat', 'params')
M   = params.M;          
m   = params.m;
bc  = params.bc;
l   = params.l;
I   = params.I;
bp  = params.b;
g   = params.g;
% =================================== %

% Initial conditiom
% =================================== %
x0 = 0;
xdot0 = 0;
theta0 = 0.1;
thetadot0 = 0;
X0 = [x0; xdot0; theta0; thetadot0];
% ================================== %

% Reference position
% ================================== %
r = 10;
% ================================== %

% Control sampling time
% ================================== %
h  = params.h;
% ================================== %

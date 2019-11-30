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
X0 = [0; 0; pi/6; 0];
% ================================== %
% Control sampling time
% ================================== %
h  = params.h;
% ================================== %
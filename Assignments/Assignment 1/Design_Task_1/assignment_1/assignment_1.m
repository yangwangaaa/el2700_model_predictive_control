%% Instructions
% =============================================================== %
% Skeleton file for assignment 1
% Do not edit lines between = delimiters.
% Fill in the required values between - delimiters.
% --------------------------------------------------------------- %
% Clear
clear all; close all; clc;
% =============================================================== %
%% Load parameters of the cart-pendulum System
% =============================================================== %
load('../data/pendulum_parameters.mat', 'params')
M   = params.M;          
m   = params.m;
bc  = params.bc;
l   = params.l;
I   = params.I;
bp  = params.b;
g   = params.g;
Ts  = params.h;
% =============================================================== %
%% I. System modeling
% =============================================================== %
% Linearize continuous-time dynamics around the upright position
v1 = (m+M)/(I*(m+M)+m*M*(l^2));
v2 = (I + m*(l^2))/(I*(m+M)+m*M*(l^2));
Ac = [0 1 0 0; 
    0 -bc*v2 ((m^2)*(l^2)*g*v2)/(I+m*(l^2)) -(m*l*bp*v2)/(I+m*(l^2));
    0 0 0 1;
    0 -(m*l*bc*v1)/(m+M) m*g*l*v1 -bp*v1];
Bc = [0;v2;0;(m*l*v1)/(m+M)];
Cc = [1 0 0 0];
Dc = 0;
% Convert to continuous-time system
sys = ss(Ac, Bc, Cc, Dc);        
% -------------------------------------------------------------- %
% Discretize the continous-time linear system
% -------------------------------------------------------------- %
sysd = c2d(sys,0.1)
A = sysd.A;
B = sysd.B;
C = sysd.C;
% -------------------------------------------------------------- %
% Verify the resulting continuous-time and discrete-time model
% -------------------------------------------------------------- %
verify(Ac, Bc, Cc, Dc, A, B)
% ============================================================== %         
%% II. Controller design
% ============================================================== %
% Desired closed loop poles
p1   = 0.92;
p2   = 0.915;
p3   = 0.90;
p4   = 0.875;

p_cl = [p1, p2, p3, p4];
% Feedback gain
L   = place(A,B,p_cl);
% Feedforward gain
Id = eye(4,4);
lr   = 1/((C/(Id-(A-(B*L))))*B);
% Enable disturbance
% 0 := disturbance not included
% 1 := disturbance included
dist_enable = 0;
% Realized disturbance magnitude
w = 0.01;              
% ============================================================== %
%% III. Save design
% ============================================================== %          
save('statefeedback.mat','L', 'lr', 'dist_enable', 'w')
% ============================================================== %
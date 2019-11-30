% ======================================== %
% Clear
% ======================================== %
clear; close all;
clc;
% ======================================== %
% Prepare simulation
% ======================================== %
addpath('../simulation')
run('prepare_sim.m')
% ======================================== %


% Assignment 3: Linear quadratic regulator
% ======================================== %
%% Enable or disable disturbance
% Load data
load('lqr.mat')
params.dist_enable = dist_enable;
params.w           = w;  
params.enable_OF   = enable_OF;

% Controller parameters
params.L  = L;           % State feedback gain
params.li = li;          % Integral gain for error free tracking
params.lr = lr;          % Feed-forward gain for reference tracking

% Output matrix
params.Cp = Cp;

% Kalman filter state space parameters
params.AK = sysK.A;
params.BK = sysK.B(:,1);
params.CK = sysK.C;
params.DK = sysK.D(:,1);

% Kalman filter noise covariance matrices
params.QK = Qp;
params.RK = Rn;
% ======================================== %
% Run simulation
% ======================================== %
t = sim('cart_pend');
% ======================================== %
% Post process simulation results
% ======================================== %
run('post_sim.m')
% ======================================== %

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
% Load data
load('lqr.mat')

% Enable disturbance realization
params.dist_enable = dist_enable;
params.w = w;

% Enable output feedback controller
params.enable_OF = enable_OF;

% Output matrix
params.Cp = Cp;

% Controller parameters
params.L  = L;           % State feedback gain
params.li = li;          % Integral gain for error free tracking
params.lr = lr;          % Feed-forward gain for reference tracking

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

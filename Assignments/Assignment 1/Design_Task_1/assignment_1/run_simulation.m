% ======================================== %
% Clear
% ======================================== %
clear all; close all;
clc;
% ======================================== %
% Prepare simulation
% ======================================== %
addpath('../simulation')
run('prepare_sim.m')
% ======================================== %
% Assignment 1: State feedback
% ======================================== %
% Load data
load('statefeedback.mat')

% Enable disturbance realization
params.dist_enable = dist_enable;
params.w           = w;

% Controller parameters
params.L  = L;      % State feedback gain
params.lr = lr;    % Feed-forward gain for reference tracking

% ======================================== %
% Run simulation
% ======================================== %
t = sim('cart_pend');
% ======================================== %
% Post process simulation results
% ======================================== %
run('post_sim.m')
% ======================================== %
% Animation
% ======================================== %
% run('animation.m')
% ======================================== %

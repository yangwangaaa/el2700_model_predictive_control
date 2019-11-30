% This script is written to provide parameters of pendulum-cart assembly
% for simulations and controller design

params.M  = 0.5;    % mass of the cart in kg
params.m  = 0.2;    % mass of the pendulum in kg
params.bc = 0.1;    % coefficient of friction for cart in N/m/s
params.l  = 0.3;    % length of the pendulum center of mass in m
params.I  = 0.006;  % mass moment of inertia of the pendulum in kg-m^2
params.b  = 0.012;  % coefficient of friction for pendulum in N-m-s
params.g  = 9.8;    % acceleration due to gravity in m/s^2
params.h  = 0.1;    % sampling time in s

save('pendulum_parameters.mat')
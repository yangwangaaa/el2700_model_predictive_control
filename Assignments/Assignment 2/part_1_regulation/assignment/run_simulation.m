% Assignment 2: Finite time Dynamic programming
% Part 2: Regulation
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
% Run simulation
% ======================================== %
t = sim('inverted_pend');
% ======================================== %
% Post process simulation results
% ======================================== %
run('post_sim.m')
% ======================================== %
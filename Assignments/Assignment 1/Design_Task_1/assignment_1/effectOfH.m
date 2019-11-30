clear all; close all; clc;
%% Effect of changing h on discrete time poles
syms h
%h_array = [0.01,0.02,0.05,0.1,0.5,1,2,10,100];
%n = size(h_array);
pole_arr1 = [];
pole_arr2 = [];

load('../data/pendulum_parameters.mat', 'params')
m   = params.m;
l   = params.l;
I   = params.I;
bp  = params.b;
g   = params.g;

a0 = -(m*g*l)/(I+(m*l)^2);
a1 = bp/(I+(m*l)^2);
b0 = m*l/(I+(m*l)^2);

for h = 0.01:0.01:0.7
    Ac = [0 1; -a0 -a1];
    Bc = [0; b0];
    Cc = [1 0];
    Dc = 0;
    cont_sys = ss(Ac,Bc,Cc,Dc);
    disc_sys = c2d(cont_sys,h);
    A = disc_sys.A;
    
    pole_d = eig(A);
    pole_c = eig(Ac);
    
    pole_arr1 = [pole_arr1;pole_d(1)];
    pole_arr2 = [pole_arr2;pole_d(2)];
end
figure(1)
h = 0.01:0.01:0.7;
plot(h',pole_arr1)
hold on
xlabel('Sampling interval (h)');
ylabel('Pole locations');
title('Pole1')
hold off

figure(2)
h = 0.01:0.01:0.7;
plot(h',pole_arr2,'r')
hold on
xlabel('Sampling interval (h)');
ylabel('Pole locations');
title('Pole2')
hold off

%% Verify the relation between CTS and DTS poles
for j=0.01:0.01:0.7
    vrf_1 = [];
    vrf_2 = [];
    vrf_1 = [vrf_1; exp(pole_c(1)*h)];
    vrf_2 = [vrf_2; exp(pole_c(2)*h)];
end
% figure(3)
% plot(h',pole_arr1,h',vrf_1');
% plot(h',pole_arr2,h',vrf_2');


err1 = pole_arr1 - vrf_1';
err2 = pole_arr2 - vrf_2';

figure(3)
errorbar(h',pole_arr1,err1,':b')
hold on
xlabel('Sampling interval (h)');
ylabel('Pole Location');
title('Error Plot between DTS pole1 and Z_1 = e^{S_1*h}' )
hold off

figure(4)
errorbar(h',pole_arr2,err2,':r')
hold on
xlabel('Sampling interval (h)');
ylabel('Pole Location');
title('Error Plot between DTS pole2 and Z_2 = e^{S_2*h}' )
hold off
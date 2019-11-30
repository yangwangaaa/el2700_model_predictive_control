function [doubletank_d,h10,h20,u0] = DiscreteLinear(lin_level,NN)
    % --- MODEL USED IN SIMULATION MODEL --- %
    d1=4.0e-3; d2=4.0e-3;
    D =44.45e-3;
    max_in=46.8e-6;
    alpha1=d1^2/D^2;
    alpha2=d2^2/D^2;
    gamma=alpha2/alpha1;
    beta=max_in/3/(pi/4*D^2);
    g=9.81;
    
    % --- MODEL PARAMETER CALCULATION --- %
    h20    = lin_level*0.25/100; % lin_level is 100% scale
    h10    = h20/gamma^2; % gamma is 1 in this case because both tanks are the same
    u0     = 1/beta*alpha1*sqrt(2*g*h10);
    tau    = 1/alpha1*sqrt(2*h10/g);
    
    % --- STATE SPACE --- %
    Ac = [-1/tau,             0
           1/tau, -1/(gamma*tau)];
    Bc = [beta; 0];
    Cc = eye(2);
    Dc = zeros(2,1);
    
    doubletank_c = ss(Ac,Bc,Cc,Dc);
    doubletank_d = c2d(doubletank_c,0.05*NN,'zoh');
end

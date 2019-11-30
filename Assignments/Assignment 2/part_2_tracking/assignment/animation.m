%% Load data
x = t.Position.Data;
time = t.Position.Time;
theta = t.Theta.Data;

%% Simulate the motion of Cart-Pendulum System
figh = figure;

for k = 1:40:length(x)
    clf
    xk = x(k);
    thetak = theta(k);
    tk = time(k);
    
    hold on
    
    %% Cart simulation
    Cart = [-5 + xk, 5 + xk, 5 + xk, -5 + xk; 1, 1, 6, 6];
    fill(Cart(1,:), Cart(2,:), [0.5 0.5 0.5])
    
    
    %% Wheel simulation
    wheel_b = [-4 + xk, -1, 2, 2];
    wheel_f = [ 2 + xk, -1, 2, 2];
    rectangle('Position', wheel_b,  'Curvature',[1 1], 'FaceColor', 'k')
    rectangle('Position', wheel_f,  'Curvature',[1 1], 'FaceColor', 'k')
    
    %% Inverted Pendulum simulation
    
    % Position update
    Pend = [-0.25 + xk, 0.25 + xk, 0.25 + xk, -0.25 + xk; 3.5, 3.5, 23.5, 23.5];
    Pend_orgn = [ (Pend(1,1) + Pend(1,2))/2 ;(Pend(2,1) + Pend(2,2))/2];
   
    % Angle update
    c = cos(thetak);
    s = sin(thetak);
    R = [c -s; s c];
    Pend = R*(Pend - Pend_orgn) + Pend_orgn;
    fill(Pend(1,:), Pend(2,:), [0.5 0.5 0.5])
    
    %% Ball simulation
    radius = 1;
    center = [(Pend(1,3) + Pend(1,4))/2 , (Pend(2,3) + Pend(2,4))/2];
    %viscircles(center,radius, 'color', 'k', 'EnhanceVisibility', 1);
    th           = linspace(0,2*pi, 100);
    RHO          = ones(1,100)*radius;
    [xcen, ycen] = pol2cart(th,RHO);
    xball        = xcen + center(1);
    yball        = ycen + center(2);
    h1           = fill(xball, yball, 'k');
    
    %% Road Simulation
    road_x = [-10 15];
    road_y = [-1.2 -1.2];
    h = animatedline(road_x, road_y,'Color',[0.4660, 0.6740, 0.1880],'LineWidth',3);
    
    %% Axis setting
    axis([-20 30 -1.35 40])
    title(['At t =', num2str(tk),'seconds, Cart position is x=' num2str(xk),'m and Pendulum anle is \theta =' num2str(thetak), 'radian'])
    pause(1e-6);
end


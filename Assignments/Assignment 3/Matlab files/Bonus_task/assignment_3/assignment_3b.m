clear all; close all; clc;
%% Assignment 3: Linear Quadratic Regulator
% =============================================================== %
% Instructions 
% --------------------------------------------------------------- %
% Do not edit lines between = delimiters.
% Fill in the required values between - delimiters.
% --------------------------------------------------------------- %

%% Load parameters of the cart-pendulum System
load_script

% Enable or disable disturbance
% 0 := disturbance not included
% 1 := disturbance included
dist_enable = 

% Realized disturbance magnitude
% dist_enable = 0 := w = 0
% dist_enable = 1 := w = 0.01
w = 

% Select the controller whose parameters you want to save
% 0 := Linear Quadratic Controller
% 1 := Error free reference tracking
% 2 := Output feedback control
Type = 0; 

switch(Type)
    
    %% Part I
    case 0
    % Verify that the system is reachable and explain why is this
    % important. Use the MATLAB command ctrb to compute the
    % controllability matrix.
    % Answer: 
       

    % Select penalty matrices
    Q =   
    R =  
   
   
    % Comment your intuition behind the final selection of Q and R
    % Answer: 
    
    % Calculate the feedback gain
    L =  

    % Calculate the feedforward gain
    lr =  
    
    
    % How is the performance of this controller? Does the controller meet the desired performance
    % specification?
    % Answer:
    
    % Set the disturbance to zero and evaluate the performance of this controller in simulations.  
    % How does this controller track the constant reference?
    % Answer:
    
    
    % Is the performance of this controller similar to that of finite-time dynamic programming
    % formulation in the last design project? Make sure that you have used same initial states 
    % in both the simulations. Compare the controllers in terms of computational time. Do not 
    % forget to include the time to generate DP_TV_L_FS_.mat file.
    % Answer:
    
    
    % DO NOT EDIT THIS PART
    % ----------------------- %
    li = 0;
    enable_OF = 0; 
    Cp = [1 0 0 0;
          0 0 1 0];
    sysK = ss(A, [B Bw], Cp, 0, h,'inputname',...
             {'u' 'w'},'outputname','y');
    Qp = 1;
    Rn = 1; 
    % ----------------------- %

    %% PART II. Adding integral action    
    case 1
        
    % Form augmented System 
    Aa =  
    Ba =  

    % Adjust the weight matrices to meet desired performance specification, and motivate your choice. 
    % Answer:
    Q  =   
    R  =  
      
    % Calculate feedback gain [L li] using dlqr
    K  =  

    % Extract the state feedback gain L 
    L  =  
 
    % Extract the integral gain li
    li =  
    
    % Calculate the feedforward gain
    lr =   
    
    % Is the controller eliminating the step disturbance. How is the performance of the controller
    % in terms of overshoot and settling time as compared to the linear one?
    % Answer:
    
    
    % Is the controller performing better as compared to finite-time dynamic programming formulation 
    % with disturbance? Make sure that you have used same initial states in both the simulations. 
    % Do not forget to include distubance in your dynamic programming simulation
    % Answer: 
    
    % DO NOT MODIFY THIS PART
    % ----------------------- %
    enable_OF = 0; 
    Cp = [1 0 0 0;
          0 0 1 0];
    sysK = ss(A, [B Bw], Cp, 0, h,'inputname',...
                {'u' 'w'},'outputname','y');
    Qp = 1;
    Rn = 1; 
    % ----------------------- %

    %% PART III. Output feedback controller 
    case 2
    
    % Select the output matrix 
    % Use the best candidate for output matrix as concluded in the last task
    Cp =  
    
    % Form the augmented system (copy from the previous part)
    Aa =  
    Ba = 
    
    % Select Penalty Matrices (copy from the previous part)
    Q  =  
    R  =  
    
    % Calculate the feedback gain using dlqr (copy from the previous part)
    K  =  

    % Extract the state feedback gain L (copy from the previous part)
    L  =      
    
    % Extract the integral gain li (copy from the previous part)
    li =   
    % Calculate the feedforward gain
    lr =  
    
    % Select the noise covariance matrix
    Qp =  
    Rn =  
    
    % Is output feedback controller's performance satisfactory? 
    % Answer:
    
    
    % As the linear model is valid near the upright position of the
    % pendulum, change the initial state X0 to [0; 0; 0; 0] in 
    % prepare_sim.m file under simulation folder. 
    % Is the output feedback controller performing better??
    % Answer:
    
    
    
    % If you fail to get a satisfatory performance, investigate what might be the problem. Is the
    % problem related to the controller you have designed or your estimator?
    % Answer:
    
    
    
    % If you think that the problem is caused by your estimator, recommend some alternative estimation 
    % approaches.
    % Answer:
    
    
    % DO NOT MODIFY THIS PART
    % ----------------------- %
    % State estimation
    enable_OF = 1; 
    
    % Kalman Filter model
    sysK = ss(A, [B Bw], Cp, 0, h,'inputname',{'u' 'w'},'outputname','y');
    % ----------------------- %
    
    
end
   
 
% ============================================================== %
%% Save design
% ============================================================== %
save('lqr.mat','L','li', 'lr', 'dist_enable', 'w',...
      'enable_OF', 'sysK', 'Qp', 'Rn', 'Type', 'Cp')
% ============================================================== %
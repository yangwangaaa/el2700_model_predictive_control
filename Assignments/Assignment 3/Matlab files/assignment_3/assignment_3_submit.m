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
dist_enable = 1;

% Realized disturbance magnitude
% dist_enable = 0 := w = 0
% dist_enable = 1 := w = 0.01
w = 0.01;  

% Select the controller whose parameters you want to save
% 0 := Linear Quadratic Controller
% 1 := Error free reference tracking
% 2 := Output feedback control
Type = 2; 

switch(Type)
    
    %% Part I
    case 0
    % Verify that the system is reachable and explain why is this
    % important. Use the MATLAB command ctrb to compute the
    % controllability matrix.
    % Answer: The rank of the reachability matrix was found to be 4 which
    % is equal to the order of the matrix(n). Thus, the system is verified to
    % be reachable. It is essential to check this because reachability
    % means that starting from the initial condition, every state can be
    % reached in a finite time if a proper input is applied. And this 
    % property is essential if one wants to control any linear system. If
    % the system is not reachable, we won't be able to find a control input
    % or sequence that would drive the linear discrete time system to the
    % desired state in finite time.
       
    % Start timer
    tic
    % Select penalty matrices
      Q = diag([1.5,1,10,10]);  
      R = 200;
        
   
    % Comment your intuition behind the final selection of Q and R
    % Answer: The first thing to consider is the performance specifications
    % especially, the rise time for the cart position and the angle of
    % pendulum. As the cost function is formulated in terms of the error or
    % difference between the state/input and its corresponding equuilibrium
    % value, first we need to keep the state x_3 very small making the 
    % corresponding entry Q to be high. Similarly the rate of change of the
    % pendulum angle should also be very small making its entry in Q large.
    % Same logic can be applied to the states x_1 and x_2 but there is no
    % need to keep it very high as we have around 8-10 sec buffer for rise
    % time. Now, one thing to note is that, the force on the cart (input)
    % in turn affects the pendulum position. A large change in the control
    % input can make the pendulum deviate from the acceptable range or 
    % even make it unstable. Thus, R should be a very high value.
    
    % Calculate the feedback gain
    [L,~,~] = dlqr(A,B,Q,R);

    % Calculate the feedforward gain
    lr = inv(C*inv(eye(4,4)-(A-(B*L)))*B);  
    
    % End timer
    toc
    
    % Set the disturbance to zero and evaluate the performance of this controller in simulations.  
    % How does this controller track the constant reference? 
    % Answer: The controller tracks the reference without any steady state
    % error and minimum oscillation. It also reaches 90% of its steady
    % state value within 10 sec.
    
    % Is the performance of this controller similar to that of infinite-time dynamic programming
    % formulation in the last project? Compare the controllers in terms of computational time.
    % Answer: This controller is way more efficient in terms of
    % computation time as compared to the infinite horizon based Dynamic
    % Programming formulation.
    
    % Add a small constant disturbance to mimic the presence of horizontal wind force and comment
    % on the tracking ability of the LQR controller. 
    % Answer: When a constant disturbance is applied to the system, the
    % controller fails to attenuate it and is unable to track the reference
    % anymore. As the magnitude of the disturbance is increased, the steady
    % state error increases a lot and the response becomes a bit
    % oscillatory but eventually settles at a value. 
    
    % Is the controller performing better as compared to finite-time dynamic programming formulation 
    % with disturbance? 
    % Answer: According to our observation, both the controllers performed
    % in the similar way except for the computation load.
    
    % DO NOT EDIT THIS PART
    % ----------------------- %
    li = 0;
    enable_OF = 0; 
    Cp = [1 0 0 0];
    sysK = ss(A, [B Bw], Cp, 0, h,'inputname',...
             {'u' 'w'},'outputname','y');
    Qp = 1;
    Rn = 1; 
    % ----------------------- %

    %% PART II. Adding integral action    
    case 1
        
    % Form augmented System 
    Aa =  [A zeros(4,1); -h*C 1];
    Ba =  [B;0];

    % Adjust the weight matrices to meet desired performance specification, and motivate your choice. 
    % Answer:The weight for the cart position is not kept high since it
    % reaches 90% in 10seconds relatively easily. The pendulum angle
    % however depends on the control input, high inputs can result in a large
    % angle, the weights for the input and the angle in the Q and R matrix
    % is kept high. The integral weight is kept higher than the cart
    % position but not too high since it forces the control input to
    % increase to reach ref position thereby changing the pendulum angle. 
    
    Q = diag([0.1,0.1,0.5,0.5,0.015]);  
    R = 125;
      
    % Calculate feedback gain [L li] using dlqr
    K  =  dlqr(Aa,Ba,Q,R);

    % Extract the state feedback gain L
    n = size(K);
    L  = K(1,1:n(2)-1); 
 
    % Extract the integral gain li
    li = K(1,n(2)); 
    
    % Calculate the feedforward gain
    lr = inv(C*inv(eye(4,4)-(A-(B*L)))*B); 
    
    % Is the controller eliminating the step disturbance.
    % Answer: Yes the controller eliminates step disturbance.
    
    % DO NOT MODIFY THIS PART
    % ----------------------- %
    enable_OF = 0; 
    Cp = [1 0 0 0];
    sysK = ss(A, [B Bw], Cp, 0, h,'inputname',...
                {'u' 'w'},'outputname','y');
    Qp = 1;
    Rn = 1; 
    % ----------------------- %

    %% PART III. Output feedback controller 
    case 2
     
    % Select the output matrix 
    Cp = [1 0 0 0;0 0 1 0]; %2 sensors - cart position and pendulum angle - used
   %Cp = [1 0 0 0]; % 1 sensor - cart position - used
   %Cp = [0 0 1 0]; % 1 sensor - pendulum angle - not used

    check = obsv(A,Cp);
    check = rank(check);
    if check == size(A)
        ('Observable with this selection of output matrix')
    else 
        ('Not observable with current output matrix selection')
    end
    
    % Your task is to check observability criterion for all the three
    % choices of Cp mentioned in the report and find out possible candidates
    % for output matrix. Use the MATLAB command obsv to compute 
    % observability matrix.  
    % Answer: Output matrix for pendulum angle can not be used since it
    %it's observability matrix does not have full rank. The other two
    %matrices can be used as their observability matrices have full rank. 
    %The covarience matrix R is made smaller than Q since there is disturbance. 
    %RMSE is reduced by making Q larger. (Using 2 sensors).


    
    % Form the augmented system (copy from the previous part)
    Aa =  [A zeros(4,1); -h*C 1];
    Ba =  [B;0];
%     
%     % Select Penalty Matrices (copy from the previous part)
    Q = diag([0.1,0.1,0.5,0.5,0.015]);  
    R = 125; 
%     
%     % Calculate the feedback gain using dlqr (copy from the previous part)
    K  =  dlqr(Aa,Ba,Q,R); 
% 
%     % Extract the state feedback gain L (copy from the previous part)
    n = size(K);
    L  = K(1,1:n(2)-1);      
%     
%     % Extract the integral gain li (copy from the previous part)
    li = K(1,n(2));   
%     
%     % Calculate the feedforward gain
    lr =  inv(C*inv(eye(4,4)-(A-(B*L)))*B);
%     
%     % Select the noise covariance matrix
    Qp =  1000;
    Rn =  1;
    
    % On comparing the output feedback controller with the state feedback
    % one, we found that the state feedback was better in terms of
    % performance and the main thing is that the State Feedback one was
    % more robust. Here with LQG, the performance depends a lot on the Cp
    % matrix and the noise covariance. 

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
save('lqr.mat','L','li', 'lr', 'dist_enable', 'enable_OF', 'sysK', 'Qp', 'Rn','w', 'Type', 'Cp')
% ============================================================== %
% run_simulation % run in one click 
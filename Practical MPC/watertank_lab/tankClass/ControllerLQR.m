% Controller class: class for hardware
% --- PROPERTY --- %
% Controller.Q:              state cost matrix
% Controller.R:              input cost matrix
% Controller.model:          system model for prediction
% --- METHOD --- %
% Controller.compute(): compute control signal and update reference signal

classdef ControllerLQR < handle
   properties
       % --- LINEARIZATION AND MODEL --- %
       pre_model % discrete state space model
       obs_model % discrete state space model
       observor
       observe_state
       observe_counter
       disturbance_cur
       disturbance
       lin_level
       reference
       Model
       u0
       
       % --- LQR PARAMETERS --- %
       Q
       R
       N % dummy
       Ts
       sin_ref
       ref_flag
       state_ref
       input_ref
       
       % --- LQR RESULTS --- %
       L
       P
       
       % --- CONTROL SIGNAL --- %
       u_cur
       controlSignal_before
       controlSignal_after
       
       % --- OBSERVOR FLAG --- %
       observor_flush
       disturbance_flag
   end
   
   methods
       % --- CONSTRUCTOR --- %
       function obj=ControllerLQR(setting)
           % --- MODEL LINEARIZATION --- %
           [doubletank_d,~,~,obj.u0] = mpcFcn.DiscreteLinear(setting.lin_level,20);
           obj.pre_model=doubletank_d;
           [obs_doubletank_d,~,~,~] = mpcFcn.DiscreteLinear(setting.lin_level,1);
           obj.obs_model=obs_doubletank_d;
           obj.observor=mpcFcn.LQRobservorPrepare(obj);
           obj.observe_state=[0,0];
           obj.observe_counter=0;
           obj.disturbance_cur=0;
           obj.disturbance=0;
           obj.lin_level=setting.lin_level;
           obj.reference=setting.reference;
           
           % --- LQR PARAMETERS AND LQR RESULTS --- %
           obj.Q=setting.Q;
           obj.R=setting.R;
           obj.N=1;
           obj.Ts=setting.Ts;
           [obj.L,obj.P,~]=dlqr(obj.pre_model.A,obj.pre_model.B,obj.Q,obj.R,[0;0]);
           obj.sin_ref=setting.sin_ref;
           obj.ref_flag = false; % false for constant reference, true for sinusoid reference
           obj.state_ref=NaN; % reference for quadprog() cost construction
           obj.input_ref=NaN; % reference for quadprog() cost construction
           
           % --- CONTROL SIGNAL --- %
           obj.u_cur=0;
           obj.controlSignal_before=0;
           obj.controlSignal_after=0;
           
           % --- OBSERVOR FLAG --- %
           obj.observor_flush=false;
           obj.disturbance_flag=false;
       end
       
       % --- METHOD: LQR CALCULATION FOR A NEW SETTING --- %
       function LQR_Prepare(obj)
           [obj.L,obj.P,~] = dlqr(obj.pre_model.A,obj.pre_model.B,obj.Q,obj.R,[0;0]);
       end
       
       % --- METHOD: COMPUTING --- %
       function u_after = compute(obj,x_cur,sys)
           
           % --- CONTROLLING LOWER TANK BY DEFAULT --- %
           if isempty(obj.Model)
               x_cur = (x_cur-obj.reference)/100*0.25;
           else
               x_cur = (x_cur-[obj.reference/obj.Model.gamma,obj.reference])/100*0.25;
           end
           
           % --- DISTURBANCE OBSERVATION --- %
           if obj.disturbance_flag
               obj.disturbance_cur = mpcFcn.LQRobserve(obj,obj.controlSignal_after-obj.u0,x_cur');
               obj.disturbance = (obj.disturbance*obj.observe_counter+obj.disturbance_cur)/(obj.observe_counter+1);
               obj.observe_counter=obj.observe_counter+1;
           else
               obj.disturbance_cur = 0;
               obj.disturbance = 0;
           end
           
           % --- REFERENCE CALCULATION & STORAGE --- %
           % TAKE THE ADVANTAGE OF MPC REFERENCE BUIDLING FUNCTION
           if obj.ref_flag
               [state_ref_dummy,input_ref_dummy] = mpcFcn.sinRef_preview_off(obj,sys);
               obj.state_ref = state_ref_dummy(2); % controller lower tank by default
               x_cur = x_cur+(obj.reference-state_ref_dummy(1:2))/100*0.25; % controller lower tank by default
               obj.input_ref = input_ref_dummy(1);
           else
               [state_ref_dummy,input_ref_dummy] = mpcFcn.conRef_preview_off(obj,sys);
               obj.state_ref = state_ref_dummy(2); % controller lower tank by default
               obj.input_ref = input_ref_dummy(1);
           end
           
           % --- INPUT SATURATION --- %
           u_before = -obj.L*x_cur'+obj.input_ref-obj.disturbance_cur;
           u_after = min(3,max(u_before,0)); % input voltage saturation
           
           % --- CONTROLLER UPDATING --- %
           obj.controlSignal_before = u_before;
           obj.controlSignal_after = u_after;
           
           % --- SYSTEM REFERENCE UPDATE --- %
           sys.ref = obj.state_ref;
       end
       
   end
end

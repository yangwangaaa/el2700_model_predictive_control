% --- PROPERTY --- %
% MPC.pre_model: prediction model
% MPC.obs_model: observation model with sampling time 0.05s
% MPC.observor: augmented model for disturbance based on MPC.obs_model
% MPC.lin_level: 1-100 scale for model linearization
% MPC.u0: steady state input for MPC.line_level

% MPC.Q: state cost matrix
% MPC.R: input cost matrix
% MPC.N: prediction horizon
% MPC.NN: prediction samples for each prediction step
% MPC.Ts: sampling time, 0.05s by default
% MPC.sin_ref: structure storing amplitude and frequency

% MPC.u_predict: prediction input from quadprog()
% MPC.x_predict: prediction state from quadprog()
% MPC.controlSignal_before
% MPC.controlSignal_after

% MPC.preview: true/false, reference preview flag
% MPC.option: optimization flag for quadprog()
% MPC.filter_flush: true/false, dummy
% MPC.observor_flush: true/false, flag for observor state flush
% MPC.disturbance_flag: true/false activation flag for disturbance obs

% --- METHOD --- %
% Controller.compute(): compute control signal and update reference siganl

classdef ControllerMPC_CloseLoop < handle
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
       
       % --- MPC PARAMETER --- %
       Q
       R
       Qf
       ricatti_Qf
       N
       NN
       Ts
       ref_flag % 'true' for sin, 'false' for constant
       sin_ref
       state_ref % reference for quadprog() cost construction
       input_ref % reference for quadprog() cost construction
       
       % --- MPC RESULT --- %
       u_predict
       x_predict
       controlSignal_before
       controlSignal_after
       
       % --- MPC OPTION & FLAGS --- %
       option
       preview
       input_constraint
       input_constraint_min
       input_constraint_max
       state_constraint
       state_constraint_min
       state_constraint_max
       observor_flush
       disturbance_flag
       pre_input_flag
       pre_tank1_flag
       pre_tank2_flag
       pre_ref_flag
   end
   
   methods
       % --- CONSTRUCTOR --- %
       function obj=ControllerMPC_CloseLoop(setting)
           % --- MODEL LINEARIZATION --- %
           [doubletank_d,~,~,u0] = mpcFcn.DiscreteLinear(setting.lin_level,setting.NN);
           [obs_doubletank_d,~,~,~] = mpcFcn.DiscreteLinear(setting.lin_level,1);
           obj.pre_model=doubletank_d;
           obj.obs_model=obs_doubletank_d;
           obj.observor=mpcFcn.MPCobservorPrepare(obj);
           obj.observe_state=[0,0];
           obj.observe_counter=0;
           obj.disturbance_cur=[0;0];
           obj.disturbance=[0;0];
           obj.lin_level=setting.lin_level;
           obj.reference=setting.reference;
           obj.u0=u0;
           
           % --- MPC PARAMETER --- %
           obj.Q    =setting.Q;
           obj.R    =setting.R;
           obj.Qf   =setting.Q;
           [P,~,~] = dare(doubletank_d.A,doubletank_d.B,obj.Q,obj.R);
           obj.ricatti_Qf = P;
           obj.N    =setting.N;
           obj.NN   =setting.NN; % prediction steps of the discrete system
           obj.Ts   =setting.Ts;
           obj.ref_flag = false; % 'true' for sin, 'false' for constant
           obj.sin_ref=setting.sin_ref;
           obj.state_ref = NaN(setting.N,1);
           obj.input_ref = NaN(setting.N,1);
           
           % --- MPC RESULT --- %
           obj.u_predict=zeros(setting.N,1);
           obj.x_predict=zeros(setting.N,2);
           obj.controlSignal_before=3;
           obj.controlSignal_after=3;
           
           % --- MPC OPTION & FLAGS --- %
           obj.option=setting.option;
           obj.preview          =false;
           obj.input_constraint =false;
           obj.input_constraint_min =0;
           obj.input_constraint_max =100;
           obj.state_constraint =false;
           obj.state_constraint_min =0;
           obj.state_constraint_max =100;
           obj.observor_flush   =false;
           obj.disturbance_flag =false;
           obj.pre_input_flag   =true;
           obj.pre_tank1_flag   =true;
           obj.pre_tank2_flag   =true;
           obj.pre_ref_flag     =true;
       end
       
       % --- METHOD: COMPUTING --- %
       function u_after = compute(obj,x_cur,sys)
           
           % --- INTERFACE STATE --- %
           if isempty(obj.Model)
               x_cur = (x_cur-obj.lin_level)/100*0.25; % but default, the model is linearized at 40
           else
               x_cur = (x_cur-[obj.Model.h10,obj.Model.h20])/100*0.25;
           end
           
           % --- DISTURBANCE OBSERVATION AND AVERAGING --- %
           if obj.disturbance_flag
               obj.disturbance_cur = mpcFcn.MPCobserve(obj,obj.u_predict(1,1),x_cur');
               obj.disturbance = (obj.disturbance*obj.observe_counter+obj.disturbance_cur)/(obj.observe_counter+1);
               obj.observe_counter=obj.observe_counter+1;
           else
               obj.disturbance_cur = [0;0];
               obj.disturbance = [0;0];
           end
           
           % --- REFERENCE BUILDING --- %
           if obj.ref_flag
               if obj.preview
                   [obj.state_ref, obj.input_ref] = mpcFcn.sinRef_preview_on(obj,sys);
               else
                   [obj.state_ref, obj.input_ref] = mpcFcn.sinRef_preview_off(obj,sys);
               end
           else
               [obj.state_ref, obj.input_ref] = mpcFcn.conRef_preview_off(obj,sys);
           end
           
           if isempty(obj.Model)
               obj.state_ref = (obj.state_ref-obj.lin_level)/100*0.25;
           else
               obj.state_ref = (obj.state_ref-kron(ones(1,obj.N),[obj.Model.h10,obj.Model.h20]))/100*0.25;
           end
           obj.input_ref = obj.input_ref-obj.u0;
           
           % --- OPTIMIZATION COST & CONSTRAINT -> OPTIMIZE --- %
           H = mpcFcn.costMatrix(obj);
           ref = [ obj.state_ref, obj.input_ref ];
           f = -(ref*H)';
           [Aeq,beq] = mpcFcn.EconstraintMatrix(obj,x_cur);
           [lb,ub] = mpcFcn.lbub(obj);
           xopt = quadprog(H,f,[],[],Aeq,beq,lb,ub,[],obj.option);
           
           % --- OPTIMIZATION RESULT PARSING --- %
           obj.u_predict = xopt(end-obj.N+1:end,1);
           obj.x_predict = reshape(xopt(1:end-obj.N,1),[2,obj.N])';
           
           % --- INPUT SATURATION --- %
           u_cur = obj.u_predict(1,1)+obj.u0;
           u_before = u_cur;
           u_after = min(3,max(u_before,0)); % input voltage saturation
           
           % --- CONTROLLER FILTERING AND UPDATING --- %
           obj.controlSignal_before = u_before;
           obj.controlSignal_after = u_after;
       end
   end
end

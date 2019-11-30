% --- PROPERTY --- %
% MPC.pre_model: prediction model
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
% Controller.compute(): compute control signal and and update reference siganl

classdef ControllerMPC_OpenLoop < handle
   properties
       % --- LINEARIZATION AND MODEL --- %
       pre_model
       disturbance % dummy
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
       ref_flag
       sin_ref
       state_ref
       input_ref
       
       % --- MPC RESULT --- %
       u_predict
       x_predict
       controlSignal_before
       controlSignal_after
       controlSignal_store
       reference_store
       counter_start
       
       % --- MPC OPTION & FLAGS --- %
       option
       preview
       input_constraint
       input_constraint_min
       input_constraint_max
       state_constraint
       state_constraint_min
       state_constraint_max
       observor_flush   % dummy 
       disturbance_flag % dummy
       pre_input_flag
       pre_tank1_flag
       pre_tank2_flag
       pre_ref_flag
   end
   
   methods
       % --- CONSTRUCTOR --- %
       function obj=ControllerMPC_OpenLoop(setting)
           % --- MODEL LINEARIZATION --- %
           [doubletank_d,~,~,u0] = mpcFcn.DiscreteLinear(setting.lin_level,setting.NN);
           obj.pre_model=doubletank_d;
           obj.disturbance=0; % dummy
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
           obj.ref_flag =false;
           obj.sin_ref=setting.sin_ref;
           obj.state_ref = NaN(setting.N,1);
           obj.input_ref = NaN(setting.N,1);
           
           % --- MPC RESULT --- %
           obj.u_predict=zeros(setting.N,1);
           obj.x_predict=zeros(setting.N,2);
           obj.controlSignal_before=zeros(setting.N*setting.NN,1);
           obj.controlSignal_after=0;
           obj.controlSignal_store=obj.controlSignal_before;
           obj.reference_store=NaN(setting.N*setting.NN,1);
           
           % --- MPC OPTION & FLAGS --- %
           obj.option=setting.option;
           obj.preview          =false;
           obj.input_constraint =false;
           obj.input_constraint_min =0;
           obj.input_constraint_max =100;
           obj.state_constraint =false;
           obj.state_constraint_min =0;
           obj.state_constraint_max =100;
           obj.observor_flush   =false; % dummy
           obj.disturbance_flag =false; % dummy
           obj.pre_input_flag   =false;
           obj.pre_tank1_flag   =false;
           obj.pre_tank2_flag   =false;
           obj.pre_ref_flag     =false;
       end
       
       % --- METHOD: LONG PREDICTION HORIZON CALCULATION --- %
       function MPC_OpenLoop_Prepare(obj,x_cur,sys)
           tic;
           obj.counter_start=sys.counter;
           % --- INTERFACE STATE --- %
           x_cur = (x_cur-obj.lin_level)/100*0.25;
           
           % --- SINUSOID PREVIEW --- %
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
           
           % --- controlStore FILLING --- %
           for i = 1:obj.N
              obj.controlSignal_before(1+(i-1)*obj.NN:obj.NN+(i-1)*obj.NN,1) = (obj.u_predict(i,1)+obj.u0)*ones(obj.NN,1);
              obj.reference_store(1+(i-1)*obj.NN:obj.NN+(i-1)*obj.NN,1) = obj.state_ref(i)/0.25*100*ones(obj.NN,1)+obj.lin_level;
           end
           obj.controlSignal_store = min(3,max(obj.controlSignal_before,0));
           
           % --- OPEN LOOP MPC CALCULATION TIME REPORT --- %
           MPC_OpenLoop_time = toc;
           fprintf('Open loop MPC with horizon %d is prepared in %1.3f seconds\n',obj.N,MPC_OpenLoop_time)
       end
       
       % --- METHOD: COMPUTING --- %
       function compute(obj,~,sys)
           if sys.counter-obj.counter_start<length(obj.controlSignal_store)
               obj.controlSignal_after = obj.controlSignal_store(sys.counter+1-obj.counter_start,1);
               sys.ref=obj.reference_store(sys.counter+1-obj.counter_start,1);
           else
               obj.controlSignal_after = obj.controlSignal_store(end,1);
               sys.ref = NaN;
           end
           
       end
       
   end
end

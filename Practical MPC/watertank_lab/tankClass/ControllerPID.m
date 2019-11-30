% Controller class: class for hardware
% --- PROPERTY --- %
% Controller.I_state:              history error integration term                                   [1x1]
% Controller.D_state:              last sampling storing                                            [1x1]
% Controller.controlSignal_before: for AntiWindUp, control signal before control signal saturation  [1x1]
% Controller.controlSignal_after:  for AntiWindUp, control signal after control signal saturation   [1x1]
% Controller.controlSignal_max:    for AntiWindUp, control signal saturation value                  [1x1]
% Controller.AntiWindUp_flag:      for AntiWindUp, activation flag                                  [1x1]
% Controller.K:   controller parameter                                             [1x1]
% Controller.Ti:  controller parameter                                             [1x1]
% Controller.Td:  controller parameter                                             [1x1]
% Controller.N:   low pass filter parameter for controller derivative part
% Controller.Ts:  controller sampling time                                         [1x1]
% --- METHOD --- %
% Controller.compute(): compute control signal and update I_state & D_state

classdef ControllerPID < handle
   properties
       D_state
       De
       Ie
       controlSignal_before
       controlSignal_after
       controlSignal_max
       AntiWindUp_flag
       K
       Ti
       Td
       N
       Ts
   end
   methods
       % --- CONSTRUCTOR --- %
       function obj=ControllerPID(K,Ti,Td,Ts,u_max)
           obj.D_state=0;
           obj.De = 0;
           obj.Ie = 0;
           obj.controlSignal_before=0;
           obj.controlSignal_after=0;
           obj.controlSignal_max=u_max;
           obj.K=K;
           obj.Ti=Ti;
           obj.Td=Td;
           obj.Ts=Ts;
           obj.N=1;
       end
       
       % --- METHOD: COMPUTING --- %
       function u_after = compute(obj,sample,sys)

           % --- ERROR CALCULATION --- %
           ref = sys.ref;
           sample = sample(1,sys.tankChoice);
           e = ref-sample;
           
           % --- DERIVATIVE CONTROL WITH LOW PASS FILTER --- %
           obj.De = obj.N/(obj.N*obj.Ts+1)*sample - obj.D_state;
           obj.D_state = (obj.N*sample - obj.De)/(obj.N*obj.Ts+1);

           % --- ANTI WIND UP --- %
           obj.Ie = obj.Ie + e*obj.Ts;
           if obj.AntiWindUp_flag
               dummy = obj.controlSignal_before - obj.controlSignal_max;
               if dummy>0
                   e_anti = (100/obj.controlSignal_max)*dummy; % scale back to 100
               else
                   e_anti = 0;
               end
           else
               e_anti = 0;
           end
           obj.Ie = obj.Ie - e_anti*obj.Ts;
           
           % --- INPUT SATURATION --- %
           u_before = obj.K*(e + (1/obj.Ti)*obj.Ie - obj.Td*obj.De);
           u_before = (obj.controlSignal_max/100)*u_before; % scale back to voltage
           u_after = min(obj.controlSignal_max,max(u_before,0)); % input voltage saturation
           
           % --- CONTROLLER UPDATING --- %
           obj.controlSignal_before = u_before;
           obj.controlSignal_after = u_after;
       end
   end
end

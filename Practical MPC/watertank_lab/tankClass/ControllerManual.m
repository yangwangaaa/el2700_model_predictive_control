% Controller class: class for hardware
% --- PROPERTY --- %
% Controller.controlSignal_before: control signal before control signal saturation  [1x1]
% Controller.controlSignal_after:  control signal after control signal saturation   [1x1]
% Controller.controlSignal_max:    control signal saturation value                  [1x1]
% --- METHOD --- %
% Controller.compute(): compute control signal, 'sample' is a dummy input
% for consistance with class: ControllerPID

classdef ControllerManual < handle
   properties
       controlSignal_before
       controlSignal_after
       controlSignal_max
       filter_flush % dummy variables to be consistent with controllerPID
   end
   methods
       % --- CONSTRUCTOR --- %
       function obj=ControllerManual(u_max)
           obj.controlSignal_before=0;
           obj.controlSignal_after=0;
           obj.controlSignal_max=u_max;
           obj.filter_flush=false;
       end
       
       % --- METHOD: COMPUTING --- %
       function u_after = compute(obj,~,~)
           u_before = (obj.controlSignal_max/100)*obj.controlSignal_before; % scale back to voltage
           u_after = min(obj.controlSignal_max,max(u_before,0)); % input voltage saturation
           
           % --- CONTROLLER UPDATING --- %
           obj.controlSignal_after = u_after;
           
           
           app.system.ref=NaN;
       end
   end
end

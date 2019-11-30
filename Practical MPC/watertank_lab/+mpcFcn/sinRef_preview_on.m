% output state_ref is a 100% scale variable.
% output input_ref is a 0-3 scale variable.

function [state_ref, input_ref] = sinRef_preview_on(controller,system)
    % --- STATE REFERENCE CALCULATION--- %
    t_start = (system.counter) * system.Ts;
    t_end   = (system.counter + controller.N * controller.NN)*system.Ts;
    t = linspace(t_start,t_end,controller.N+1);
    omega = controller.sin_ref.omega;
    amp = controller.sin_ref.amp;
    ref = controller.reference + amp*sin(omega*t);
    state_ref = NaN(1,2*(length(ref)-1));
    if isempty(controller.Model)
        state_ref(1:2:end) = ref(2:end);
        state_ref(2:2:end) = ref(2:end);
    else
        state_ref(1:2:end) = ref(2:end)/controller.Model.gamma;
        state_ref(2:2:end) = ref(2:end);
    end
    
    % --- INPUT REFERENCE CALCULATION--- %
    if isa(system,'Model') || isempty(controller.Model)
        d1=4.0e-3; D=44.45e-3; max_in=46.8e-6; alpha1=d1^2/D^2; beta=max_in/3/(pi/4*D^2); g=9.81;
        h10=state_ref(1:2:end)/100*0.25;
        input_ref=1/beta*alpha1*sqrt(2*g*h10);
    else
        step=state_ref(1:2:end);
        input_ref=(step/controller.Model.kappa/100*3+controller.u0);
    end
    
    % --- SYSTEM REFERENCE UPDATE --- %
    system.ref=ref(1);
end
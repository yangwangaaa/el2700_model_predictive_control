% output state_ref is a 100% scale variable.
% output input_ref is a 0-3 scale variable.

function [state_ref, input_ref] = sinRef_preview_off(controller,system)
    % --- STATE REFERENCE CALCULATION--- %
    t = (system.counter) * system.Ts;
    omega = controller.sin_ref.omega;
    amp = controller.sin_ref.amp;
    ref = controller.reference + amp*sin(omega*t);
    if isempty(controller.Model)
        state_ref = kron(ones(1,controller.N),[ref,ref]);
    else
        state_ref = kron(ones(1,controller.N),[ref/controller.Model.gamma,ref]);
    end
    
    % --- INPUT REFERENCE CALCULATION--- %
    if isa(system,'Model') || isempty(controller.Model)
        d1=4.0e-3; D=44.45e-3; max_in=46.8e-6; alpha1=d1^2/D^2; beta=max_in/3/(pi/4*D^2); g=9.81;
        h10=controller.reference/100*0.25;
        input_ref=ones(1,controller.N)*1/beta*alpha1*sqrt(2*g*h10);
    else
        step=(controller.reference-controller.Model.h20)/controller.Model.gamma;
        input_ref=ones(1,controller.N)*(step/controller.Model.kappa/100*3+controller.u0);
    end
    
    % --- SYSTEM REFERENCE UPDATE --- %
    system.ref=ref;
end

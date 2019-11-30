function disturbance = LQRobserve(obj,u,y)
    persistent x
    if isempty(x) || obj.observor_flush
        x = [y;0];
        obj.observor_flush=false;
    end
    
    x = obj.observor.A_au*x + obj.observor.B_au*u + obj.observor.K*(y-obj.observor.C_au*x);
    disturbance = x(3,1);
    obj.observe_state = x(1:2,1)';
end
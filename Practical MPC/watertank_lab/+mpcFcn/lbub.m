% --- OUTPUT --- %
% lb: lower state bound(-5 is set as the lower bounnd to give some margin for RT)
% ub: upper state bound

function [lb,ub] = lbub(obj)

    lb = -inf(obj.N*3,1);
    ub =  inf(obj.N*3,1);

    if obj.state_constraint
        lb(1:obj.N*2,1) = (-50+obj.state_constraint_min-obj.lin_level)*(0.25/100)*ones(obj.N*2,1);
        ub(1:obj.N*2,1) = (   obj.state_constraint_max-obj.lin_level)*(0.25/100)*ones(obj.N*2,1);
    end
    
    if obj.input_constraint
        lb(obj.N*2+1:end,1) = obj.input_constraint_min*(3/100)*ones(obj.N,1)-obj.u0;
        ub(obj.N*2+1:end,1) = obj.input_constraint_max*(3/100)*ones(obj.N,1)-obj.u0;
    end
end

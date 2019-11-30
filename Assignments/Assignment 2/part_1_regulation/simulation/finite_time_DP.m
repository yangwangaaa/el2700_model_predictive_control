function F = finite_time_DP(current_state, t)

% current state
x = current_state;
% length of time horizon
N = 50;
% sampling time 
Ts = 0.1;
% integral part
n = fix(t/Ts);

persistent x1_dp x2_dp U_dp

% ======================================== %
% Decide Type of DP
% ======================================== %
% we will consider following two kinds of DP
% using linear model := 0
% using non-linear model := 1
DP_TYPE = 0;

switch DP_TYPE

    case 0
        if t == 0
            % load data
            load('DP_TV_L.mat','U','x1', 'x2')
            x1_dp = x1;
            x2_dp = x2;
            U_dp  = U;
            F = interp2(x1_dp, x2_dp, U_dp(:,:, N-n)', x(1), x(2), 'spline'); 
        else
            F = interp2(x1_dp, x2_dp, U_dp(:,:,N-n)', x(1), x(2), 'spline');
        end
        
    case 1
        if t == 0
            % load data
            load('DP_TV_NL.mat','U','x1', 'x2')
            x1_dp = x1;
            x2_dp = x2;
            U_dp  = U;
            F = interp2(x1_dp, x2_dp, U_dp(:,:, N-n)', x(1), x(2), 'spline'); 
        else
            F = interp2(x1_dp, x2_dp, U_dp(:,:,N-n)', x(1), x(2), 'spline');
        end
end
end
function F = finite_time_DP(current_state, t)

% current state
X = current_state;
% length of time horizon
N = 200;
% sampling time 
h = 0.1;
% integral part
n = fix(t/h);

persistent X1_dp X2_dp X3_dp X4_dp U_dp

if t == 0
    % load data
    load('DP_TV_L_FS.mat',  'U', 'X1', 'X2', 'X3', 'X4')
    X1_dp = X1;
    X2_dp = X2;
    X3_dp = X3;
    X4_dp = X4;
    U_dp  = U;
    F = interpn(X1_dp, X2_dp, X3_dp, X4_dp, U_dp(:,:,:,:, N-n), X(1), X(2), X(3), X(4), 'spline'); 
else
    F = interpn(X1_dp, X2_dp, X3_dp, X4_dp, U_dp(:,:,:,:, N-n), X(1), X(2), X(3), X(4), 'spline');
end
end
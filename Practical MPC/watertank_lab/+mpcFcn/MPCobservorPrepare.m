function observor = MPCobservorPrepare(obj)
    % --- MODEL DISTURBANCE AUGMENTATION --- %
    A_au = [obj.obs_model.A, 1e-3*eye(2);
            zeros(2),        eye(2)];
    B_au = [obj.obs_model.B;zeros(2,1)];
    C_au = [obj.obs_model.C,zeros(2,2)];

    K = place(A_au',C_au',[0.5,0.6,0.7,0.8]);
    K = K';
    observor = struct('A_au',A_au,'B_au',B_au,'C_au',C_au,'K',K);
end
           
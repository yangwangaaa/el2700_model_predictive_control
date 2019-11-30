function observor = LQRobservorPrepare(obj)
    % --- MODEL DISTURBANCE AUGMENTATION --- %
    A_au = [obj.obs_model.A, obj.obs_model.B;
            zeros(1,2),        1];
    B_au = [obj.obs_model.B;0];
    C_au = [obj.obs_model.C,zeros(2,1)];

    K = place(A_au',C_au',[0.5,0.6,0.7]);
    K = K';
    observor = struct('A_au',A_au,'B_au',B_au,'C_au',C_au,'K',K);
end
           
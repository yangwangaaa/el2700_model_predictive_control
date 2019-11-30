function PID_mode(app)
    % --- CONTROLLER SWITCH & REFERENCE SET --- %
%     app.controller=app.PID;
    
    % --- PREDICTION OFF --- %
    app.PredictionCheckBox.Value = false;
    app.PredictionCheckBox.Enable = 'Off';
    set(app.pre_input_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    set(app.pre_tank1_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    set(app.pre_tank2_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    set(app.pre_ref_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    
    % --- CONTROLLER APPLY SWITCH --- %
    app.ControllerSwitch.Items={'Manual','PID'};
end
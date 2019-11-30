function LQR_mode(app)
    % --- CONTROLLER SETTING --- %
%     app.controller = app.LQR;
    
    % --- PREDICTION OFF --- %
    app.PredictionCheckBox.Value = false;
    app.PredictionCheckBox.Enable = 'Off';
    set(app.pre_input_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    set(app.pre_tank1_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    set(app.pre_tank2_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    set(app.pre_ref_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    
    % --- REFERENCE PLOT --- %
    app.ReferenceCheckBox.Enable='On';
    app.ReferenceCheckBox.Value=true;
    
    % --- CONTROLLER APPLY SWITCH --- %
    app.ControllerSwitch.Items={'Manual','LQR'};
end
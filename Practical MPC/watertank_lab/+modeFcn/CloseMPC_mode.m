function CloseMPC_mode(app)
    % --- CONTROLLER SWITCH --- %
%     app.controller=app.MPC_CloseLoop;
    
    % --- PREDICTION OFF --- %
    app.PredictionCheckBox.Enable = 'On';
    app.PredictionCheckBox.Value = false; % CheckBox will be set true when MPC controller is fired.
    
    % --- CONTROLLER APPLY SWITCH --- %
    app.ControllerSwitch.Items={'Manual','Closed loop MPC'};
    
    % --- RESET SIMULATION SPEED --- %
    app.SW.simulation_speed_scale = 5;
    app.ManualSimulationspeedupDropDown.Value='1x';
    app.PIDSimulationspeedupDropDown.Value='1x';
    app.LQRSimulationspeedupDropDown.Value='1x';
    if app.AppIsRunning
        stop(app.Timer)
        app.Timer.Period = app.system.Ts;
        start(app.Timer)
    else
        app.Timer.Period = app.system.Ts;
    end
end
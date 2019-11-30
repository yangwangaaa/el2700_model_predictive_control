function OpenMPC_mode(app)
    % --- CONTROLLER SWITCH & OPENLOOP MPC CONTROL SIGNAL CALCULATION --- %
%     app.controller=app.MPC_OpenLoop;
    
    % --- PREDICTION OFF --- %
    app.PredictionCheckBox.Value = false;
    app.PredictionCheckBox.Enable = 'Off';
    set(app.pre_input_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    set(app.pre_tank1_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    set(app.pre_tank2_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    set(app.pre_ref_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
    
    % --- CONTROLLER APPLY SWITCH --- %
    app.ControllerSwitch.Items={'Manual','Open loop MPC'};
    
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
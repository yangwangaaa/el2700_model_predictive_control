function SW_mode(app)
    app.system = app.SW;
    
    % --- TAP SWITCH ENABLE ON --- %
    app.TapSwitch.Enable='On';
    app.ManualSimulationspeedupDropDown.Enable='On';
    app.PIDSimulationspeedupDropDown.Enable='On';    
    app.LQRSimulationspeedupDropDown.Enable='On';
end
function HW_mode(app)
    if ~processFcn.HW_detect()
        message = sprintf('NI hardware is not detected or DAQ toolbox is not installed.\n App will be only running in simulation mode.');
        uialert(app.DoubleTankProcess,message,'Warning',...
            'Icon','warning');
        app.SimRealSwitch.Value = 'Simulator';
        app.SimRealSwitch.Enable = 'Off';
        app.system = app.SW;
    else
        app.system = app.HW;
    end
    
    % --- TAP SWITCH ENABLE OFF --- %
    app.TapSwitch.Enable='Off';
    
    % --- SPEED UP DROPDOWN SETTING --- %
    app.ManualSimulationspeedupDropDown.Value='1x';
    app.PIDSimulationspeedupDropDown.Value='1x';
    app.LQRSimulationspeedupDropDown.Value='1x';
    app.ManualSimulationspeedupDropDown.Enable='Off';
    app.PIDSimulationspeedupDropDown.Enable='Off';
    app.LQRSimulationspeedupDropDown.Enable='Off';
    
    app.Timer.Period = app.system.Ts; % set timer period back
end
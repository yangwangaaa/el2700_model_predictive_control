function ProcessStart(app)
    %% --- OPEN MPC CHECKING --- %
    if isa(app.controller,'ControllerMPC_OpenLoop')
        app.MPC_OpenLoop.MPC_OpenLoop_Prepare(app.system.state,app.system)
    end
    
    %% --- CHOOSE CONTROLLER --- %
    modeFcn.ControllerApply(app,app.ControllerSwitch.Value);
    
    %% --- PROCESS START --- %
    if isa(app.system,'System')
        app.Timer.Period = app.system.Ts;
    end
    start(app.Timer);
    app.AppIsRunning = true;
    
    %% --- BUTTON ENABLE --- %
    app.SimRealSwitch.Enable = 'Off';
    
end
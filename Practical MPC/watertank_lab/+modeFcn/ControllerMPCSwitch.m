function ControllerMPCSwitch(app,event)
    if app.AppIsRunning
        processFcn.ProcessStop(app);
        switch event.Value
            case 'Closed loop'
                modeFcn.CloseMPC_mode(app);
                app.controller=app.Manual;
            case 'Open loop'
                modeFcn.OpenMPC_mode(app);
                app.controller=app.Manual;
        end
        processFcn.ProcessStart(app);
    else
        switch event.Value
            case 'Closed loop'
                modeFcn.CloseMPC_mode(app);
                app.controller=app.Manual;
            case 'Open loop'
                modeFcn.OpenMPC_mode(app);
                app.controller=app.Manual;
        end
    end
    app.system.ref=NaN; % always in manual mode
end
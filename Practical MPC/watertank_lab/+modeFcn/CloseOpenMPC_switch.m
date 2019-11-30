function CloseOpenMPC_switch(app,event)
    if app.AppIsRunning
        processFcn.ProcessStop(app);
        modeFcn.Manual_mode(app);
        switch event.Value
            case 'Closed loop'
                app.ControllerSwitch.Items={'Manual','Closed loop MPC'};
                app.ControllerSwitch.Value='Manual';
            case 'Open loop'
                app.ControllerSwitch.Items={'Manual','Open loop MPC'};
                app.ControllerSwitch.Value='Manual';
        end
        processFcn.ProcessStart(app);
    else
        switch event.Value
            case 'Closed loop'
                app.ControllerSwitch.Items={'Manual','Closed loop MPC'};
                app.ControllerSwitch.Value='Manual';
            case 'Open loop'
                app.ControllerSwitch.Items={'Manual','Open loop MPC'};
                app.ControllerSwitch.Value='Manual';
        end
    end
end
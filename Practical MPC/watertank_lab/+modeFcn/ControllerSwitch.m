% Running at manual mode in the background.
% Prepare the controller which will be applied.

function ControllerSwitch(app,Choice)
    if ~isa(app.controller,'ControllerManual')
        if app.AppIsRunning
            processFcn.ProcessStop(app);
            app.controller=app.Manual;
            switch Choice
                case 'Manual'
                    modeFcn.Manual_mode(app);
                case 'PID'
                    modeFcn.PID_mode(app);
                case 'MPC'
                    switch app.CloseOpenMPCSwitch.Value
                        case 'Closed loop'
                            modeFcn.CloseMPC_mode(app);
                        case 'Open loop'
                            modeFcn.OpenMPC_mode(app);
                    end
                case 'LQR'
                    modeFcn.LQR_mode(app);
            end
            app.system.ref=NaN; % always in manual mode
            processFcn.ProcessStart(app);
        else
            switch Choice
                case 'Manual'
                    modeFcn.Manual_mode(app);
                case 'PID'
                    modeFcn.PID_mode(app);
                case 'MPC'
                    switch app.CloseOpenMPCSwitch.Value
                        case 'Closed loop'
                            modeFcn.CloseMPC_mode(app);
                        case 'Open loop'
                            modeFcn.OpenMPC_mode(app);
                    end
                case 'LQR'
                    modeFcn.LQR_mode(app);
            end
            app.system.ref=NaN; % always in manual mode
        end
    else
        switch Choice
                case 'Manual'
                    modeFcn.Manual_mode(app);
                case 'PID'
                    modeFcn.PID_mode(app);
                case 'MPC'
                    switch app.CloseOpenMPCSwitch.Value
                        case 'Closed loop'
                            modeFcn.CloseMPC_mode(app);
                        case 'Open loop'
                            modeFcn.OpenMPC_mode(app);
                    end
                case 'LQR'
                    modeFcn.LQR_mode(app);
         end
            app.system.ref=NaN; % always in manual mode
    end
end

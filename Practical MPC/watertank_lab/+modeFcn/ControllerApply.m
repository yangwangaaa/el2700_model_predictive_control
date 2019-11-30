% Additional function for function modeFcn.ControllerSwitch()
% Apply the controller which has been prepared by modeFcn.ControllerSwitch()
function ControllerApply(app,Choice)
    if app.AppIsRunning
        processFcn.ProcessStop(app);
        switch Choice
            case 'Manual'
                app.controller=app.Manual;
                app.system.ref=NaN;
                % --- PREDICTION OFF --- %
                app.PredictionCheckBox.Value = false;
                app.PredictionCheckBox.Enable = 'Off';
                set(app.pre_input_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
                set(app.pre_tank1_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
                set(app.pre_tank2_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
                set(app.pre_ref_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
            case 'PID'
                if app.system.counter>1
                    app.PID.D_state=app.system.state(2);
                end
                app.controller=app.PID;
                app.system.ref=app.RefSlider.Value;
            case 'Closed loop MPC'
                app.controller=app.MPC_CloseLoop;
                app.PredictionCheckBox.Enable = 'On';
                app.PredictionCheckBox.Value = true;
            case 'Open loop MPC'
                app.controller=app.MPC_OpenLoop;
            case 'LQR'
                app.controller=app.LQR;
        end
        processFcn.ProcessStart(app);
    else
        switch Choice
            case 'Manual'
                app.controller=app.Manual;
                app.system.ref=NaN;
                % --- PREDICTION OFF --- %
                app.PredictionCheckBox.Value = false;
                app.PredictionCheckBox.Enable = 'Off';
                set(app.pre_input_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
                set(app.pre_tank1_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
                set(app.pre_tank2_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
                set(app.pre_ref_plot,'YData',NaN(app.MPC_CloseLoop.N,1));
            case 'PID'
                app.controller=app.PID;
                app.system.ref=app.RefSlider.Value;
            case 'Closed loop MPC'
                app.controller=app.MPC_CloseLoop;
                app.PredictionCheckBox.Value = true;
            case 'Open loop MPC'
                app.controller=app.MPC_OpenLoop;
            case 'LQR'
                app.controller=app.LQR;
        end
    end
end
function ProcessStop(app)    
    %% STOP DAQ SESSION & FILTER PERSISTENT VARIABLE FLUSH
    if isa(app.system,'System')
        % --- OUTPUT ZERO SET --- %
        outputSingleScan(app.system.session,0);
        % --- CONTROLLER STATE RESET --- %
        app.PID.Ie=0;
        app.PID.De=0;
    else
%         app.system.state=[0,0];
    end

    %% STOP TIMER
    if isa(app.Timer,'timer')
        stop(app.Timer)
    end
    
    %% APP ENABLE ON
    app.AppIsRunning = false;
    
    %% --- BUTTON ENABLE --- %
    app.CloseOpenMPCSwitch.Enable = 'On';
    app.SimRealSwitch.Enable = 'On';
%     app.DisturbancecompensationSwitch.Enable = 'On';
    
    %% --- OBSERVOR --- %
    app.MPC_CloseLoop.observor_flush=true;
    app.MPC_CloseLoop.observe_counter=0;
    app.LQR.observor_flush=true;
    app.LQR.observe_counter=0;
end
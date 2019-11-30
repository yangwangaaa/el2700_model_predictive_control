function ProcessPrepare(app)
    % --- INITIALIZE PARAMETERS --- %
    tankFcn.FreshPara;
    
    %% --- CONSTRUCTOR: SYSTEM --- %
    if processFcn.HW_detect()
        app.HW=System(sysInfo);
    end
    app.SW=Model(simInfo);
    switch app.SimRealSwitch.Value
        case 'Real time'
            app.system = app.HW;
        case 'Simulator'
            app.system = app.SW;
    end

    %% --- CONSTRUCTOR: CONTROLLER --- %
    control_P   = app.KEditField.Value;
    control_I   = app.TiEditField.Value;
    control_D   = app.TdEditField.Value;
    app.PID=ControllerPID(control_P,control_I,control_D,Ts,max_vol);
    
    app.Manual=ControllerManual(max_vol);
    app.MPC_CloseLoop=ControllerMPC_CloseLoop(MPCInfo);
    app.MPC_OpenLoop=ControllerMPC_OpenLoop(MPCInfo_Open);
    app.LQR=ControllerLQR(LQRInfo);
    
    % CONTROLLER SWITCH
    switch app.ManualPIDMPC.SelectedTab.Title
        case 'Manual'
            modeFcn.Manual_mode(app);
        case 'PID'
            modeFcn.PID_mode(app);
        case 'MPC'
            switch app.CloseOpenMPCSwitch
                case 'Close loop MPC'
                    modeFcn.CloseMPC_mode(app);
                case 'Open loop MPC'
                    modeFcn.OpenMPC_mode(app);
            end
        case 'LQR'
            modeFcn.LQR_mode(app);
    end

    %% --- SPECIFICATION: plotting --- %
    app.figureOption = figureOption;
    plotFcn.PlotPrepare(app);

    %% --- CONSTRUCTOR: TIMER --- %
    app.Timer = timer;
    app.Timer.ExecutionMode = 'fixedRate';
    app.Timer.Period = app.system.Ts;
    app.Timer.TimerFcn = {@tankFcn.mainLoop,app}; % MAIN LOOP EXECUTED BY TIMER

    %% --- APPLICATION LOADING IS DONE --- %
    message = sprintf('Application has been loaded, you can start your experiment.');
    uialert(app.DoubleTankProcess,message,'Start',...
            'Icon','success');
end




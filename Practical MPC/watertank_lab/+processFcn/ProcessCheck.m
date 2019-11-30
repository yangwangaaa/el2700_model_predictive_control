function ProcessCheck(app)
    if ~processFcn.HW_detect()
        message = sprintf('NI hardware is not detected or DAQ toolbox is not installed.\n App will be only running in simulation mode.\n Do not close me until this application has been loaded.');
        uialert(app.DoubleTankProcess,message,'Warning',...
            'Icon','warning');
        app.SimRealSwitch.Value = 'Simulator';
        app.SimRealSwitch.Enable = 'Off';
    else
        message = sprintf('Loading...\n Please wait...\n Do not close me until this application has been loaded.');
        uialert(app.DoubleTankProcess,message,'Waiting',...
            'Icon','info');
    end
    app.AppIsRunning = false;
end
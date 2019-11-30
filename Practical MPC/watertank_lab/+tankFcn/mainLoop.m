function mainLoop(~,~,app)
% tic
    % --- DATA READING --- %
    sample_in = app.system.ReadData();

    % --- OVERFLOW WARNING --- %
    processFcn.ProcessOverflow(app);

    % --- CONTROLLER COMPUTING --- %
    app.controller.compute(sample_in,app.system);

    % --- DATA WRITTING --- %
    app.system.WriteData(app.controller.controlSignal_after)
    
    % --- PLOT UPDATING -- %
    plotFcn.PlotUpdate(app);
% toc
end
function PlotPrepare(app)
    % --- PLOT PREPARATION --- %
    NumToPlot = app.figureOption.NumSampleToPlot;
    t = linspace(app.figureOption.axis_lim(1,1),0,NumToPlot);
    t_pre = linspace(app.MPC_CloseLoop.NN*app.MPC_CloseLoop.Ts,app.MPC_CloseLoop.NN*app.MPC_CloseLoop.N*app.MPC_CloseLoop.Ts,app.MPC_CloseLoop.N);
    grid(app.DataAquisition,'on');
    cla(app.DataAquisition)
    
    %% --- COLOR SPECIFICATION SECTION --- % 
    tank1Color = [ 0    0.4470    0.7410 ];
    tank2Color = [ 0.8500    0.3250    0.0980 ];
    refColor = [ 0.3010    0.7450    0.9330 ];
    inputColor = [ 0.4940    0.1840    0.5560 ];

    %% PLOT OBJECT
    hold(app.DataAquisition,'on')
    % --- EXPERIMENT SIGNAL PLOT --- %
    app.tank1_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',tank1Color);
    app.tank2_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',tank2Color);
    app.ref_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',refColor);
    app.controlSignal_plot = plot(app.DataAquisition,t,NaN(NumToPlot,1),'Color',inputColor,'LineStyle','-.');
    % --- PREDICTION SIGNAL PLOT --- %
    app.pre_tank1_plot = plot(app.DataAquisition,t_pre,NaN(app.MPC_CloseLoop.N,1),'Color',tank1Color);
    app.pre_tank1_plot.Marker = 'o';
    app.pre_tank2_plot = plot(app.DataAquisition,t_pre,NaN(app.MPC_CloseLoop.N,1),'Color',tank2Color);
    app.pre_tank2_plot.Marker = 'o';
    app.pre_ref_plot = plot(app.DataAquisition,t_pre,NaN(app.MPC_CloseLoop.N,1),'Color',refColor);
    app.pre_ref_plot.Marker = '+';
    app.pre_input_plot = plot(app.DataAquisition,t_pre-app.MPC_CloseLoop.NN*app.MPC_CloseLoop.Ts,NaN(app.MPC_CloseLoop.N,1),'Color',inputColor,'LineStyle','-.');
    app.pre_input_plot.Marker = 'o';
    hold(app.DataAquisition,'off')
    legend(app.DataAquisition,'Upper tank','Lower tank','Reference','Control signal','Location','NorthWest')
    
    %% AXIS LIMIT
    app.DataAquisition.XLim=app.figureOption.axis_lim(1:2);
    app.DataAquisition.YLim=app.figureOption.axis_lim(3:4);
    
    %% YAXIS LOCATION
    app.DataAquisition.YAxisLocation = 'right';
end
function PlotMPCPre(app)
    % --- COLOR SPECIFICATION SECTION --- % 
    tank1Color = [ 0    0.4470    0.7410 ];
    tank2Color = [ 0.8500    0.3250    0.0980 ];
    refColor = [ 0.3010    0.7450    0.9330 ];
    inputColor = [ 0.4940    0.1840    0.5560 ];
    
    % --- PLOT OBJECT DELETING --- %
    delete(app.pre_tank1_plot);
    delete(app.pre_tank2_plot);
    delete(app.pre_ref_plot);
    delete(app.pre_input_plot);
    
    % --- PLOT OBJECT REVREATION --- %
    hold(app.DataAquisition,'on')
    if app.AppIsRunning
        stop(app.Timer);
        % --- PREDICTION OBJECT RECREATION --- %
        t_pre = linspace(app.MPC_CloseLoop.NN*app.MPC_CloseLoop.Ts,app.MPC_CloseLoop.NN*app.MPC_CloseLoop.N*app.MPC_CloseLoop.Ts,app.MPC_CloseLoop.N);
        app.pre_tank1_plot = plot(app.DataAquisition,t_pre,NaN(app.MPC_CloseLoop.N,1),'Color',tank1Color);
        app.pre_tank1_plot.Marker = 'o';
        app.pre_tank2_plot = plot(app.DataAquisition,t_pre,NaN(app.MPC_CloseLoop.N,1),'Color',tank2Color);
        app.pre_tank2_plot.Marker = 'o';
        app.pre_ref_plot = plot(app.DataAquisition,t_pre,NaN(app.MPC_CloseLoop.N,1),'Color',refColor);
        app.pre_ref_plot.Marker = '+';
        app.pre_input_plot = plot(app.DataAquisition,t_pre-app.MPC_CloseLoop.NN*app.MPC_CloseLoop.Ts,NaN(app.MPC_CloseLoop.N,1),'Color',inputColor,'LineStyle','-.');
        app.pre_input_plot.Marker = 'o';
        start(app.Timer);
    else
        % --- PREDICTION OBJECT RECREATION --- %
        t_pre = linspace(app.MPC_CloseLoop.NN*app.MPC_CloseLoop.Ts,app.MPC_CloseLoop.NN*app.MPC_CloseLoop.N*app.MPC_CloseLoop.Ts,app.MPC_CloseLoop.N);
        app.pre_tank1_plot = plot(app.DataAquisition,t_pre,NaN(app.MPC_CloseLoop.N,1),'Color',tank1Color);
        app.pre_tank1_plot.Marker = 'o';
        app.pre_tank2_plot = plot(app.DataAquisition,t_pre,NaN(app.MPC_CloseLoop.N,1),'Color',tank2Color);
        app.pre_tank2_plot.Marker = 'o';
        app.pre_ref_plot = plot(app.DataAquisition,t_pre,NaN(app.MPC_CloseLoop.N,1),'Color',refColor);
        app.pre_ref_plot.Marker = '+';
        app.pre_input_plot = plot(app.DataAquisition,t_pre-app.MPC_CloseLoop.NN*app.MPC_CloseLoop.Ts,NaN(app.MPC_CloseLoop.N,1),'Color',inputColor,'LineStyle','-.');
        app.pre_input_plot.Marker = 'o';
    end 
    hold(app.DataAquisition,'off')
    legend(app.DataAquisition,'Upper tank','Lower tank','Reference','Control signal','Location','NorthWest')
end
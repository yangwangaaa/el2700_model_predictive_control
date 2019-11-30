function PlotUpdate(app)
    %% PREPARE
    NumSampleToPlot = app.figureOption.NumSampleToPlot;
    
    %% DATA PLOT
    if app.tank1CheckBox.Value
        set(app.tank1_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,1));
    end
    if app.tank2CheckBox.Value
        set(app.tank2_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,2));
    end
    if app.ReferenceCheckBox.Value
        set(app.ref_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,3));
    end
    if app.ControlSignalCheckBox.Value
        set(app.controlSignal_plot,'YData',app.system.History(end-NumSampleToPlot+1:end,4));
    end
    
    % CLOSE LOOP MPC PREDICTION PLOT
    if app.PredictionCheckBox.Value
        if app.tank1CheckBox.Value
            if isempty(app.MPC_CloseLoop.Model)
                set(app.pre_tank1_plot,'YData',app.MPC_CloseLoop.x_predict(:,1)*100/0.25+app.MPC_CloseLoop.lin_level);
            else
                set(app.pre_tank1_plot,'YData',app.MPC_CloseLoop.x_predict(:,1)*100/0.25+app.MPC_CloseLoop.Model.h10);
            end
        end
        if app.tank2CheckBox.Value
            if isempty(app.MPC_CloseLoop.Model)
                set(app.pre_tank2_plot,'YData',app.MPC_CloseLoop.x_predict(:,2)*100/0.25+app.MPC_CloseLoop.lin_level);
            else
                set(app.pre_tank2_plot,'YData',app.MPC_CloseLoop.x_predict(:,2)*100/0.25+app.MPC_CloseLoop.Model.h20);
            end
        end
        if app.ReferenceCheckBox.Value
            set(app.pre_ref_plot,'YData',app.MPC_CloseLoop.state_ref(2:2:end)/0.25*100+app.MPC_CloseLoop.lin_level); % controlling the lower tank by default
        end
        if app.ControlSignalCheckBox.Value
            set(app.pre_input_plot,'YData',(app.MPC_CloseLoop.u_predict+app.MPC_CloseLoop.u0)*100/3);
        end
    end
    
    %% GAUGE PLOT
    app.tank1Gauge.Value = app.system.state(1,1);
    app.tank2Gauge.Value = app.system.state(1,2);
end
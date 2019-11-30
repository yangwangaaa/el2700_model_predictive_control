function PlotCapture(app)
    figure; hold on;
    NumToCapture = ceil(app.SecondsToCaptureEditField.Value/app.system.Ts);
    x_start = app.system.counter*app.system.Ts-app.SecondsToCaptureEditField.Value;
    x_end = app.system.counter*app.system.Ts;
    x = linspace(x_start,x_end,NumToCapture);
    y1 = app.system.History(end-NumToCapture+1:end,1);
    y2 = app.system.History(end-NumToCapture+1:end,2);
    yref = app.system.History(end-NumToCapture+1:end,3);
    ycon = app.system.History(end-NumToCapture+1:end,4);
    % --- COLOR SPECIFICATION SECTION --- % 
    tank1Color = [ 0    0.4470    0.7410 ];
    tank2Color = [ 0.8500    0.3250    0.0980 ];
    refColor = [ 0.3010    0.7450    0.9330 ];
    inputColor = [ 0.4940    0.1840    0.5560 ];
    % upper tank plot
    if app.tank1CheckBox.Value
        plot(x,y1,'Color',tank1Color);
    else
        plot(x,NaN(size(x)),'Color',tank1Color);
    end
    % lower tank plot
    if app.tank2CheckBox.Value
        plot(x,y2,'Color',tank2Color);
    else
        plot(x,NaN(size(x)),'Color',tank2Color);
    end
    % reference plot
    if app.ReferenceCheckBox.Value
        plot(x,yref,'Color',refColor);
    else
        plot(x,NaN(size(x)),'Color',refColor);
    end
    % input plot
    if app.ControlSignalCheckBox.Value
        plot(x,ycon,'Color',inputColor,'LineStyle','-.');
    else
        plot(x,NaN(size(x)),'Color',inputColor,'LineStyle','-.');
    end
    axis([x_start,x_end,app.figureOption.axis_lim(3:4)])
    xlabel('time [s]'); ylabel('Y [%]'); 
    legend('Upper tank','Lower tank','Reference','Control signal','Location','NorthWest')
    grid on;
    hold off;
end
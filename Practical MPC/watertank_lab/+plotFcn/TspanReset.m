function TspanReset(app,event)
    app.figureOption.NumSampleToPlot=ceil(event.Value/app.system.Ts);
    app.figureOption.axis_lim(1)=-event.Value;
    plotFcn.PlotPrepare(app)
end
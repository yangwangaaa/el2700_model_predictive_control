function AxisReset(app)
    app.TspanEditField.Value = 100;
    app.YminEditField.Value = 0;
    app.YmaxEditField.Value = 100;
    app.figureOption.axis_lim(1) = -100;
    app.figureOption.NumSampleToPlot = 60*20;
    app.figureOption.axis_lim(3) = 0;
    app.figureOption.axis_lim(4) = 100;
    plotFcn.PlotPrepare(app)
end
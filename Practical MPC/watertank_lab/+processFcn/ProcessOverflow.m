function ProcessOverflow(app)
    %% tank1 overflow checking
    if app.system.History(end,1)>=100 && app.system.History(end-1,1)<=100
        app.tank1Overflow.Color = [1,0,0];
    end
    if app.system.History(end,1)<=100 && app.system.History(end-1,1)>=100
        app.tank1Overflow.Color = [0.65,0.65,0.65];
    end
    
    %% tank2 overflow checking
    if app.system.History(end,2)>=100 && app.system.History(end-1,2)<=100
        app.tank2Overflow.Color = [1,0,0];
    end
    if app.system.History(end,2)<=100 && app.system.History(end-1,2)>=100
        app.tank2Overflow.Color = [0.65,0.65,0.65];
    end
end
function ProcessDelete(app)
    %% DELETE TIMER
    if isa(app.Timer,'timer')
        delete(app.Timer);
    end

    %% DELETE DAQ SESSION
    if isa(app.system,'System')
        daqreset;
    end
end
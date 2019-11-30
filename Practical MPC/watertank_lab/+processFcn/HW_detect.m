function flag = HW_detect()
    % --- DAQ TOOLBOX DETECTION --- %
    v = ver;
    toolbox_flag = false;
    hardware_flag = false;
    for i = 1:length(v)
        if strcmp(v(i).Name,'Data Acquisition Toolbox')
            toolbox_flag = true;
            disp('Data Acquisition Toolbox is installed.')
            Device = daq.getDevices;
            if ~isempty(Device) && strcmp(Device.Model,'PCI-6221')
                hardware_flag = true;
                disp('Hardware is detected.')
                break
            end
        end
    end
    
    if ~toolbox_flag
        warning('Data Acquisition Toolbox is not installed.')
    end
    if ~hardware_flag
        warning('Hardware is not detected.')
    end
    flag = toolbox_flag && hardware_flag;
end




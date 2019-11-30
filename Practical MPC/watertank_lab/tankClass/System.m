% System class: class for hardware
% --- PROPERTY --- %
% System.session:     DAQ session created for hardware
% System.state:       current two water tank levels.      [1x2]
% System.History:     history vector storing state.       [Nx2] N:time/Ts
% System.History_l:   length of History which is not NaN. [1x1]
% System.Ts:          system sampling rate                [1x1] default: 0.05
% System.sysInfo:     N & Ts                              [structure]
% --- METHOD --- %
% System.ReadData():  read data, store data.
% System.WriteData(): write data.

classdef System < handle
    properties
        session % DAQ session
        state
        ref
        controlSignal
        History
        tankChoice
        Ts
        sysInfo
        counter
    end
    
    methods
        % --- METHOD: CONSTRUCTOR --- %
        function sys=System(setting)
            daqreset; % safe
            sys.sysInfo = setting;
            sys.session=daq.createSession('ni');
            addAnalogOutputChannel(sys.session,'Dev1',0,'Voltage');
            addAnalogInputChannel(sys.session,'Dev1',0,'Voltage');
            addAnalogInputChannel(sys.session,'Dev1',1,'Voltage');
            sys.state=zeros(1,2);
            sys.ref=NaN;
            sys.controlSignal=0;
            sys.History=zeros(setting.NumSampleToHistory,4);
            sys.tankChoice=2;
            sys.Ts=setting.Ts;
            sys.counter = 0;
        end
        
        % --- METHOD: INTERFACE FUNCTION --- %
        function data=ReadData(obj)
            % --- SIGNAL READING AND FILTERING -- %
            obj.state=(100/obj.sysInfo.max_vol_in)*inputSingleScan(obj.session);
            
            % --- STATE, REF, CONTROL HISTORY UPDATING --- %
            obj.History=circshift(obj.History,[-1,0]);
            obj.History(end,1:2)=obj.state;
            obj.History(end,3)=obj.ref;
            obj.History(end,4)=obj.controlSignal;
            
            % --- tankChoice SIGANL OUTPUT --- %
            data=obj.state;
        end
        
        function WriteData(obj,data)
            if max(obj.state)> 100
                outputSingleScan(obj.session, 0);
            else
                outputSingleScan(obj.session,data(1,1))
            end
            obj.controlSignal=(100/obj.sysInfo.max_vol)*data;
            
            % --- PROCESS COUNTER UPDATING --- %
            obj.counter = obj.counter+1;
        end
    end
end


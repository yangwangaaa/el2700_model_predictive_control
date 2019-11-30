classdef ModelConfigureClass < handle
    properties
       UIfigure_h
       u0
       h10
       h20
       gamma
       kappa
       tau
    end
    
    methods
        % --- CLASS CONSTRUCTOR --- %
        function obj = ModelConfigureClass
            obj.UIfigure_h = guihandles(ModelConfigure);
            % --- PARAMETER MEASURED FROM SIMULATION --- %
            h10=40; h20=40; u0=37.5;
            gamma=h20/h10;
            tau=18.46;
            kappa=2.14;
            % --- SET DEFAULT PARAMETERS IN GUI --- %
            obj.UIfigure_h.u0EditField.String = num2str(u0);
            obj.UIfigure_h.h10EditField.String = num2str(h10);
            obj.UIfigure_h.h20EditField.String = num2str(h20);
            obj.UIfigure_h.gammaEditField.String = num2str(gamma);
            obj.UIfigure_h.kappaEditField.String = num2str(kappa);
            obj.UIfigure_h.tauEditField.String = num2str(tau);
        end
        
        % --- CLASS METHOD --- %
        function obj = ModelReopen(obj)
            obj.UIfigure_h = guihandles(ModelConfigure);
            obj.UIfigure_h.u0EditField.String = num2str(obj.u0);
            obj.UIfigure_h.h10EditField.String = num2str(obj.h10);
            obj.UIfigure_h.h20EditField.String = num2str(obj.h20);
            obj.UIfigure_h.gammaEditField.String = num2str(obj.gamma);
            obj.UIfigure_h.kappaEditField.String = num2str(obj.kappa);
            obj.UIfigure_h.tauEditField.String = num2str(obj.tau);
        end
        
        function ModelSave(obj,app)
            % --- SANITY CHECK FOR MODEL PARAMETERS --- %
            if isempty(app.MPCModelConfigure) || ~isvalid(app.MPCModelConfigure.UIfigure_h.figure1)
                message = sprintf('Please click button "Model configure" and input the parameter you get.');
                uialert(app.DoubleTankProcess,message,'Warning',...
                       'Icon','warning');
            end
            
           % --- PARAMETER RETRIEVE FROM GUI --- %
           warning_flag=false;
           warning_str=[];
           dummy = str2double(obj.UIfigure_h.u0EditField.String);
           if ~isempty(dummy) && ~isnan(dummy)
               obj.u0 = dummy;
           else
               warning_flag = true;
               warning_str = [warning_str,' "u0" '];
           end
           
           dummy = str2double(obj.UIfigure_h.h10EditField.String);
           if ~isempty(dummy) && ~isnan(dummy)
               obj.h10 = dummy;
           else
               warning_flag = true;
               warning_str = [warning_str,' "h10" '];
           end
           
           dummy = str2double(obj.UIfigure_h.h20EditField.String);
           if ~isempty(dummy) && ~isnan(dummy)
               obj.h20 = dummy;
           else
               warning_flag = true;
               warning_str = [warning_str,' "h20" '];
           end
           
           dummy = str2double(obj.UIfigure_h.gammaEditField.String);
           if ~isempty(dummy) && ~isnan(dummy)
               obj.gamma = dummy;
           else
               warning_flag = true;
               warning_str = [warning_str,' "gamma" '];
           end
           
           dummy = str2double(obj.UIfigure_h.tauEditField.String);
           if ~isempty(dummy) && ~isnan(dummy)
               obj.tau = dummy;
           else
               warning_flag = true;
               warning_str = [warning_str,' "tau" '];
           end
           
           dummy = str2double(obj.UIfigure_h.kappaEditField.String);
           if ~isempty(dummy) && ~isnan(dummy)
               obj.kappa = dummy;
           else
               warning_flag = true;
               warning_str = [warning_str,' "kappa" '];
           end
           
           if warning_flag
               message = sprintf(['Value of',warning_str,'is invalid, please input valid values.']);
               uialert(app.DoubleTankProcess,message,'Warning',...
                       'Icon','warning');
           else
               % --- EXPERIMENT MODELING --- %
               beta=obj.kappa/12/obj.tau;
               
               % --- STATE SPACE --- %
               Ac = [-1/obj.tau,     0
                      1/obj.tau, -1/(obj.gamma*obj.tau)];
               Bc = [beta; 0];
               Cc = eye(2);
               Dc = zeros(2,1);
               
               doubletank_c = ss(Ac,Bc,Cc,Dc);
               doubletank_d = c2d(doubletank_c,0.05*20,'zoh');
               
               % --- MPC MODEL TRANSFER --- %
               app.MPC_CloseLoop.pre_model=doubletank_d;
               app.MPC_CloseLoop.u0=obj.u0/100*3;
               app.MPC_CloseLoop.Model=struct('h10',obj.h10,'h20',obj.h20,'gamma',obj.gamma,'kappa',obj.kappa);
               app.MPC_OpenLoop.pre_model=doubletank_d;
               app.MPC_OpenLoop.u0=obj.u0/100*3;               
               app.MPC_OpenLoop.Model=struct('h10',obj.h10,'h20',obj.h20,'gamma',obj.gamma,'kappa',obj.kappa);
               
               % --- ricatti TERMINAL COST RECALCULATION --- %
               [Close_P,~,~] = dare(doubletank_d.A,doubletank_d.B,app.MPC_CloseLoop.Q,app.MPC_CloseLoop.R);
               [Open_P,~,~] = dare(doubletank_d.A,doubletank_d.B,app.MPC_OpenLoop.Q,app.MPC_OpenLoop.R);
               app.MPC_CloseLoop.ricatti_Qf = Close_P;
               app.MPC_OpenLoop.ricatti_Qf = Open_P;
               
               % --- LQR MODEL TRANSFER --- %
               app.LQR.pre_model=doubletank_d;
               app.LQR.LQR_Prepare();
               app.LQR.Model=struct('h10',obj.h10,'h20',obj.h20,'gamma',obj.gamma,'kappa',obj.kappa);
               app.MPC_OpenLoop.u0=obj.u0/100*3;
           end
        end 
    end
end

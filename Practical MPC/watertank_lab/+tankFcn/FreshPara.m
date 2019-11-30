%% --- SETTING: BASIC --- %
Ts=0.05;
max_vol=3; % old power module: 3v, new power module: 5v
time=600;  % 10 min to store
NumSampleToHistory=int32(time/Ts);
NumSampleToPlot=int32(app.TspanEditField.Value/Ts);

%% --- SETTING: GUI PLOT --- %
f1='axis_lim'; v1=[-app.TspanEditField.Value,15,app.YminEditField.Value,app.YmaxEditField.Value];
f2='NumSampleToHistory'; v2=NumSampleToHistory;
f3='NumSampleToPlot'; v3=NumSampleToPlot;
figureOption = struct(f1,v1,f2,v2,f3,v3);

%% --- SETTING: REALTIME --- %
sysInfo = struct('Ts',Ts,f2,v2,'max_vol_in',5,'max_vol',max_vol);

%% --- SETTING: SIMULATION --- %
d1=4.0e-3; d2=4.0e-3;
D =44.45e-3;
max_in=46.8e-6;
model.alpha1=d1^2/D^2;
model.alpha2=d2^2/D^2;
model.beta=max_in/max_vol/(pi/4*D^2);
delay = 0; % second
simInfo = struct('Ts',Ts,f2,v2,'model',model,'delay',delay,'max_vol',max_vol);

%% --- SETTING: CLOSELOOP MPC CONTROLLER --- %
MPCInfo = struct('Ts',Ts,f2,v2,'max_vol',max_vol);
MPCInfo.lin_level=40;
MPCInfo.reference=60;
MPCInfo.Q = [0,0;0,1]*(3)^2;
MPCInfo.R = 1*(0.25)^2;

MPCInfo.N = 10;
MPCInfo.NN = 20;
MPCInfo.con_ref = 0;
MPCInfo.sin_ref = struct('amp',8,'omega',pi/24);
MPCInfo.option = optimoptions('quadprog');
MPCInfo.option.Display = 'off';

%% --- SETTING: OPENLOOP MPC CONTROLLER --- %
MPCInfo_Open = MPCInfo;
MPCInfo_Open.N = 100;
MPCInfo_Open.NN = 20;

%% --- SETTING: LQR CONTROLLER --- %
LQRInfo.lin_level=40;
LQRInfo.reference=60;
LQRInfo.Q = [0,0;0,1]*(3)^2;
LQRInfo.R = 1*(0.25)^2;
LQRInfo.Ts = 0.05;
LQRInfo.sin_ref = struct('amp',8,'omega',pi/24);





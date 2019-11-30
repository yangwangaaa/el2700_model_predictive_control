function varargout = ModelConfigure(varargin)
% MODELCONFIGURE MATLAB code for ModelConfigure.fig
%      MODELCONFIGURE, by itself, creates a new MODELCONFIGURE or raises the existing
%      singleton*.
%
%      H = MODELCONFIGURE returns the handle to a new MODELCONFIGURE or the handle to
%      the existing singleton*.
%
%      MODELCONFIGURE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MODELCONFIGURE.M with the given input arguments.
%
%      MODELCONFIGURE('Property','Value',...) creates a new MODELCONFIGURE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ModelConfigure_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ModelConfigure_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ModelConfigure

% Last Modified by GUIDE v2.5 23-Aug-2017 20:46:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ModelConfigure_OpeningFcn, ...
                   'gui_OutputFcn',  @ModelConfigure_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ModelConfigure is made visible.
function ModelConfigure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ModelConfigure (see VARARGIN)

% Choose default command line output for ModelConfigure
handles.output = hObject;

guidata(hObject,handles);

% UIWAIT makes ModelConfigure wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = ModelConfigure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function h10EditField_Callback(hObject, eventdata, handles)
% hObject    handle to h10EditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h10EditField as text
%        str2double(get(hObject,'String')) returns contents of h10EditField as a double
if ~isempty(str2num(handles.h10EditField.String)) && ~isempty(str2num(handles.h20EditField.String))
    gamma = str2num(handles.h20EditField.String)/str2num(handles.h10EditField.String);
    handles.gammaEditField.String = num2str(gamma);
    guidata(hObject, handles);
end



% --- Executes during object creation, after setting all properties.
function h10EditField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h10EditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function u0EditField_Callback(hObject, eventdata, handles)
% hObject    handle to u0EditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of u0EditField as text
%        str2double(get(hObject,'String')) returns contents of u0EditField as a double


% --- Executes during object creation, after setting all properties.
function u0EditField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u0EditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h20EditField_Callback(hObject, eventdata, handles)
% hObject    handle to h20EditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h20EditField as text
%        str2double(get(hObject,'String')) returns contents of h20EditField as a double
if ~isempty(str2num(handles.h10EditField.String)) && ~isempty(str2num(handles.h20EditField.String))
    gamma = str2num(handles.h20EditField.String)/str2num(handles.h10EditField.String);
    handles.gammaEditField.String = num2str(gamma);
    guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function h20EditField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h20EditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gamaEditField_Callback(hObject, eventdata, handles)
% hObject    handle to gammaEditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaEditField as text
%        str2double(get(hObject,'String')) returns contents of gammaEditField as a double


% --- Executes during object creation, after setting all properties.
function gammaEditField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaEditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tauEditField_Callback(hObject, eventdata, handles)
% hObject    handle to tauEditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tauEditField as text
%        str2double(get(hObject,'String')) returns contents of tauEditField as a double


% --- Executes during object creation, after setting all properties.
function tauEditField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tauEditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kappaEditField_Callback(hObject, eventdata, handles)
% hObject    handle to kappaEditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kappaEditField as text
%        str2double(get(hObject,'String')) returns contents of kappaEditField as a double


% --- Executes during object creation, after setting all properties.
function kappaEditField_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kappaEditField (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in defaultPushbutton.
function defaultPushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to defaultPushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h10=40; h20=40; u0=37.5;
gamma=h20/h10;
tau=18.46;
kappa=2.14;
handles.u0EditField.String = num2str(u0);
handles.h10EditField.String = num2str(h10);
handles.h20EditField.String = num2str(h20);
handles.gammaEditField.String = num2str(gamma);
handles.tauEditField.String = num2str(tau);
handles.kappaEditField.String = num2str(kappa);
guidata(hObject, handles);

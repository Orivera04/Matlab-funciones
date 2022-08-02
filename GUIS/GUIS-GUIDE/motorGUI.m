function varargout = motorGUI(varargin)
% MOTORGUI M-file for motorGUI.fig
%Author: Diego Orlando Barragán Guerrero
%For more information, visit: www.matpic.com
%diegokillemall@yahoo.com

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @motorGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @motorGUI_OutputFcn, ...
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


% --- Executes just before motorGUI is made visible.
function motorGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to motorGUI (see VARARGIN)
 diego=digitalio('parallel','LPT1');
 dato=addline(diego,0:3,'out');
 putvalue(dato,0);

% Choose default command line output for motorGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes motorGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = motorGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function speed_Callback(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of speed as text
%        str2double(get(hObject,'String')) returns contents of speed as a double
handles.delay=str2double(get(hObject,'String'))*1e-3;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in up.
function up_Callback(hObject, eventdata, handles)
global a
%return
a=str2double(get(handles.speed,'String'));
a=a+10;
set(handles.speed,'String',a);
handles.delay=a*1e-3;
guidata(hObject,handles);

% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
global a
%return
a=str2double(get(handles.speed,'String'));
a=a-10;
set(handles.speed,'String',a);
handles.delay=a*1e-3;
guidata(hObject,handles);


% --- Executes on button press in direction.
function direction_Callback(hObject, eventdata, handles)
% hObject    handle to direction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
f=get(handles.direction,'Value');
if f==1
    set(handles.direction,'String','DIRECTION ''L''');
else
    set(handles.direction,'String','DIRECTION ''R''');
end

% --- Executes on button press in state.
function state_Callback(hObject, eventdata, handles)
d=get(hObject,'Value');
if d==1
    set(handles.state,'String','ON');
    diego=digitalio('parallel','LPT1');
    dato=addline(diego,0:3,'out');
    g=1;
    while g
        e=get(handles.direction,'Value');
        if e==0
            mov=[3 6 12 9];
        else
            mov=[9 12 6 3];
        end
        delay=str2double(get(handles.speed,'String'))*1e-3;
        if delay<0 ||isnan(delay)
            errordlg('Time out of range','ERROR');
            delay=500;
            set(handles.speed,'String',500);
            set(handles.state,'String','OFF');
            set(handles.state,'Value',0);
            break;
        end
        if get(hObject,'Value')==0
            break
        end
        putvalue(dato,mov(1));
        pause(delay);
        if get(hObject,'Value')==0
            break
        end
        putvalue(dato,mov(2));
        pause(delay);
        if get(hObject,'Value')==0
            break
        end
        putvalue(dato,mov(3));
        pause(delay);
        if get(hObject,'Value')==0
            break
        end
        putvalue(dato,mov(4));
        pause(delay);
    end

else
    set(handles.state,'String','OFF');
end


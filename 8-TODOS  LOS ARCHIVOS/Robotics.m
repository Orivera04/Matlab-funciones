function varargout = Robotics(varargin)
% ROBOTICS M-file for Robotics.fig
%      ROBOTICS, by itself, creates a new ROBOTICS or raises the existing
%      singleton*.
%
%      H = ROBOTICS returns the handle to a new ROBOTICS or the handle to
%      the existing singleton*.
%
%      ROBOTICS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROBOTICS.M with the given input arguments.
%
%      ROBOTICS('Property','Value',...) creates a new ROBOTICS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Robotics_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Robotics_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Robotics

% Last Modified by GUIDE v2.5 16-Jan-2003 21:45:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Robotics_OpeningFcn, ...
                   'gui_OutputFcn',  @Robotics_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Robotics is made visible.
function Robotics_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Robotics (see VARARGIN)

% Choose default command line output for Robotics
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Robotics wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Robotics_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global vtau2
vtau2 = str2double(get(hObject,'string'))

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)

% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vtau2
vtau2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global vtau3
vtau3 = str2double(get(hObject,'string'))
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vtau3
vtau3 = str2double(get(hObject,'string'))
% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
global vtau4
vtau4 = str2double(get(hObject,'string'))
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global vtau4
vtau4 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global link1
link1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global link1
link1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global link2
link2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global link2
link2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global link3
link3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global link3
link3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global mass1
mass1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mass1
mass1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global mass2
mass2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mass2
mass2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global mass3
mass3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mass3
mass3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double

% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global forcex
forcex = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global forcex
forcex = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global forcey
forcey = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global forcey
forcey = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global forcez
forcez = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global forcez
forcez = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global torquex
torquex = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global torquex
torquex = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global torquey
torquey = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global torquey
torquey = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global torquez
torquez = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global torquez
torquez = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global teta01
teta01 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global teta01
teta01 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global teta02
teta02 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global teta02
teta02 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global teta03
teta03 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global teta03
teta03 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double

% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global center1
center1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global center1
center1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global center2
center2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global center2
center2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global center3
center3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global center3
center3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global gravity
gravity = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gravity
gravity = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global simtime
simtime = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global simtime
simtime = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixx1
Ixx1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixx1
Ixx1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixy1
Ixy1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixy1
Ixy1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixz1
Ixz1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixz1
Ixz1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixy1
Ixy1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixy1
Ixy1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Iyy1
Iyy1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iyy1
Iyy1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Iyz1
Iyz1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iyz1
Iyz1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixz1
Ixz1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixz1
Ixz1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Iyz1
Iyz1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iyz1
Iyz1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Izz1
Izz1 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Izz1
Izz1 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double







% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixx2
Ixx2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixx2
Ixx2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixy2
Ixy2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixy2
Ixy2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixz2
Ixz2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixz2
Ixz2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixy2
Ixy2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixy2
Ixy2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Iyy2
Iyy2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iyy2
Iyy2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Iyz2
Iyz2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iyz2
Iyz2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixz2
Ixz2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixz2
Ixz2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Iyz2
Iyz2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iyz2
Iyz2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Izz2
Izz2 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit41_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Izz2
Izz2 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixx3
Ixx3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit42_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixx3
Ixx3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixy3
Ixy3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit43_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixy3
Ixy3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixz3
Ixz3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit44_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixz3
Ixz3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixy3
Ixy3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit45_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixy3
Ixy3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit46_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Iyy3
Iyy3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit46_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iyy3
Iyy3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit47_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Iyz3
Iyz3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit47_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iyz3
Iyz3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit48_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Ixz3
Ixz3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit48_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Ixz3
Ixz3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit49_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Iyz3
Iyz3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit49_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Iyz3
Iyz3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit50_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global Izz3
Izz3 = str2double(get(hObject,'string'))

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit50_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Izz3
Izz3 = str2double(get(hObject,'string'))

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double






% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
robotics2

%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************
%**************************************************************************

function robotics2
global vtau2 vtau3 vtau4
global link1 link2 link3
global center1 center2 center3
global mass1 mass2 mass3
global forcex forcey forcez
global torquex torquey torquez
global teta01 teta02 teta03
global gravity simtime
global Ixx1 Iyy1 Izz1 Ixy1 Ixz1 Iyz1
global Ixx2 Iyy2 Izz2 Ixy2 Ixz2 Iyz2
global Ixx3 Iyy3 Izz3 Ixy3 Ixz3 Iyz3
%clear all
%clc
%===== Definition of Symbolic Parameters =====
syms tet_d_1 tet_dd_1 tet_d_2 tet_dd_2       
syms tet_d_3 tet_dd_3 tet_d_4 tet_dd_4
syms g t1 t2 t3 t4 t4 t5 m1 m2 m3 m4
syms l1 l2 l3 l4 lc1 lc2 lc3 lc4
syms ixx1 ixy1 ixz1 iyy1 iyz1 izz1
syms ixx2 ixy2 ixz2 iyy2 iyz2 izz2
syms ixx3 ixy3 ixz3 iyy3 iyz3 izz3
syms ixx4 ixy4 ixz4 iyy4 iyz4 izz4
syms w0x w0y w0z
syms wd0x wd0y wd0z
syms vd0x vd0y vd0z
syms vdc0x vdc0y vdc0z
syms fx fy fz
syms nx ny nz
%*********************************************

w0=[w0x;w0y;w0z];
wd0=[wd0x;wd0y;wd0z];
vd0=[vd0x;vd0y;vd0z];
vdc0=[vdc0x;vdc0y;vdc0z];

nn=4;
%We have nn Coordinate System with Index 1,2,3,...n   
f(:,nn+1)=[fx;fy;fz];
n(:,nn+1)=[nx;ny;nz];

P(:,1)=[l1;0;0];   %Distance of C.S(1) From C.S(0)
P(:,2)=[l2;0;0];   %Distance of C.S(2) From C.S(1)
P(:,3)=[l3;0;0];   %Distance of C.S(3) From C.S(2)
P(:,4)=[l4;0;0];   %Distance of C.S(4) From C.S(3)

Pc(:,1)=[lc1;0;0]; %Distance of C.M(1) From C.S(1)
Pc(:,2)=[lc2;0;0];
Pc(:,3)=[lc3;0;0];
Pc(:,4)=[lc4;0;0];


w(:,1) = w0;
wd(:,1)= wd0;
vd(:,1) = vd0;
vdc(:,1) = vdc0;

m = [m1;m2;m3;m4];  % Mass Matrix

td(:,1)=[0;0;tet_d_1];    % Teta_dot_1
td(:,2)=[0;0;tet_d_2];    % Teta_dot_2
td(:,3)=[0;0;tet_d_3];    % Teta_dot_3
td(:,4)=[0;0;tet_d_4];    % Teta_dot_4
tdd(:,1)=[0;0;tet_dd_1];  % Teta_ddot_1
tdd(:,2)=[0;0;tet_dd_2];  % Teta_ddot_2
tdd(:,3)=[0;0;tet_dd_3];  % Teta_ddot_3
tdd(:,4)=[0;0;tet_dd_4];  % Teta_ddot_4
%
%
% Coordinates Relations
R(:,:,1) = [cos(t2)  sin(t2) 0;  
       -sin(t2) cos(t2) 0;
       0        0       1];%R12
R(:,:,2) = [cos(t3)  sin(t3) 0;  
       -sin(t3) cos(t3) 0;
       0        0       1];%R23
R(:,:,3) = [cos(t4)  sin(t4) 0;  
       -sin(t4) cos(t4) 0;
       0        0       1];%R34
R(:,:,4) = [cos(t5)  sin(t5) 0;  
       -sin(t5) cos(t5) 0;
       0        0       1];%R45
   
RR(:,:,2) = [cos(t2) -sin(t2) 0;  
       sin(t2)  cos(t2) 0;
       0        0       1];%R21
RR(:,:,3) = [cos(t3) -sin(t3) 0; 
       sin(t3)  cos(t3) 0;
       0        0       1];%R32
RR(:,:,4) = [cos(t4) -sin(t4) 0; 
       sin(t4)  cos(t4) 0;
       0        0       1];%R43
RR(:,:,5) = [cos(t5) -sin(t5) 0; 
       sin(t5)  cos(t5) 0;
       0        0       1];%R54
%_______________________________
%   
% Moments of Inertia of Arms
% With respect to C.M.
Ic(:,:,1)=[ixx1,ixy1,ixz1;
     ixy1,iyy1,iyz1;
     ixz1,iyz1,izz1];
Ic(:,:,2)=[ixx2,ixy2,ixz2;
     ixy2,iyy2,iyz2;
     ixz2,iyz2,izz2];
Ic(:,:,3)=[ixx3,ixy3,ixz3;
     ixy3,iyy3,iyz3;
     ixz3,iyz3,izz3];
Ic(:,:,4)=[ixx4,ixy4,ixz4;
     ixy4,iyy4,iyz4;
     ixz4,iyz4,izz4];
%________________________________    
% ****Iterative Calculations*****
% Internal Calculations for 0-->3
for i=[1:1:nn-1]
    w(:,i+1)= R(:,:,i)*w(:,i) + td(:,i+1);
    wd(:,i+1)=R(:,:,i)*wd(:,i) + cross(R(:,:,i)*w(:,i),td(:,i+1)) + tdd(:,i+1);
    vd(:,i+1)=R(:,:,i)*(cross(wd(:,i),P(:,i)) + cross(w(:,i),cross(w(:,i),P(:,i))) + vd(:,i));
    vdc(:,i+1)=cross(wd(:,i+1),Pc(:,i+1)) + cross(w(:,i+1),cross(w(:,i+1),Pc(:,i+1))) + vd(:,i+1);
    F(:,i+1)=m(i+1)*vdc(:,i+1);
    N(:,i+1)=Ic(:,:,i+1)*wd(:,i+1) + cross(w(:,i+1),Ic(:,:,i+1)*w(:,i+1));
end
%
% Extenal Calculations for 4-->1
for i=[nn:-1:2]
    f(:,i)=RR(:,:,i+1)*f(:,i+1) + F(:,i);
    n(:,i)=N(:,i) + RR(:,:,i+1)*n(:,i+1) + cross(Pc(:,i),F(:,i)) + cross(P(:,i),RR(:,:,i+1)*f(:,i+1));
end
%
%______________End of Calculation______________*
%***********************************************
%***********************************************
%____________Parameters Evaluations____________*
%_______________________________________________
%
%***********************************************
%******** Robot Parameters Evaluation **********
%

%vtau2 =50;  % Active Torque of actuator on Arm 2
%vtau3 =-30;  % Active Torque of actuator on Arm 3
%vtau4 =-10;  % Active Torque of actuator on Arm 4
stime = simtime;  % Simulation Time
g=gravity;     % Gravity

%Initial Angular Position of Arms
t1=0;t2=teta01*pi/180;t3=teta02*pi/180;t4=teta03/180;t5=0;

w0x=0;w0y=0;w0z=0;        %Angular Velocity of C.S(1)
wd0x=0;wd0y=0;wd0z=0;     %Angular Acceleration of C.S(1)
vd0x=0;vd0y=g;vd0z=0;     %Linear Acceleration of C.S(1)
vdc0x=0;vdc0y=g;vdc0z=0;  %Acceleration of Center of Mass (1)

% Robot Arms Configurations
l1=0; l2=link1; l3=link2; l4=link3;   %Arms Lengths
lc1=0;lc2=center1;lc3=center2;lc4=center3;   %positions ofCenter of mass
m1=0;m2=mass1;m3=mass2;m4=mass3;        %Arms Mass

% Arms Moments of Inertias Calculated in Center of Mass
ixx1=0; ixy1=0; ixz1=0; iyy1=0; iyz1=0; izz1=0;
ixx2=Ixx1; ixy2=Ixy1; ixz2=Ixz1; iyy2=Iyy1; iyz2=Iyz1; izz2=Izz1;
ixx3=Ixx2; ixy3=Ixy2; ixz3=Ixz2; iyy3=Iyy2; iyz3=Iyz2; izz3=Izz2;
ixx4=Ixx3; ixy4=Ixy3; ixz4=Ixz3; iyy4=Iyy3; iyz4=Iyz3; izz4=Izz3;


% Force and Torques affected on End Effector
fx=forcex; fy=forcey; fz=forcez;  %Forces
nx=torquex; ny=torquey; nz=torquez;  %Torques

% Angular Velocities and Accelerations of Arms
tet_d_1=0; tet_dd_1=0; 
%tet_d_2=1; tet_dd_2=1;
%tet_d_3=2; tet_dd_3=2;
%tet_d_4=4; tet_dd_4=3;
%**********************************************************
%**********************************************************

tau4 = eval(n(3,2));
tau3 = eval(n(3,3));
tau2 = eval(n(3,4));


tau4=simple(tau4);
tau3=simple(tau3);
tau2=simple(tau2);

syms torque4 torque3 torque2;

tau4 = torque4-tau4;
tau3 = torque3-tau3;
tau2 = torque2-tau2;

res = solve(tau4,tau3,tau2,tet_dd_4,tet_dd_3,tet_dd_2);

tx2=char(simple(res.tet_dd_2));     % Tet_dd_2 = fcn(tau2,tau3,tau4,tet2,tet3,tet4,tet_d_2,tet_d3,tet_d4...)
tx3=char(simple(res.tet_dd_3));     % Tet_dd_3 = fcn(tau2,tau3,tau4,tet2,tet3,tet4,tet_d_2,tet_d3,tet_d4...)
tx4=char(simple(res.tet_dd_4));     % Tet_dd_4 = fcn(tau2,tau3,tau4,tet2,tet3,tet4,tet_d_2,tet_d3,tet_d4...)
%
%_______________________________________________________________________
%________ Function generator for Differential Equation Solver __________
%***********************************************************************
%
I = findstr(tx2,'tet_d_2');
if(~isempty(I))
    t44 = tx2(1:I(1)-1);
    for i = 2:length(I) t44 = [t44 'y(2)' tx2(I(i-1)+7:I(i)-1)]; end
    t44 = [t44 'y(2)' tx2(I(end)+7:end)];
else
    t44 = tx2;
end

I = findstr(t44,'tet_d_3'); 
if(~isempty(I))
    t45 = t44(1:I(1)-1);
    for i = 2:length(I) t45 = [t45 'y(4)' t44(I(i-1)+7:I(i)-1)]; end
    t45 = [t45 'y(4)' t44(I(end)+7:end)];
else
    t45 = t44;
end

I = findstr(t45,'tet_d_4'); 
if(~isempty(I))
    t46 = t45(1:I(1)-1);
    for i = 2:length(I) t46 = [t46 'y(6)' t45(I(i-1)+7:I(i)-1)]; end
    t46 = [t46 'y(6)' t45(I(end)+7:end)];
else
    t46 = t45;
end
text2=t46;
%********************************
I = findstr(tx3,'tet_d_2');
if(~isempty(I))
    t44 = tx3(1:I(1)-1);
    for i = 2:length(I) t44 = [t44 'y(2)' tx3(I(i-1)+7:I(i)-1)]; end
    t44 = [t44 'y(2)' tx3(I(end)+7:end)];
else
    t44 = tx3;
end

I = findstr(t44,'tet_d_3'); 
if(~isempty(I))
    t45 = t44(1:I(1)-1);
    for i = 2:length(I) t45 = [t45 'y(4)' t44(I(i-1)+7:I(i)-1)]; end
    t45 = [t45 'y(4)' t44(I(end)+7:end)];
else
    t45 = t44;
end

I = findstr(t45,'tet_d_4'); 
if(~isempty(I))
    t46 = t45(1:I(1)-1);
    for i = 2:length(I) t46 = [t46 'y(6)' t45(I(i-1)+7:I(i)-1)]; end
    t46 = [t46 'y(6)' t45(I(end)+7:end)];
else
    t46 = t45;
end
text3=t46;
%********************************
I = findstr(tx4,'tet_d_2');
if(~isempty(I))
    t44 = tx4(1:I(1)-1);
    for i = 2:length(I) t44 = [t44 'y(2)' tx4(I(i-1)+7:I(i)-1)]; end
    t44 = [t44 'y(2)' tx4(I(end)+7:end)];
else
    t44 = tx4;
end

I = findstr(t44,'tet_d_3'); 
if(~isempty(I))
    t45 = t44(1:I(1)-1);
    for i = 2:length(I) t45 = [t45 'y(4)' t44(I(i-1)+7:I(i)-1)]; end
    t45 = [t45 'y(4)' t44(I(end)+7:end)];
else
    t45 = t44;
end

I = findstr(t45,'tet_d_4'); 
if(~isempty(I))
    t46 = t45(1:I(1)-1);
    for i = 2:length(I) t46 = [t46 'y(6)' t45(I(i-1)+7:I(i)-1)]; end
    t46 = [t46 'y(6)' t45(I(end)+7:end)];
else
    t46 = t45;
end
text4=t46;
%
%_______________________________________________________________________
%________ Writing the equations in the teta2.m for simulation __________
%***********************************************************************
%
fid = fopen('simulation.m','w');

fprintf(fid,'function simulation\n');
fprintf(fid,'\n');
fprintf(fid,'options = odeset(''MaxStep'',.01);\n');
fprintf(fid,'[T,Y] = ode23(@tet,[0 %f],[%f 0 %f 0 %f 0 ],options);\n',stime,t2,t3,t4);
fprintf(fid,'\n');

fprintf(fid,'mw=vrworld(''link.wrl'');\n');
fprintf(fid,'open(mw);\n');
fprintf(fid,'view(mw);\n');
fprintf(fid,'\n');

fprintf(fid,'l1=%f;\n',l2);
fprintf(fid,'l2=%f;\n',l3);
fprintf(fid,'l3=%f;\n',l4);
fprintf(fid,'\n');

fprintf(fid,'mw.LS1.size = [l1 .2 .1];\n');
fprintf(fid,'mw.LS2.size = [l2 .2 .1];\n');
fprintf(fid,'mw.LS3.size = [l3 .2 .1];\n');
fprintf(fid,'\n');


fprintf(fid,'x1=l1/2*cos(Y(:,1));\n');
fprintf(fid,'y1=l1/2*sin(Y(:,1));\n');
fprintf(fid,'xc1=l1*cos(Y(:,1));\n');
fprintf(fid,'yc1=l1*sin(Y(:,1));\n');
fprintf(fid,'\n');
fprintf(fid,'x2=xc1 + l2/2*cos(Y(:,3));\n');
fprintf(fid,'y2=yc1 + l2/2*sin(Y(:,3));\n');
fprintf(fid,'xc2=xc1 + l2*cos(Y(:,3));\n');
fprintf(fid,'yc2=yc1 + l2*sin(Y(:,3));\n');
fprintf(fid,'\n');
fprintf(fid,'x3=xc2 + l3/2*cos(Y(:,5));\n');
fprintf(fid,'y3=yc2 + l3/2*sin(Y(:,5));\n');
fprintf(fid,'\n');

fprintf(fid,'mw.view.position = [1 0 20];\n');
fprintf(fid,'\n');

fprintf(fid,'mw.BG.translation = [0 -10 -40];\n');
fprintf(fid,'mw.BC.translation = [2000 1000 0];\n');
fprintf(fid,'mw.CC1.radius=.2;\n');
fprintf(fid,'mw.CC1.height=.2;\n');
fprintf(fid,'mw.CC2.radius=.2;\n');
fprintf(fid,'mw.CC2.height=.2;\n');
fprintf(fid,'mw.CC3.radius=.3;\n');
fprintf(fid,'mw.CC3.height=.3;\n');
fprintf(fid,'mw.C1.rotation = [1 0 0 pi/2];\n');
fprintf(fid,'mw.C2.rotation = [1 0 0 pi/2];\n');
fprintf(fid,'mw.C3.rotation = [1 0 0 pi/2];\n');
fprintf(fid,'mw.BB.size = [.5 2 .5];\n');
fprintf(fid,'mw.Base.translation = [0 -.5 -.2];\n');
fprintf(fid,'mw.C3.translation = [0 0 0.2];\n');
fprintf(fid,'\n');

fprintf(fid,'mw.view.position = [1 0 10];\n');
fprintf(fid,'for i=1:length(Y(:,1))\n');
fprintf(fid,'mw.L1.translation = [x1(i) y1(i) 0];vrdrawnow;\n');
fprintf(fid,'mw.L2.translation = [x2(i) y2(i) 0];vrdrawnow;\n');
fprintf(fid,'mw.L3.translation = [x3(i) y3(i) 0];vrdrawnow;\n');
fprintf(fid,'\n');
fprintf(fid,'mw.C1.translation = [xc1(i) yc1(i) 0];vrdrawnow;\n');
fprintf(fid,'mw.C2.translation = [xc2(i) yc2(i) 0];vrdrawnow;\n');
fprintf(fid,'\n');

fprintf(fid,'mw.L1.rotation = [0 0 1 Y(i,1)];vrdrawnow;\n');
fprintf(fid,'mw.L2.rotation = [0 0 1 Y(i,3)];vrdrawnow;\n');
fprintf(fid,'mw.L3.rotation = [0 0 1 Y(i,5)];vrdrawnow;\n');
fprintf(fid,'pause(0.1);\n');
fprintf(fid,'end\n');


fprintf(fid,'subplot(3,2,1);\n');
fprintf(fid,'plot(T,Y(:,1))\n');
fprintf(fid,'grid;\n');
fprintf(fid,'title(''Teta'');\n');
fprintf(fid,'ylabel(''Teta(1)'');\n');
fprintf(fid,'subplot(3,2,2);\n');
fprintf(fid,'plot(T,Y(:,2))\n');
fprintf(fid,'grid;\n');
fprintf(fid,'title(''Teta-dot'');\n');
fprintf(fid,'ylabel(''Teta-dot-1'');\n');
fprintf(fid,'\n');

fprintf(fid,'subplot(3,2,3);\n');
fprintf(fid,'plot(T,Y(:,3))\n');
fprintf(fid,'grid;\n');
fprintf(fid,'ylabel(''Teta(2)'');\n');
fprintf(fid,'subplot(3,2,4);\n');
fprintf(fid,'plot(T,Y(:,4))\n');
fprintf(fid,'grid;\n');
fprintf(fid,'ylabel(''Teta-dot-2'');\n');
fprintf(fid,'\n');

fprintf(fid,'subplot(3,2,5);\n');
fprintf(fid,'plot(T,Y(:,5));\n');
fprintf(fid,'grid;\n');
fprintf(fid,'xlabel(''time t'');\n');
fprintf(fid,'ylabel(''Teta(3)'');\n');
fprintf(fid,'subplot(3,2,6);\n');
fprintf(fid,'plot(T,Y(:,6));\n');
fprintf(fid,'grid;\n');
fprintf(fid,'xlabel(''time t'');\n');
fprintf(fid,'ylabel(''Teta-dot-3'');\n');
fprintf(fid,'\n');

fprintf(fid,'function dy = tet(t,y)\n');
fprintf(fid,'torque2 = %f;\n',vtau2);
fprintf(fid,'torque3 = %f;\n',vtau3);
fprintf(fid,'torque4 = %f;\n',vtau4);
fprintf(fid,'dy = zeros(6,1);\n');
fprintf(fid,'dy(1) = y(2);\n');
fprintf(fid,'dy(2) = %s;\n',text2);
fprintf(fid,'dy(3) = y(4);\n');
fprintf(fid,'dy(4) = %s;\n',text3);
fprintf(fid,'dy(5) = y(6);\n');
fprintf(fid,'dy(6) = %s;\n',text4);

fclose(fid);
simulation

% The End
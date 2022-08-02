function varargout = frenetgui(varargin)
% FRENETGUI M-file for frenetgui.fig
%      FRENETGUI, by itself, creates a new FRENETGUI or raises the existing
%      singleton*.
%
%      H = FRENETGUI returns the handle to a new FRENETGUI or the handle to
%      the existing singleton*.
%
%      FRENETGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRENETGUI.M with the given input arguments.
%
%      FRENETGUI('Property','Value',...) creates a new FRENETGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before frenetgui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to frenetgui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help frenetgui

% Last Modified by GUIDE v2.5 07-Jan-2005 20:49:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @frenetgui_OpeningFcn, ...
                   'gui_OutputFcn',  @frenetgui_OutputFcn, ...
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


% --- Executes just before frenetgui is made visible.
function frenetgui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to frenetgui (see VARARGIN)

% Choose default command line output for frenetgui
handles.output = hObject;
h = [handles.axesonoff, handles.rotateonoff, handles.zoomonoff,...
    handles.stop, handles.factor,handles.frenetvisualize, ...
    handles.textfactor];
set(handles.figure1, 'Userdata', h)
set(h, 'Enable', 'off')
set(handles.axes1, 'box', 'off')
set(h(1:3), 'Value', 0)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes frenetgui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = frenetgui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in curvature.
function curvature_Callback(hObject, eventdata, handles)
% hObject    handle to curvature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns curvature contents as cell array
%        contents{get(hObject,'Value')} returns selected item from curvature
contents = get(hObject,'String');
curv = contents{get(hObject,'Value')};
set(handles.curvaturenewedit, 'String', curv);
h = get(handles.figure1, 'Userdata');
set(h, 'Enable', 'off')
% --- Executes during object creation, after setting all properties.
function curvature_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curvature (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in torsion.
function torsion_Callback(hObject, eventdata, handles)
% hObject    handle to torsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns torsion contents as cell array
%        contents{get(hObject,'Value')} returns selected item from torsion
contents = get(hObject,'String');
tors = contents{get(hObject,'Value')};
set(handles.torsionnewedit, 'String', tors);
h = get(handles.figure1, 'Userdata');
set(h, 'Enable', 'off')


% --- Executes during object creation, after setting all properties.
function torsion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to torsion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in orbitcurve.
function orbitcurve_Callback(hObject, eventdata, handles)
% hObject    handle to orbitcurve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = get(handles.figure1, 'Userdata');
set(h, 'Enable', 'off')
axes(handles.axes1)
cla

curvature = get(handles.curvaturenewedit, 'String');
torsion = get(handles.torsionnewedit, 'String');
T0 = str2num(get(handles.initialtangentvector, 'String'));
N0 = str2num(get(handles.initialnormalvector, 'String'));
tspan = str2num(get(handles.tspan, 'String'));

[t,Tg,Nm,Bn,x] = frenet(curvature,torsion, T0,N0, tspan,handles);
data.t = t;
data.x = x;
data.Tg = Tg;
data.Nm = Nm;
data.Bn = Bn;
data.j = 0;
set(handles.orbitcurve, 'Userdata', data)
h = get(handles.figure1, 'Userdata');
set(h, 'Enable', 'on')

set(handles.stop, 'userdata', 0, 'String', 'Stop', 'Enable', 'off');

% --- Executes on button press in frenetvisualize.
function frenetvisualize_Callback(hObject, eventdata, handles)
% hObject    handle to frenetvisualize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.stop, 'Enable', 'on', 'String', 'Freeze')
data = get(handles.orbitcurve, 'Userdata');
factor = get(handles.factor, 'Value');

visualizefrenet(0,data.x,data.Tg,data.Nm,data.Bn,data.t, factor, handles);


% --- Executes on slider movement.
function factor_Callback(hObject, eventdata, handles)
% hObject    handle to factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curvaturenewedit_Callback(hObject, eventdata, handles)
% hObject    handle to curvaturenewedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curvaturenewedit as text
%        str2double(get(hObject,'String')) returns contents of curvaturenewedit as a double
newcurvature = get(hObject,'String');
curvature = get(handles.curvature,'String');
curvature{end+1} = newcurvature;
set(handles.curvature,'String',curvature);
h = get(handles.figure1, 'Userdata');
set(h, 'Enable', 'off')


% --- Executes during object creation, after setting all properties.
function curvaturenewedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curvaturenewedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function torsionnewedit_Callback(hObject, eventdata, handles)
% hObject    handle to torsionnewedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of torsionnewedit as text
%        str2double(get(hObject,'String')) returns contents of torsionnewedit as a double
newtorsion = get(hObject,'String');
torsion = get(handles.torsion,'String');
torsion{end+1} = newtorsion;
set(handles.torsion,'String',torsion);
h = get(handles.figure1, 'Userdata');
set(h, 'Enable', 'off')

% --- Executes during object creation, after setting all properties.
function torsionnewedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to torsionnewedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curvatureedit_Callback(hObject, eventdata, handles)
% hObject    handle to curvatureedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curvatureedit as text
%        str2double(get(hObject,'String')) returns contents of curvatureedit as a double
newcurv = get(hObject,'String');
curv = get(handles.curvature,'String');
curv{end+1} = newcurv;
set(handles.curvature,'String',curv);



% --- Executes during object creation, after setting all properties.
function curvatureedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curvatureedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function initialnormalvector_Callback(hObject, eventdata, handles)
% hObject    handle to initialnormalvector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initialnormalvector as text
%        str2double(get(hObject,'String')) returns contents of initialnormalvector as a double


% --- Executes during object creation, after setting all properties.
function initialnormalvector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initialnormalvector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tspan_Callback(hObject, eventdata, handles)
% hObject    handle to tspan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tspan as text
%        str2double(get(hObject,'String')) returns contents of tspan as a double


% --- Executes during object creation, after setting all properties.
function tspan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tspan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in axesonoff.
function axesonoff_Callback(hObject, eventdata, handles)
% hObject    handle to axesonoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject, 'Value')
    axis on
    set(hObject, 'String', 'Axes off')
else
    axis off
    set(hObject, 'String', 'Axes on')
   
    
end



% --- Executes on button press in rotateonoff.
function rotateonoff_Callback(hObject, eventdata, handles)
% hObject    handle to rotateonoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject, 'Value')
    set(hObject, 'String', 'Rotate off')
    rotate3d on
else
    set(hObject, 'String', 'Rotate on')
    rotate3d off
    
end





function initialtangentvector_Callback(hObject, eventdata, handles)
% hObject    handle to initialtangentvector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of initialtangentvector as text
%        str2double(get(hObject,'String')) returns contents of initialtangentvector as a double


% --- Executes during object creation, after setting all properties.
function initialtangentvector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to initialtangentvector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s = get(hObject, 'String');
if strncmp(s,'Freeze',6)
    set(handles.stop,'String', 'Resume')
else
    j = get(handles.stop, 'Userdata');
    set(handles.stop, 'String', 'Freeze')
    data = get(handles.orbitcurve, 'Userdata');
    factor = get(handles.factor, 'Value');
    visualizefrenet(j,data.x,data.Tg,data.Nm,data.Bn,data.t, factor, handles)
end

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
cla
set(handles.axes1, 'Visible', 'off')
h = get(handles.figure1, 'Userdata');
set(h, 'Enable', 'off')
set(handles.axes1, 'box', 'off')
set(h(1:3), 'Value', 0)
set(h(1),'String', 'Axes on')
set(h(2), 'String','Rotate on')
set(h(3), 'String','Zoom on')







% --- Executes on button press in zoomonoff.
function zoomonoff_Callback(hObject, eventdata, handles)
% hObject    handle to zoomonoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zoomonoff
if get(hObject, 'Value')
    set(hObject, 'String', 'Zoom off')
    zoom on
else
    set(hObject, 'String', 'Zoom on')
    zoom off
    
end







% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function varargout = Gielis3d(varargin)
% The superformula is a generalization of the superellipse and was first
% proposed by Johan Gielis.
% 
% Gielis suggested that the formula can be used to describe many complex
% shapes and curves that are found in nature. Others point out that the
% same can be said about many formulas with a sufficient number of
% parameters.
% Gielis, Johan (2003), "A generic geometric transformation that unifies a
% wide range of natural and abstract shapes", American Journal of Botany 90(3): 333–338, 
% 
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2006). Superformula Generator 3d: a GUI interface to trace a
% 3d plot of the parametric Gielis Superformula.  
% http://www.mathworks.com/matlabcentral/fileexchange/10190

% Last Modified by GUIDE v2.5 23-Feb-2008 16:02:50

% Begin initialization code - DO NOT EDIT
warning('off','MATLAB:dispatcher:InexactMatch')
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gielis3d_OpeningFcn, ...
                   'gui_OutputFcn',  @Gielis3d_OutputFcn, ...
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


% --- Executes just before Gielis3d is made visible.
function Gielis3d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gielis3d (see VARARGIN)
handles.parameters1={1 1 0 1 1 1};
handles.parameters2={1 1 0 1 1 1};
handles.ft=[1 1];
handles.pl=1;
handles.sha=1;

% Choose default command line output for Gielis3d
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gielis3d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gielis3d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters1{1}=1;
elseif tmp==0 % check the A limitation
    msgbox('A parameter must be ~= 0','Error','error','non-modal');
    set(hObject, 'String', '1');
    handles.parameters1{1}=1;
else
    handles.parameters1{1}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters1{2}=1;
elseif tmp==0 % check the B limitation
    msgbox('B parameter must be ~= 0','Error','error','non-modal');
    set(hObject, 'String', '1');
    handles.parameters1{2}=1;
else
    handles.parameters1{2}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '0');
    handles.parameters1{3}=0;
else
    handles.parameters1{3}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double


% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters1{4}=1;
elseif tmp<0 % check the n1 limitation
    msgbox('n1 parameter must be > 0','Error','error','non-modal');
    set(hObject, 'String', '1');
    handles.parameters1{4}=1;
else
    handles.parameters1{4}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters1{5}=1;
else
    handles.parameters1{5}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters1{6}=1;
else
    handles.parameters1{6}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters2{1}=1;
elseif tmp==0 % check the A limitation
    msgbox('A parameter must be ~= 0','Error','error','non-modal');
    set(hObject, 'String', '1');
    handles.parameters2{1}=1;
else
    handles.parameters2{1}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters2{2}=1;
elseif tmp==0 % check the B limitation
    msgbox('B parameter must be ~= 0','Error','error','non-modal');
    set(hObject, 'String', '1');
    handles.parameters2{2}=1;
else
    handles.parameters2{2}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '0');
    handles.parameters2{3}=0;
else
    handles.parameters2{3}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters2{4}=1;
elseif tmp<0 % check the n1 limitation
    msgbox('n1 parameter must be > 0','Error','error','non-modal');
    set(hObject, 'String', '1');
    handles.parameters2{4}=1;
else
    handles.parameters2{4}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters2{5}=1;
else
    handles.parameters2{5}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters2{6}=1;
else
    handles.parameters2{6}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set the angles array
theta=angolo(handles.parameters1,handles.pl);
phi=angolo(handles.parameters2,handles.pl);
[phi,theta] = meshgrid(phi,theta);
%calculate the radius
r1=superformula(handles.parameters1,theta,handles.ft(1));
r2=superformula(handles.parameters2,phi,handles.ft(2));
%convert in spherical coordinates
x=r1.*cos(theta).*r2.*cos(phi);
y=r1.*sin(theta).*r2.*cos(phi);
z=r2.*sin(phi);
switch handles.pl
    case 1
        surf(x,y,z);
        shd=['flat    ';'interp  ';'faceted '];
        shading(deblank(shd(handles.sha,:)))
    case 2
        plot3(x,y,z)    
end
axis('square'); xlabel('x'); ylabel('y'); zlabel('z'); title('Use the mouse to rotate the object')
rotate3d on

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clmp=['hsv       ';'hot       ';'gray      ';'bone      ';'copper    ';'pink      ';'flag      ';'lines     ';'colorcube ';'vga       ';'jet       ';'prism     ';'cool      ';'autumn    ';'spring    ';'winter    ';'summer    '];
colormap(deblank(clmp(get(handles.popupmenu2, 'Value'),:)))

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shading flat
handles.sha=1;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton12




% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shading interp
handles.sha=2;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton13




% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shading faceted
handles.sha=3;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton14




% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel6, 'Visible', 'on');
set(handles.popupmenu2, 'Enable', 'on');
handles.pl=1;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton15




% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanel6, 'Visible', 'off');
set(handles.popupmenu2, 'Enable', 'off');
handles.pl=2;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton16




% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ft(1)=1;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton17




% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ft(1)=2;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton18




% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ft(1)=3;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton19




% --- Executes on button press in radiobutton23.
function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ft(2)=1;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton23




% --- Executes on button press in radiobutton24.
function radiobutton24_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ft(2)=2;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton24




% --- Executes on button press in radiobutton25.
function radiobutton25_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ft(2)=3;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton25


function x=angolo(parameters,pl)
[a,b,m,n1,n2,n3]=deal(parameters{:});
[n,d]=rat(m); %rational form of m
%select the upper bound of angle
if mod(n,2)==0 || (a==b && n2==n3)
    u=2*d;
else
    u=4*d;
end
%select the number of points
switch pl
    case 1
        n=80;
    case 2
        n=300;
end
x=linspace(0,u*pi,n);

function r=superformula(parameters,ang,sf)
[a,b,m,n1,n2,n3]=deal(parameters{:});
switch sf
    case 1
        ftheta=ones(size(ang));
    case 2
        ftheta=cos(2.5.*ang);
    case 3
        ftheta=exp(0.1.*ang);
end
r=ftheta.*(abs(cos(m.*ang./4)./a).^n2+abs(sin(m.*ang./4)./b).^n3).^(-1/n1);    
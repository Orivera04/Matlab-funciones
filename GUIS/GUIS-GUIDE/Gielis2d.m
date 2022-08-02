function varargout = Gielis2d(varargin)
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
% Cardillo G. (2006). Superformula Generator 2d: a GUI interface to trace a
% 2d plot of the parametric Gielis Superformula.
% http://www.mathworks.com/matlabcentral/fileexchange/10189

% Begin initialization code - DO NOT EDIT
warning('off','MATLAB:dispatcher:InexactMatch')
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gielis2d_OpeningFcn, ...
                   'gui_OutputFcn',  @Gielis2d_OutputFcn, ...
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


% --- Executes just before Gielis2d is made visible.
function Gielis2d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gielis2d (see VARARGIN)

handles.parameters={1 1 0 1 1 1};
handles.ft=1;
handles.dr=1;

% Choose default command line output for Gielis2d
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gielis2d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gielis2d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters{1}=1;
elseif tmp==0 % check the A limitation
    msgbox('A parameter must be ~= 0','Error','error','non-modal');
    set(hObject, 'String', '1');
        handles.parameters{1}=1;
else
    handles.parameters{1}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters{2}=1;
elseif tmp==0 % check the B limitation
    msgbox('B parameter must be ~= 0','Error','error','non-modal');
    set(hObject, 'String', '1');    
    handles.parameters{2}=1;
else
    handles.parameters{2}=tmp;    
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '0');
    handles.parameters{3}=0;
else
    handles.parameters{3}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters{4}=1;
elseif tmp<0 % check the n1 limitation
    msgbox('n1 parameter must be > 0','Error','error','non-modal');
    set(hObject, 'String', '1');
    handles.parameters{4}=1;
else
    handles.parameters{4}=tmp;
end
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters{5}=1;
else
    handles.parameters{5}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp=str2double(get(hObject,'String')); %get value of the text control
if isnan(tmp) %if is not a number set the default value in text control and in data.parameter array
    msgbox('Input must be a number','Error','error');
    set(hObject, 'String', '1');
    handles.parameters{6}=1;
else
    handles.parameters{6}=tmp;
end
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
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
[a,b,m,n1,n2,n3]=deal(handles.parameters{:});
[n,d]=rat(m); %rational form of m
switch handles.ft
    case 1
        %select the upper bound of theta
        if mod(n,2)==0 || (a==b && n2==n3) 
            u=2*d;
        else
            u=4*d;
        end
        theta=linspace(0,u*pi,500*u);
        ftheta=ones(size(theta));
    case 2
        u=4.*d;
        theta=linspace(0,u*pi,500*u);
        ftheta=cos(2.5.*theta);
    case 3
        theta=linspace(0,8*pi,5000);
        ftheta=exp(0.1.*theta);
end
rho=ftheta.*(abs(cos(m.*theta./4)./a).^n2+abs(sin(m.*theta./4)./b).^n3).^(-1/n1);
%select the plot
switch handles.dr
    case 1
        polar(theta,rho)
    case 2
        [x,y]=pol2cart(theta,rho);
        plot(x,y)
        axis equal
    case 3
        [x,y]=pol2cart(theta,rho);
        axis equal
        comet(x,y)
end

% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.dr=1;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton7




% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.dr=2;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton8




% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.dr=3;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton9




% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ft=1;
guidata(hObject, handles);

% Hint: get(hObject,'Value') returns toggle state of radiobutton10




% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ft=2;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton11




% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ft=3;
guidata(hObject, handles);
% Hint: get(hObject,'Value') returns toggle state of radiobutton12



function varargout = gui(varargin)
% GUI M-file for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 15-May-2004 15:08:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

handles.fig1hndl=0;
handles.fig2hndl=0;
handles.fig3hndl=0;
handles=setvars(hObject, handles);

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function mass_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mass_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function mass_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mass_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mass_edit as text
%        str2double(get(hObject,'String')) returns contents of mass_edit as a double


% --- Executes during object creation, after setting all properties.
function length_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function length_edit_Callback(hObject, eventdata, handles)
% hObject    handle to length_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of length_edit as text
%        str2double(get(hObject,'String')) returns contents of length_edit as a double


% --- Executes during object creation, after setting all properties.
function spring_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spring_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function spring_edit_Callback(hObject, eventdata, handles)
% hObject    handle to spring_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of spring_edit as text
%        str2double(get(hObject,'String')) returns contents of spring_edit as a double


% --- Executes during object creation, after setting all properties.
function springdist_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to springdist_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function springdist_edit_Callback(hObject, eventdata, handles)
% hObject    handle to springdist_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of springdist_edit as text
%        str2double(get(hObject,'String')) returns contents of springdist_edit as a double


% --- Executes on button press in calc_equil.
function calc_equil_Callback(hObject, eventdata, handles)
% hObject    handle to calc_equil (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=setvars(hObject, handles);
theta=linspace(0,pi/2);
u=2*handles.I*handles.h^2./sin(theta).^2 ...
    + 2*handles.m*handles.g*handles.R*cos(theta) ...
    + 4*handles.k*handles.b^2*sin(theta).^2;
[Y,I]=min(u)
theta(I)


% --- Executes during object creation, after setting all properties.
function angvel_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to angvel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function angvel_edit_Callback(hObject, eventdata, handles)
% hObject    handle to angvel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of angvel_edit as text
%        str2double(get(hObject,'String')) returns contents of angvel_edit as a double


% --- Executes during object creation, after setting all properties.
function rot_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rot_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rot_edit_Callback(hObject, eventdata, handles)
% hObject    handle to rot_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rot_edit as text
%        str2double(get(hObject,'String')) returns contents of rot_edit as
%        a double


% --- Executes on button press in graph_btn.
function graph_btn_Callback(hObject, eventdata, handles)
% hObject    handle to graph_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles=setvars(hObject, handles);

theta=linspace(0,pi/2,100);
cent=2*handles.I*handles.h^2./sin(theta);
grav=2*handles.m*handles.g*handles.R*cos(theta);
spring=4*handles.k*handles.b^2*sin(theta).^2;

if handles.fig1hndl == 0
    figure
    handles.fig1hndl=gcf;
end

guidata(hObject, handles)

figure(handles.fig1hndl);
clf;

plot(theta, cent, ...
    theta, grav, ...
    theta, spring, ...
   theta, cent + grav + spring);
legend('Centrifugal', 'Gravitational', 'Spring', 'Total');

top=max(spring);
axis([0, pi/2, 0, top+1/4*top]);


if handles.fig2hndl == 0
    figure
    handles.fig2hndl=gcf;
end

guidata(hObject, handles);

figure(handles.fig2hndl);
options=[];

[t,x]=ode45(@F, ...
            0:0.001:1, ...
            [handles.pinit,handles.pdinit,handles.tinit,handles.tdinit], ...
            options, ...
            handles.m, handles.R, handles.k, handles.b);

subplot(2,2,1);
plot(t,x(:,1));
xlabel('t');
ylabel('Phi');
tvsthetavsphi=[t,x(:,3),x(:,1)]

subplot(2,2,2);
h=plot(t,x(:,2));
set(h, 'Color', [0,0.5,0]);
xlabel('t');
ylabel('Phidot');

subplot(2,2,3);
h=plot(t,x(:,3));
set(h, 'Color', 'r');
xlabel('t');
ylabel('Theta');

subplot(2,2,4);
plot(t,x);
legend('Phi', 'Phidot', 'Theta', 'Thetadot');
xlabel('t');

if handles.fig3hndl == 0
    figure
    handles.fig3hndl=gcf;
end


        
function xprime=F(t, x, m, R, k, b)
g=9.8;
I=m*R^2/3;

q=m*g*R/(2*I);
w=2*k*b^2/I;

xprime=[x(2); ...
        ...
        -2*x(4)*x(2)*cos(x(3))/sin(x(3)); ...
        ...
        x(4); ...
        ...
        q*sin(x(3))-(w-x(2)^2)*sin(x(3))*cos(x(3))];

function ret=setvars(hObject, handles)
g=9.8;
m=str2double(get(handles.mass_edit,'String'));
R=str2double(get(handles.length_edit,'String'));
k=str2double(get(handles.spring_edit,'String'));
b=str2double(get(handles.springdist_edit,'String'));
I=1/3*m*R^2;
tinit=eval(get(handles.rot_edit,'String'));
tdinit=0;
pinit=0;
pdinit=eval(get(handles.angvel_edit,'String'));
h=pdinit*sin(tinit)^2;

handles.g=g;
handles.m=m;
handles.R=R;
handles.k=k;
handles.b=b;
handles.I=I;
handles.tinit=tinit;
handles.tdinit=tdinit;
handles.pinit=pinit;
handles.pdinit=pinit;
handles.pdinit=pdinit;
handles.h=h;
guidata(hObject, handles);
ret=handles;

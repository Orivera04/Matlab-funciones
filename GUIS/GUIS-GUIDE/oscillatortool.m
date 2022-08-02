%This gui solve the equation mX``+bX`+kx=F



function varargout = oscillatortool(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @oscillatortool_OpeningFcn, ...
                   'gui_OutputFcn',  @oscillatortool_OutputFcn, ...
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
function oscillatortool_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;


guidata(hObject, handles);


function varargout = oscillatortool_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
function edit2_Callback(hObject, eventdata, handles)

function edit2_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit3_Callback(hObject, eventdata, handles)

function edit3_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit4_Callback(hObject, eventdata, handles)

function edit4_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit5_Callback(hObject, eventdata, handles)



function edit5_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
function edit6_Callback(hObject, eventdata, handles)

function edit6_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function pushbutton1_Callback(hObject, eventdata, handles)
m=str2double(get(handles.edit2,'string'));
b=str2double(get(handles.edit3,'string'));
k=str2double(get(handles.edit4,'string'));

t0=str2double(get(handles.edit5,'string'));
tf=str2double(get(handles.edit6,'string'));
x0=str2double(get(handles.edit7,'string'));
v0=str2double(get(handles.edit8,'string'));
fun=get(handles.edit9,'string');

ode=@(t,y,m,b,k) [y(2);-b/m*y(2)-k/m*y(1)+eval(fun)];
phasev=(get(handles.checkbox1,'value'));
if phasev==0
   [t,y]= ode45(ode,[t0 tf],[x0,v0],[],m,b,k);

plot(t,y(:,1),t,y(:,2))
grid on
legend('X','V')
else
    op=odeset('OutputFcn','odephas2');
 ode45(ode,[t0 tf],[x0,v0],op,m,b,k);
%plot(t,y(:,1),t,y(:,2))
  legend('X','V')
grid on
end

function edit7_Callback(hObject, eventdata, handles)

function edit7_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit8_Callback(hObject, eventdata, handles)

function edit8_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function checkbox1_Callback(hObject, eventdata, handles)






function edit9_Callback(hObject, eventdata, handles)

function edit9_CreateFcn(hObject, eventdata, handles)

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function checkbox2_Callback(hObject, eventdata, handles)


if get(hObject,'value')==1
    set(handles.edit9,'visible','on');
    set(handles.text10,'visible','on');
else
    set(handles.edit9,'visible','off');
    set(handles.text10,'visible','off');
    set(handles.edit9,'string','0');
end




% --------------------------------------------------------------------
function ppp_Callback(hObject, eventdata, handles)




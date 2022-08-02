function varargout = Soup(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Soup_OpeningFcn, ...
                   'gui_OutputFcn',  @Soup_OutputFcn, ...
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


% --- Executes just before Soup is made visible.
function Soup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Soup (see VARARGIN)

% Choose default command line output for Soup
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Soup wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Soup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function R_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function R_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
g='squareg'; % The unit square
b='squareb1'; % 0 on the boundary
handles.R = str2double(get(handles.R,'String'))
a = str2double(get(handles.edit2,'String'))
c = str2double(get(handles.edit3,'String'))
d = str2double(get(handles.edit4,'String'))
f = str2double(get(handles.edit5,'String'))

Tim = str2double(get(handles.edit6,'String'))
handles.nframes = str2double(get(handles.edit7,'String'))
%       Mesh
[p,e,t]=initmesh(g);

%       Initial condition: 1 inside the circle with radius 0.4.
%       0 otherwise.
u0=zeros(size(p,2),1);
ix=find(sqrt(p(1,:).^2+p(2,:).^2)<handles.R);
u0(ix)=ones(size(ix));

%       We want the solution at 20 points in time between 0 and 0.1.
tlist=linspace(0,Tim,handles.nframes);

%       Solve parabolic problem
handles.u1=parabolic(u0,tlist,b,p,e,t,c,a,f,d);
%       To speed up the plotting, we interpolate to a rectangular grid.
x=linspace(-1,1,21);y=x;
[unused,tn,a2,a3]=tri2grid(p,t,u0,x,y);

%       Make the animation
newplot;
handles.Mv = moviein(handles.nframes);
umax=max(max(handles.u1));
umin=min(min(handles.u1));
for j=1:handles.nframes,...
  u=tri2grid(p,t,handles.u1(:,j),tn,a2,a3);i=find(isnan(u));u(i)=zeros(size(i));...
  surf(x,y,u);caxis([umin umax]);colormap(cool),...
  axis([-1 1 -1 1 0 1]);...
  handles.Mv(:,j) = getframe;...
end
guidata(hObject, handles);

% --- Executes on button press in Save_as.
function Save_as_Callback(hObject, eventdata, handles)
[filename, pathname] = uiputfile('*.avi', 'Save As...');
if isequal(filename,0) | isequal(pathname,0)
    disp('User selected Cancel')
else
    file = fullfile(pathname,filename);
    disp(['User selected: ',file])
end
fps = str2double(get(handles.edit8,'String'))
movie2avi(handles.Mv,file,'fps',fps);

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
close


% --- Executes on button press in Local.
function Local_Callback(hObject, eventdata, handles)
% hObject    handle to Local (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    prompt={'X Position:','Y Position:','Time:'};
    name='Local Properties of Solution';
    numlines=1;
    defaultanswer={num2str(0.7),num2str(1.3),num2str(0.1)};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    xx = eval(char(answer(1)));
    yy = eval(char(answer(2)));
    tt = eval(char(answer(2)));

g='squareg'; % The unit square
[p,e,t]=initmesh(g);
u0=zeros(size(p,2),1);
ix=find(sqrt(p(1,:).^2+p(2,:).^2)<handles.R);
u0(ix)=ones(size(ix));
x=linspace(-1,1,21);y=x;
[unused,tn,a2,a3]=tri2grid(p,t,u0,x,y);
umax=max(max(handles.u1));
umin=min(min(handles.u1));
for j=1:handles.nframes,...
  u=tri2grid(p,t,handles.u1(:,j),tn,a2,a3);%i=find(isnan(u));u(i)=zeros(size(i));...
  %surf(x,y,u);caxis([umin umax]);colormap(cool),...
  %axis([-1 1 -1 1 0 1]);...
  %handles.Mv(:,j) = getframe;...
  if t(j)>tt, break, end
end
t(j), u(xx*10+1,yy*10+1)

guidata(hObject, handles);

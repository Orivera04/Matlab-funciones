function varargout = continuous_sys_generator(varargin)
% CONTINUOUS_SYS_GENERATOR provides a graphical user interface to solve noise system of ODE
% GUI-mode using:
% data=continuous_sys_generator;
% batch (no-GUI) mode using:
% data=continuous_sys_generator(Fx,ignv,iwnv,agnv,awnv,init,time,tr_time,solver,addit_param)
% solver - { 1 - ode45;
%            2 - ode23;
%            3 - ode113;
%            4 - ode15s;
%            5 - ode23s;
%            6 - ode23t; 
%            7 - ode23tb; }
% example: data=continuous_sys_generator({'0.032*x1+0.5*x2-x3' 'x1-0.1*x2-x1^3' '0.1*x1'},{'0' '0' '0'},{'0' '0' '0'},{'0' '0' '0'},{'0' '0' '0'},{'0.01' '-0.01' '-0.02'},'[0:0.02:50]','[-10 0]',1,'');
% See also ODE
% Other help in pdf-file
% author: Max Logunov, lab432@mail.ru, comments welcome
% This program is a part of Lab432 software for nonlinear analysis of time
% series (freely available by request)

% Last Modified by GUIDE v2.5 05-Jan-2005 13:36:16
% last modified 15.09.05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @continuous_sys_generator_OpeningFcn, ...
                   'gui_OutputFcn',  @continuous_sys_generator_OutputFcn, ...
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


% --- Executes just before discrete_map_generator is made visible.
function continuous_sys_generator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to discrete_map_generator (see VARARGIN)

% Choose default command line output for discrete_map_generator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
handles.auto=0;
try
	N=length(varargin{1});
	x={};
	for i=1:N
        x{i}=['dx' num2str(i) '/dt'];
	end
	set(handles.x,'string',x);
    set(handles.f,'string',varargin{1});
    set(handles.ignv,'string',varargin{2});
    set(handles.innv,'string',varargin{3});
    set(handles.agnv,'string',varargin{4});
    set(handles.annv,'string',varargin{5});
    set(handles.init,'string',varargin{6});
	set(handles.edit_length,'string',varargin{7});
    set(handles.tr_time,'string',varargin{8});
    set(handles.solver,'value',varargin{9});
    set(handles.addit_param,'string',varargin{10});
catch
end

if length(varargin)==10 % batch mode OK
    handles.auto=1;
end
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = continuous_sys_generator_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
global csgDATA

if nargout
    if handles.auto
        ok_Callback(handles.ok, [], handles);
        varargout{1} =csgDATA;
    else
        uiwait;
        varargout{1} =csgDATA;
    end
else
    warning('Require output argument then call continuous_sys_generator');
end

try
    close(handles.figure);
catch
end


% --- Executes on button press in ok.
function ok_Callback(hObject, eventdata, handles)
% hObject    handle to ok (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
global csgDATA
clear tmp_sys
csgDATA=[];

x=get(handles.x,'string');
ignv=get(handles.ignv,'string'); 
innv=get(handles.innv,'string');
init=get(handles.init,'string');
f=get(handles.f,'string');
if isempty(x)
    msgbox('No data for system');
    return
end
s = which('continuous_sys_generator');
[pathstr,name,ext,versn] = fileparts(s);

init_str='';
for i=1:length(x)
    init_str=[init_str init{i} ' '];
end
init_str=['[' init_str(1:end-1) ']'];

fid = fopen([pathstr '/tmp_sys.m'],'w');
fprintf(fid,'function Y=tmp_sys(t,X); \n');
fprintf(fid,'Y=zeros(%s,1); \n',num2str(length(x)));
for i=1:length(x)
	fprintf(fid,'%s=X(%i); \n',['x' num2str(i)],i);
end
for i=1:length(x)
	fprintf(fid,'Y(%s)=%s+randn*(%s)^0.5+rand/0.2886*(%s)^0.5; \n',num2str(i),f{i},ignv{i},innv{i});
end
fclose(fid);
clear fid
 
solvers=get(handles.solver,'string');
if ~isempty(get(handles.tr_time,'string'))
	if ~isempty(get(handles.addit_param,'string'))
        [T,Y]=eval([solvers{get(handles.solver,'value')} '(@tmp_sys,' get(handles.tr_time,'string') ',' init_str ',odeset(' get(handles.addit_param,'string') '))']);
	else
        [T,Y]=eval([solvers{get(handles.solver,'value')} '(@tmp_sys,' get(handles.tr_time,'string') ',' init_str ')']); 
	end
	clear tmp_sys;
	
	init_str='';
	for i=1:length(x)
        init_str=[init_str num2str(Y(end,i)) ' '];
	end
	init_str=['[' init_str(1:end-1) ']'];
end

if ~isempty(get(handles.addit_param,'string'))
    [T,Y]=eval([solvers{get(handles.solver,'value')} '(@tmp_sys,' get(handles.edit_length,'string') ',' init_str ',odeset(' get(handles.addit_param,'string') '))']);
else
    [T,Y]=eval([solvers{get(handles.solver,'value')} '(@tmp_sys,' get(handles.edit_length,'string') ',' init_str ')']); 
end
clear tmp_sys;


agnv=get(handles.agnv,'string');
annv=get(handles.annv,'string');
g_n=randn(size(Y));
n_n=rand(size(Y));
for i=1:length(x)
    g_n(:,i)=g_n(:,i)*str2num(agnv{i})^0.5;
    n_n(:,i)=n_n(:,i)/(var(n_n(:,i)))^.5*str2num(annv{i})^0.5;
end
Y=Y+g_n+n_n;

csgDATA=[T Y];

uiresume;


% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
close(handles.figure);


% --- Executes during object creation, after setting all properties.
function edit_length_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_length (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_length_Callback(hObject, eventdata, handles)
% hObject    handle to edit_length (see GCBO)
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.mat','Load System');
if file~=0
    try
        S=load([path file]);
        set([handles.x handles.f handles.init handles.innv handles.ignv handles.annv handles.agnv],'value',1);
        set(handles.x,'string',S.sys.dx);
        set(handles.f,'string',S.sys.f);
        set(handles.innv,'string',S.sys.innv);
        set(handles.ignv,'string',S.sys.ignv);
        set(handles.agnv,'string',S.sys.agnv);
        set(handles.annv,'string',S.sys.annv);
        set(handles.init,'string',S.sys.init);
        set(handles.edit_info,'string',S.sys.info);
        set(handles.tr_time,'string',S.sys.tr_time);
        set(handles.edit_length,'string',S.sys.time);
        set(handles.addit_param,'string',S.sys.addit_param);
        str=get(handles.solver,'string');
        for i=1:length(str)
            if strcmp(str{i},S.sys.solver)
                set(handles.solver,'value',i);
                break
            end
        end
    catch
        errordlg('Wrong file format','File error');
    end
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uiputfile('*.mat','Save System As');
if file~=0
	sys.dx=get(handles.x,'string');
	sys.f=get(handles.f,'string');
	sys.ignv=get(handles.ignv,'string');
	sys.innv=get(handles.innv,'string');
	sys.agnv=get(handles.agnv,'string');
	sys.annv=get(handles.annv,'string');
	sys.init=get(handles.init,'string');
    sys.info=get(handles.edit_info,'string');
    sys.tr_time=get(handles.tr_time,'string');
    sys.time=get(handles.edit_length,'string');
        str=get(handles.solver,'string');
    sys.solver=str{get(handles.solver,'value')};
    sys.addit_param=get(handles.addit_param,'string');
    save([path file],'sys');
end
    


% --- Executes during object creation, after setting all properties.
function edit_info_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_info (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit_info_Callback(hObject, eventdata, handles)
% hObject    handle to edit_info (see GCBO)
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function x_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in x.
function x_Callback(hObject, eventdata, handles)
% hObject    handle to x (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

set([handles.x handles.f handles.ignv handles.agnv handles.annv handles.init handles.innv],'value',get(hObject,'Value'));

% --- Executes during object creation, after setting all properties.
function f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function ignv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ignv (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function innv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to innv (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function agnv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to agnv (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function annv_CreateFcn(hObject, eventdata, handles)
% hObject    handle to annv (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to init (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in add.
function add_Callback(hObject, eventdata, handles)
% hObject    handle to add (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

N=length(get(handles.x,'string'));
x={};
for i=1:N
    x{i}=['dx' num2str(i) '/dt'];
end
set(handles.x,'string',x);
prompt = {['Enter equation dx'  num2str(N+1) '/dt=...'],...
        'Enter internal Gaussian noise variance:',...
        'Enter internal white noise variance:',...
        'Enter additive Gaussian noise variance:',...
        'Enter additve white noise variance:',...
        'Enter initial condition:'};
dlg_title = 'Add new equation';
num_lines= 1;
def     = {'','0','0','0','0','0.5'};
answer  = inputdlg(prompt,dlg_title,num_lines,def);
if ~isempty(answer)
    x=get(handles.x,'string');
    f=get(handles.f,'string');
    ignv=get(handles.ignv,'string');
    innv=get(handles.innv,'string');
    agnv=get(handles.agnv,'string');
    annv=get(handles.annv,'string');
    init=get(handles.init,'string');
    x{N+1}=['dx' num2str(N+1) '/dt'];
    f{N+1}=answer{1};
    ignv{N+1}=answer{2};
    innv{N+1}=answer{3};
    agnv{N+1}=answer{4};
    annv{N+1}=answer{5};
    init{N+1}=answer{6};
    set([handles.x, handles.f, handles.innv, handles.ignv, handles.agnv, handles.annv, handles.init],'value',N+1);
    set(handles.x,'string',x);
    set(handles.f,'string',f);
    set(handles.innv,'string',innv);
    set(handles.ignv,'string',ignv);
    set(handles.agnv,'string',agnv);
    set(handles.annv,'string',annv);
    set(handles.init,'string',init);
end


% --- Executes on button press in modify.
function modify_Callback(hObject, eventdata, handles)
% hObject    handle to modify (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

x=get(handles.x,'string');
f=get(handles.f,'string');
ignv=get(handles.ignv,'string');
innv=get(handles.innv,'string');
agnv=get(handles.agnv,'string');
annv=get(handles.annv,'string');
init=get(handles.init,'string');
selection=get(handles.x,'value');
if isempty(x)
    x{1}='dx1/dt'; f{1}=''; ignv{1}='0'; innv{1}='0'; agnv{1}='0'; annv{1}='0'; init{1}='0.7';
end

prompt = {['Enter equation '  x{selection} '=...'],...
        'Enter internal Gaussian noise variance:',...
        'Enter internal white noise variance:',...
        'Enter additive Gaussian noise variance:',...
        'Enter additve white noise variance:',...
        'Enter initial condition:'};
dlg_title = 'Modify equation';
num_lines= 1;
def     = {f{selection},ignv{selection},innv{selection},agnv{selection},annv{selection},init{selection}};
answer  = inputdlg(prompt,dlg_title,num_lines,def);
if ~isempty(answer)
    f{selection}=answer{1};
    ignv{selection}=answer{2};
    innv{selection}=answer{3};
    agnv{selection}=answer{4};
    annv{selection}=answer{5};
    init{selection}=answer{6};
    set(handles.x,'string',x);
    set(handles.f,'string',f);
    set(handles.innv,'string',innv);
    set(handles.ignv,'string',ignv);
    set(handles.agnv,'string',agnv);
    set(handles.annv,'string',annv);
    set(handles.init,'string',init);
end


% --- Executes on button press in delete.
function delete_Callback(hObject, eventdata, handles)
% hObject    handle to delete (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

x=get(handles.x,'string');
f=get(handles.f,'string');
ignv=get(handles.ignv,'string');
innv=get(handles.innv,'string');
agnv=get(handles.agnv,'string');
annv=get(handles.annv,'string');
init=get(handles.init,'string');
selection=get(handles.x,'value');
if isempty(x)
    return
end

n_f={}; n_ignv={}; n_innv={}; n_agnv={};n_annv={}; n_init={}; n_x={};
k=1;
for i=1:length(x)
    if i~=selection
        n_f{k}=f{i};
        n_ignv{k}=ignv{i};
        n_innv{k}=innv{i};
        n_agnv{k}=agnv{i};
        n_annv{k}=annv{i};
        n_init{k}=init{i};
        n_x{k}=x{i};
        k=k+1;
    end
end
set([handles.x, handles.f, handles.innv, handles.ignv, handles.agnv, handles.annv, handles.init],'value',max([1 selection-1]));
    
set(handles.x,'string',n_x);
set(handles.f,'string',n_f);
set(handles.innv,'string',n_innv);
set(handles.ignv,'string',n_ignv);
set(handles.agnv,'string',n_agnv);
set(handles.annv,'string',n_annv);
set(handles.init,'string',n_init);


% --- Executes during object creation, after setting all properties.
function solver_CreateFcn(hObject, eventdata, handles)
% hObject    handle to solver (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
set(hObject,'string',{'ode45' 'ode23' 'ode113' 'ode15s' 'ode23s' 'ode23t' 'ode23tb'});

% --- Executes on selection change in solver.
function solver_Callback(hObject, eventdata, handles)
% hObject    handle to solver (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns solver contents as cell array
%        contents{get(hObject,'Value')} returns selected item from solver


% --- Executes during object creation, after setting all properties.
function addit_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to addit_param (see GCBO)
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function addit_param_Callback(hObject, eventdata, handles)
% hObject    handle to addit_param (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of addit_param as text
%        str2double(get(hObject,'String')) returns contents of addit_param as a double


% --- Executes during object creation, after setting all properties.
function tr_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tr_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tr_time_Callback(hObject, eventdata, handles)
% hObject    handle to tr_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tr_time as text
%        str2double(get(hObject,'String')) returns contents of tr_time as a double



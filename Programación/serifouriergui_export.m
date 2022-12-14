function varargout = serifouriergui_export(varargin)
%  this program with figure of results  simply and elegant display  power
%  of seri fourier function f(t) which t is between a and  b together summation 
% N expression  of  Fourier seri  
%                                       ---------
%                                       \
%                                       /               ao+an*(cos(n*pi/l)+bn*(sin(n*pi/l)
%                                       ----------
% if you need coefficient ao  an  bn    
% figure  fullfill this   compeletly  

% last  revised   spring 2005  
%   iran    yazd    
% email :  sayedxp2004@yahoo.com


% SERIFOURIERGUI_EXPORT M-file for serifouriergui_export.fig
%      SERIFOURIERGUI_EXPORT, by itself, creates a new SERIFOURIERGUI_EXPORT or raises the existing
%      singleton*.
%
%      H = SERIFOURIERGUI_EXPORT returns the handle to a new SERIFOURIERGUI_EXPORT or the handle to
%      the existing singleton*.
%
%      SERIFOURIERGUI_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SERIFOURIERGUI_EXPORT.M with the given input arguments.
%
%      SERIFOURIERGUI_EXPORT('Property','Value',...) creates a new SERIFOURIERGUI_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before serifouriergui_export_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to serifouriergui_export_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help serifouriergui_export

% Last Modified by GUIDE v2.5 22-May-2004 02:37:10

% Begin initialization code - DO NOT EDIT
%persistent ed1 ed3 ed4  rb1 ;
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @serifouriergui_export_OpeningFcn, ...
    'gui_OutputFcn',  @serifouriergui_export_OutputFcn, ...
    'gui_LayoutFcn',  @serifouriergui_export_LayoutFcn, ...
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


% --- Executes just before serifouriergui_export is made visible.
function serifouriergui_export_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to serifouriergui_export (see VARARGIN)

% Choose default command line output for serifouriergui_export
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes serifouriergui_export wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = serifouriergui_export_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
text_initial='sin(t)';
ed3i='0';
ed4i='pi/4';
set(handles.edit1,'string',text_initial);
set(handles.edit3,'string',ed3i);
set(handles.edit4,'string',ed4i);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes on button press in radiobutton1.


function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
s1=fix(get(handles.slider1,'value'));
set(handles.text7,'string',(num2str(s1)));
% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

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
% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
home;
f=get(handles.edit1,'string');
rb1=get(handles.radiobutton1,'value');
s1=fix(get(handles.slider1,'value'));
a=str2num(get(handles.edit3,'string'));
b=str2num(get(handles.edit4,'string'));
set(handles.text7,'string',(num2str(s1)));
c=s1;
% Fourier Series for periodic Function
% serifourier ('sin(t)',0,pi/4,8)
syms  t   n x ;
l=(b-a)/2;
%set(0,'defaultUicontrolForegroundColor', 'g')
% set(0,'defaultaxescolor','r');
An=simplify(int(f*cos((n*pi/l)*t),t,a,b)/l);
Ao=int(f,t,a,b)/(2*l);
Bn=simplify(int(f*sin((n*pi/l)*t),t,a,b)/l);
F=Ao+symsum(An*cos(n*x*pi/l),n,1,c)+symsum(Bn*sin(n*x*pi/l),n,1,c);
x=a:.0001:b;
Fun=subs(F);
%warning off;
axes(handles.axes1);
plot(x,Fun,'r');
% ezplot(F,[a b]);
grid on;
hold on;
% t=a:.0001:b;
Fun=f;
ezplot(Fun,[a,b]);
legend('Expanded func ','Initial Func','location','best');
hold off;
if rb1==1
    Ao
    An
    Bn
end

    


function OUT=subschar(expre,state1,state2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% substitute first expression with second expression       %
% expre='abchjkiopledcvbn';                                              %
% state1='ab';                                                                     %
% state2='JJJJ';
% out =  JJJJchjkiopledcvbn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
out={};
collect_func=separatechar(char(expre),'+','-');
for ii=1:length(collect_func);
    expre=collect_func{ii};
    charac=' ';    c1=length(char(state1));    c2=length(char(state2)); 
    c=findstr(expre,state1);   % find string of state1
    if ~ isempty(c)
        ch1=expre(1:c-1);        ch2=expre(c1+length(ch1)+1:length(expre));
        xxx(1:c-1)=ch1;        xxx(c:c+c2-1)=char(state2);
        xxx(c+c2:length(ch2)+c+c2-1)=ch2;        out{ii}=xxx;
    else
        out{ii}=expre;
    end
end
OUT=mergechar(out{:});

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
home;
help serifouriergui ;




% --- Creates and returns a handle to the GUI figure. 
function h1 = serifouriergui_export_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'axes', 2, ...
    'frame', 4, ...
    'pushbutton', 5, ...
    'edit', 5, ...
    'text', 10, ...
    'radiobutton', 2, ...
    'slider', 2, ...
    'activex', 2), ...
    'override', 0, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'lastSavedFile', 'D:\MATLAB7\work\serifouriergui_export.m', ...
    'blocking', 0);
appdata.lastValidTag = 'f1';
appdata.GUIDELayoutEditor = [];

h1 = figure(...
'Units','characters',...
'BackingStore','off',...
'Color',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'DockControls','off',...
'DoubleBuffer','off',...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'Name','serifouriergui',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'Position',[41.4 11 188.4 50.4615384615385],...
'Renderer','OpenGL',...
'RendererMode','manual',...
'Resize','off',...
'CreateFcn', {@local_CreateFcn, 'help serifourier', appdata} ,...
'HandleVisibility','callback',...
'HitTest','off',...
'Tag','f1',...
'UserData',[],...
'Behavior',get(0,'defaultfigureBehavior'),...
'Visible','on');

appdata = [];
appdata.lastValidTag = 'axes1';

h2 = axes(...
'Parent',h1,...
'Units','characters',...
'Position',[59.8 4.15384615384623 120.2 40.5384615384615],...
'ALim',get(0,'defaultaxesALim'),...
'ALimMode','manual',...
'Box','on',...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode','manual',...
'CameraUpVector',[0 1 0],...
'CameraUpVectorMode','manual',...
'CameraViewAngle',6.60861036031192,...
'CameraViewAngleMode','manual',...
'CLim',get(0,'defaultaxesCLim'),...
'CLimMode','manual',...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'DataAspectRatio',get(0,'defaultaxesDataAspectRatio'),...
'DataAspectRatioMode','manual',...
'DrawMode','fast',...
'LooseInset',[24.492 5.55076923076923 17.898 3.78461538461538],...
'PlotBoxAspectRatio',get(0,'defaultaxesPlotBoxAspectRatio'),...
'PlotBoxAspectRatioMode','manual',...
'TickDir',get(0,'defaultaxesTickDir'),...
'TickDirMode','manual',...
'XColor',[1 0 0],...
'XLim',get(0,'defaultaxesXLim'),...
'XLimMode','manual',...
'XTick',[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1],...
'XTickLabel',{  '0  '; '0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'; '1  ' },...
'XTickLabelMode','manual',...
'XTickMode','manual',...
'YColor',[1 0 0],...
'YLim',get(0,'defaultaxesYLim'),...
'YLimMode','manual',...
'YTick',[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1],...
'YTickLabel',{  '0  '; '0.1'; '0.2'; '0.3'; '0.4'; '0.5'; '0.6'; '0.7'; '0.8'; '0.9'; '1  ' },...
'YTickLabelMode','manual',...
'YTickMode','manual',...
'ZColor',get(0,'defaultaxesZColor'),...
'ZLim',get(0,'defaultaxesZLim'),...
'ZLimMode','manual',...
'ZTick',[0 0.5 1],...
'ZTickLabel','',...
'ZTickLabelMode','manual',...
'ZTickMode','manual',...
'Tag','axes1',...
'UserData',[],...
'Behavior',get(0,'defaultaxesBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

h3 = get(h2,'title');

set(h3,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.498102466793169 1.01423149905123 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off',...
'Behavior',struct());

h4 = get(h2,'xlabel');

set(h4,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.498102466793169 -0.0445920303605316 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off',...
'Behavior',struct());

h5 = get(h2,'ylabel');

set(h5,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.0540796963946868 0.498102466793169 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off',...
'Behavior',struct());

h6 = get(h2,'zlabel');

set(h6,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-0.638519924098672 1.13946869070209 1.00005459937205],...
'HandleVisibility','off',...
'Behavior',struct(),...
'Visible','off');

appdata = [];
appdata.lastValidTag = 'frame1';

h7 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'ListboxTop',0,...
'Position',[9.8 30.8461538461539 40.2 15.6923076923077],...
'String','F(X)',...
'Style','frame',...
'Tag','frame1',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton1';

h8 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','serifouriergui_export(''pushbutton1_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',12,...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[19.8 14.0000000000001 20.2 1.76923076923077],...
'String','PLOT',...
'Tag','pushbutton1',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton2';

h9 = uicontrol(...
'Parent',h1,...
'Units','centimeters',...
'Callback','serifouriergui_export(''pushbutton2_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',12,...
'FontWeight','bold',...
'ForegroundColor',[1 0.501960784313725 0.250980392156863],...
'ListboxTop',0,...
'Position',[2.6173846875 3.43696979166669 2.67026114583333 0.660955729166667],...
'String','RESET',...
'TooltipString','RESET  DATA ',...
'Tag','pushbutton2',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton3';

h10 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','serifouriergui_export(''pushbutton3_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',15,...
'FontWeight','bold',...
'ForegroundColor',[1 0 0],...
'ListboxTop',0,...
'Position',[19.8 6.07692307692315 20.2 2],...
'String','Close',...
'Tag','pushbutton3',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit1';

h11 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','serifouriergui_export(''edit1_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',15,...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[12.6 42.6153846153847 34 2.69230769230769],...
'String','',...
'Style','edit',...
'TooltipString','Enter   Function To Calculate  FFT',...
'CreateFcn', {@local_CreateFcn, 'serifouriergui_export(''edit1_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit1',...
'Behavior',get(0,'defaultuicontrolBehavior'));

appdata = [];
appdata.lastValidTag = 'text1';

h12 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',15,...
'FontWeight','bold',...
'ForegroundColor',[0.592156862745098 0.141176470588235 0.835294117647059],...
'ListboxTop',0,...
'Position',[62 45.3076923076924 100.6 3.38461538461539],...
'String','PERIODIC FUNCTION Fourier  Transform',...
'Style','text',...
'HitTest','off',...
'Tag','text1',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'radiobutton1';

h13 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','serifouriergui_export(''radiobutton1_Callback'',gcbo,[],guidata(gcbo))',...
'CData',[],...
'FontSize',10,...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[9.8 19.5384615384616 40.6 1.38461538461538],...
'String','Display  FOURIER  COEF',...
'Style','radiobutton',...
'TooltipString','display  coef  of fourier  in  command window',...
'Tag','radiobutton1',...
'UserData',[],...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'slider1';

h14 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.9 0.9 0.9],...
'Callback','serifouriergui_export(''slider1_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Max',60,...
'Min',1,...
'Position',[9.8 25.7692307692308 40.2 1.53846153846154],...
'String',{  '' },...
'Style','slider',...
'TooltipString','N should  between 2 to 50',...
'Value',8,...
'CreateFcn', {@local_CreateFcn, 'serifouriergui_export(''slider1_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'SelectionHighlight','off',...
'Tag','slider1',...
'Behavior',get(0,'defaultuicontrolBehavior'));

appdata = [];
appdata.lastValidTag = 'text2';

h15 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',10,...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[9.8 23.3846153846155 40.2 1.53846153846154],...
'String','Number Of  Fourier  Coef ',...
'Style','text',...
'TooltipString','N should be between 1 to  50',...
'Tag','text2',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit3';

h16 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','serifouriergui_export(''edit3_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',10,...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[33 38.7692307692309 13 2.07692307692308],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'serifouriergui_export(''edit3_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit3',...
'Behavior',get(0,'defaultuicontrolBehavior'));

appdata = [];
appdata.lastValidTag = 'text3';

h17 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'FontWeight','bold',...
'ForegroundColor',[0 0.501960784313725 0.250980392156863],...
'ListboxTop',0,...
'Position',[19.8 38.7692307692309 12.6 2.07692307692308],...
'String','t Min =',...
'Style','text',...
'Tag','text3',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text4';

h18 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',14,...
'FontWeight','bold',...
'ForegroundColor',[0.501960784313725 0.250980392156863 0],...
'ListboxTop',0,...
'Position',[17.6 35.923076923077 14.2 2.15384615384615],...
'String','t Max =',...
'Style','text',...
'Tag','text4',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text5';

h19 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',10,...
'FontWeight','bold',...
'ForegroundColor',[0 0 0],...
'ListboxTop',0,...
'Position',[13.4 46.4615384615386 31 1.15384615384615],...
'String','Peridic Time  Function',...
'Style','text',...
'Tag','text5',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'edit4';

h20 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback','serifouriergui_export(''edit4_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',10,...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[32.8 35.923076923077 13.4 2.15384615384615],...
'String','',...
'Style','edit',...
'CreateFcn', {@local_CreateFcn, 'serifouriergui_export(''edit4_CreateFcn'',gcbo,[],guidata(gcbo))', appdata} ,...
'Tag','edit4',...
'Behavior',get(0,'defaultuicontrolBehavior'));

appdata = [];
appdata.lastValidTag = 'text6';

h21 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',13,...
'FontWeight','bold',...
'ForegroundColor',[1 0 0],...
'ListboxTop',0,...
'Position',[12.2 32.1538461538462 34.4 2.84615384615385],...
'String','t Min <  t  <  t Max  ',...
'Style','text',...
'Tag','text6',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text7';

h22 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',10,...
'FontWeight','bold',...
'ForegroundColor',[1 0 0],...
'ListboxTop',0,...
'Position',[19.8 28.2307692307693 20.2 1.15384615384615],...
'String','',...
'Style','text',...
'Value',[8 8],...
'Tag','text7',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'pushbutton4';

h23 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'Callback','serifouriergui_export(''pushbutton4_Callback'',gcbo,[],guidata(gcbo))',...
'FontSize',12,...
'FontWeight','bold',...
'ForegroundColor',[0 0.501960784313725 1],...
'Position',[19.8 1.76923076923084 20.2 2.46153846153846],...
'String','HELP',...
'Tag','pushbutton4',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );

appdata = [];
appdata.lastValidTag = 'text9';

h24 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'FontSize',12,...
'FontWeight','bold',...
'Position',[79.8 1.30769230769238 70.2 1.53846153846154],...
'String','Time ',...
'Style','text',...
'Tag','text9',...
'Behavior',get(0,'defaultuicontrolBehavior'),...
'CreateFcn', {@local_CreateFcn, '', appdata} );


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   eval(createfcn);
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      SERIFOURIERGUI_EXPORT, by itself, creates a new SERIFOURIERGUI_EXPORT or raises the existing
%      singleton*.
%
%      H = SERIFOURIERGUI_EXPORT returns the handle to a new SERIFOURIERGUI_EXPORT or the handle to
%      the existing singleton*.
%
%      SERIFOURIERGUI_EXPORT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SERIFOURIERGUI_EXPORT.M with the given input arguments.
%
%      SERIFOURIERGUI_EXPORT('Property','Value',...) creates a new SERIFOURIERGUI_EXPORT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2004 The MathWorks, Inc.
%   $Revision: 1.4.6.8 $ $Date: 2004/04/15 00:06:57 $

gui_StateFields =  {'gui_Name'
                    'gui_Singleton'
                    'gui_OpeningFcn'
                    'gui_OutputFcn'
                    'gui_LayoutFcn'
                    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);        
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % SERIFOURIERGUI_EXPORT
    % create the GUI
    gui_Create = 1;
elseif isequal(ishandle(varargin{1}), 1) && ispc && iscom(varargin{1}) && isequal(varargin{1},gcbo)
    % SERIFOURIERGUI_EXPORT(ACTIVEX,...)    
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif ischar(varargin{1}) && numargin>1 && isequal(ishandle(varargin{2}), 1)
    % SERIFOURIERGUI_EXPORT('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % SERIFOURIERGUI_EXPORT(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = 1;
end

if gui_Create == 0
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    
    % Do feval on layout code in m-file if it exists
    if ~isempty(gui_State.gui_LayoutFcn)
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen')
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        end
    end
    
    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    
    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig 
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA
        guidata(gui_hFigure, guihandles(gui_hFigure));
    end
    
    % If user specified 'Visible','off' in p/v pairs, don't make the figure
    % visible.
    gui_MakeVisible = 1;
    for ind=1:2:length(varargin)
        if length(varargin) == ind
            break;
        end
        len1 = min(length('visible'),length(varargin{ind}));
        len2 = min(length('off'),length(varargin{ind+1}));
        if ischar(varargin{ind}) && ischar(varargin{ind+1}) && ...
                strncmpi(varargin{ind},'visible',len1) && len2 > 1
            if strncmpi(varargin{ind+1},'off',len2)
                gui_MakeVisible = 0;
            elseif strncmpi(varargin{ind+1},'on',len2)
                gui_MakeVisible = 1;
            end
        end
    end
    
    % Check for figure param value pairs
    for index=1:2:length(varargin)
        if length(varargin) == index
            break;
        end
        try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end
    
    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});
    
    if ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
        
        % Make figure visible
        if gui_MakeVisible
            set(gui_hFigure, 'Visible', 'on')
            if gui_Options.singleton 
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        rmappdata(gui_hFigure,'InGUIInitialization');
    end
    
    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if ishandle(gui_hFigure)
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end
    
    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end
    
    if ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end    

function gui_hFigure = local_openfig(name, singleton)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
try 
    gui_hFigure = openfig(name, singleton, 'auto');
catch
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end


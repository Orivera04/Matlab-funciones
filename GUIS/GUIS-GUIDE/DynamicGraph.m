function varargout = DynamicGraph(varargin)
%DYNAMICGRAPH M-file for DynamicGraph.fig
%
%     H = DYNAMICGRAPH returns the handle to a new DYNAMICGRAPH or the
%     handle to
%     the existing singleton*.
%
%     DYNAMICGRAPH('CALLBACK',hObject,eventData,handles,...) calls the
%     local
%     function named CALLBACK in DYNAMICGRAPH.M with the given input
%     arguments.
%
%Note: plot requires only one variable
%      plot3 requires only one but can use all three and can plot with x as
%      a vector or matrix; surf requires the same as plot3 but must be a matrix
%      mesh requires the same as surf
%
%When plotting surface plots note that this program will have trouble if
%hold on is specified, to fix click graph with hold off, then hold on will
%work for dynamic plotting.
%
%Adjustable axes is on by default to manually specify axes lengths use
%"Axes Properties" button and the radio button will automatically turn off.
%To make adjustable again simply click on the radiobutton and the gui will
%forget the axes settings
%
%To find additional help click on the syntax/help button, feel free to add
%any additional plots. Any questions/comments email: pdw35@student.canterbury.ac.nz

%Author: Paul de Wit
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DynamicGraph_OpeningFcn, ...
    'gui_OutputFcn',  @DynamicGraph_OutputFcn, ...
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


% --- Executes just before DynamicGraph is made visible.
function DynamicGraph_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(handles.text6,'string',sprintf('50%s','%'))

guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = DynamicGraph_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;

% --- Executes on slider movement.
function SpeedSlider(hObject, eventdata, handles)

handles.speed = get(hObject,'Value');
set(handles.text6,'string',sprintf('%1.0f%s',handles.speed*50,'%'))
guidata(hObject,handles)

% --- Executes on button press in clear axes
function ClearAxes(hObject, eventdata, handles)
PlotOption = get(handles.PlotOption,'string');
PlotOption = PlotOption{get(handles.PlotOption,'value')};
switch PlotOption
    case 'Axes 1'
        try cla(handles.plot1,'reset'),catch cla(handles.axes1,'reset'),end
    case 'Axes 2'
        cla(handles.plot2,'reset')
    case 'Axes 3'
        cla(handles.plot3,'reset')
    case 'Axes 4'
        cla(handles.plot4,'reset')
end
return

% --- Executes on button press in pushbutton1.
function graph(hObject, eventdata, handles)

SaveAllFields(hObject,handles)
AdjustableAxes = get(handles.AdjustAxes,'value');if AdjustableAxes==1,handles.axesproperties={};end
PlotOption = get(handles.PlotOption,'string');
PlotOption = PlotOption{get(handles.PlotOption,'value')};
try AxesProperties = str2num(char(handles.axesproperties));end
state = get(handles.Plottype,'string');
state = state{get(handles.Plottype,'value')};
set(handles.AValue,'visible','off')
checked = get(handles.HOLDON,'value');
Grid = get(handles.GRIDON,'value');
handles.Inputfunction = get(handles.Inputfunction,'string');
try x = eval(get(handles.XVariable,'string'));catch x='';end
try y = eval(get(handles.YVariable,'string'));catch y='';end
try z = eval(get(handles.ZVariable,'string'));catch z='';end
switch PlotOption
    case 'Axes 1'
        try subplot(handles.plot1),catch subplot(handles.axes1),end
    case 'Axes 2'
        subplot(handles.plot2)
    case 'Axes 3'
        subplot(handles.plot3)
    case 'Axes 4'
        subplot(handles.plot4)
end
if checked==1,hold on,else hold off,end
flag=0; %check flag
a=1; %set default of a=1 incase user inputs the dynamic variable
switch state
    case 'plot'
        try plot(x,eval(handles.Inputfunction));catch flag=1;end
        if flag==1,try plot(y,eval(handles.Inputfunction)),catch flag=2;end,end
        if flag==2,try plot(z,eval(handles.Inputfunction)),catch ...
                    errordlg('you have not entered enough fields or syntax problem','error','modal'),...
                    return,end,end
    case 'plot3'
        fcn = handles.Inputfunction;
        characters = double(fcn);
        first = find(fcn==91);
        second = find(fcn==93);
        for i=first(1):second(1)
            placeholder(1,i) = characters(1,i);
        end
        for i=first(2):second(2)
            placeholder2(1,i-(first(2)-1)) = characters(1,i);
        end
        for i=first(3):second(3)
            placeholder3(1,i-(first(3)-1)) = characters(1,i);
        end
        fcn = char(placeholder);
        fcn2 = char(placeholder2);
        fcn3 = char(placeholder3);
        plot3(eval(fcn),eval(fcn2),eval(fcn3))
    case 'surf'
        surf(eval(handles.Inputfunction))
    case 'mesh'
        mesh(eval(handles.Inputfunction))
    case 'bar'
        bar(eval(handles.Inputfunction))
    case 'contour'
        contour(eval(handles.Inputfunction))
    case 'surfc'
        surfc(eval(handles.Inputfunction))
    case 'polar'
        try polar(x,eval(handles.Inputfunction));catch flag=1;end
        if flag==1,try polar(y,eval(handles.Inputfunction)),catch flag=2;end,end
        if flag==2,try polar(z,eval(handles.Inputfunction)),catch ...
                    errordlg('you have not entered enough fields or syntax problem','error','modal'),...
                    return,end,end
    case 'comet'
        try comet(x,eval(handles.Inputfunction));catch flag=1;end
        if flag==1,try comet(y,eval(handles.Inputfunction)),catch flag=2;end,end
        if flag==2,try comet(z,eval(handles.Inputfunction)),catch ...
                    errordlg('you have not entered enough fields or syntax problem','error','modal'),...
                    return,end,end
    case 'comet3'
        comet3(eval(handles.Inputfunction))
    otherwise
        error('Error in program')
        return
end
try set(gca,'XLim',[AxesProperties(1) AxesProperties(2)]),set(gca,'YLim',[AxesProperties(3) AxesProperties(4)]),...
        set(gca,'ZLim',[AxesProperties(5) AxesProperties(6)]),end
xlabel('x-axes'),ylabel('y-axes'),zlabel('z-axes'),title(sprintf('%s',state))
if Grid==1,grid on,else grid off,end
checked=0;

% --- Executes on button press in pushbutton4.
function DynamicPlot(hObject, eventdata, handles)

SaveAllFields(hObject,handles)
PlotOption = get(handles.PlotOption,'string');
PlotOption = PlotOption{get(handles.PlotOption,'value')};
AdjustableAxes = get(handles.AdjustAxes,'value');if AdjustableAxes==1,handles.axesproperties={};end
try AxesProperties = str2num(char(handles.axesproperties));end
set(handles.AValue,'visible','on')
checked = get(handles.HOLDON,'value');
Grid = get(handles.GRIDON,'value');
Inputfunction = get(handles.Inputfunction,'string');
state = get(handles.Plottype,'string');
state = state{get(handles.Plottype,'value')};
switch PlotOption
    case 'Axes 1'
        try subplot(handles.plot1),catch subplot(handles.axes1),end
    case 'Axes 2'
        subplot(handles.plot2)
    case 'Axes 3'
        subplot(handles.plot3)
    case 'Axes 4'
        subplot(handles.plot4)
end
flag=0;  %checker flag
try x = eval(get(handles.XVariable,'string'));flag=1;catch x='';end
try y = eval(get(handles.YVariable,'string'));flag=2;catch y='';end
try z = eval(get(handles.ZVariable,'string'));flag=3;catch z='';end
AStart = str2double(get(handles.AStart,'string'));
AEnd = str2double(get(handles.AEnd,'string'));
if checked==1,hold on,else hold off,end
a=AStart:AEnd; %The range of the dynamic variable a
switch state
    case 'plot'
        for i=1:length(a)
            speed = get(handles.speedslider,'value');
            a=AStart:AEnd; a=a(i);
            set(handles.AValue,'string',sprintf('a=%1.0f',a))
            if flag==1,plot(x,eval(Inputfunction)),elseif flag==2,plot(y,eval(Inputfunction)),...
            elseif flag==3,plot(z,eval(Inputfunction)),end
        try set(gca,'XLim',[AxesProperties(1) AxesProperties(2)]),set(gca,'YLim',[AxesProperties(3) AxesProperties(4)]),...
                set(gca,'ZLim',[AxesProperties(5) AxesProperties(6)]),end
        pause(2-speed)
        end
    case 'plot3'
        characters = double(Inputfunction);
        first = find(fcn==91);
        second = find(fcn==93);
        for i=first(1):second(1)
            placeholder(1,i) = characters(1,i);
        end
        for i=first(2):second(2)
            placeholder2(1,i-(first(2)-1)) = characters(1,i);
        end
        for i=first(3):second(3)
            placeholder3(1,i-(first(3)-1)) = characters(1,i);
        end
        fcn = char(placeholder);
        fcn2 = char(placeholder2);
        fcn3 = char(placeholder3);
        for i=1:length(a)
            speed = get(handles.speedslider,'value');
            a=AStart:AEnd;
            a=a(i);
            set(handles.AValue,'string',sprintf('a=%1.0f',a))
            plot3(eval(fcn),eval(fcn2),eval(fcn3));
            try set(gca,'XLim',[AxesProperties(1) AxesProperties(2)]),set(gca,'YLim',[AxesProperties(3) AxesProperties(4)]),...
                    set(gca,'ZLim',[AxesProperties(5) AxesProperties(6)]),end
            pause(2-speed)
        end
    case 'surf'
        for i=1:length(a)
            speed = get(handles.speedslider,'value');
            a=AStart:AEnd;
            a=a(i);
            set(handles.AValue,'string',sprintf('a=%1.0f',a))
            surf(eval(Inputfunction));
            try set(gca,'XLim',[AxesProperties(1) AxesProperties(2)]),set(gca,'YLim',[AxesProperties(3) AxesProperties(4)]),...
                    set(gca,'ZLim',[AxesProperties(5) AxesProperties(6)]),end
            pause(2-speed)
        end
    case 'mesh'
        for i=1:length(a)
            speed = get(handles.speedslider,'value');
            a=AStart:AEnd;
            a=a(i);
            set(handles.AValue,'string',sprintf('a=%1.0f',a))
            mesh(eval(Inputfunction));
            try set(gca,'XLim',[AxesProperties(1) AxesProperties(2)]),set(gca,'YLim',[AxesProperties(3) AxesProperties(4)]),...
                    set(gca,'ZLim',[AxesProperties(5) AxesProperties(6)]),end
            pause(2-speed)
        end
    case 'contour'
        for i=1:length(a)
            speed = get(handles.speedslider,'value');
            a=AStart:AEnd;
            a=a(i);
            set(handles.AValue,'string',sprintf('a=%1.0f',a))
            contour(eval(Inputfunction));
            try set(gca,'XLim',[AxesProperties(1) AxesProperties(2)]),set(gca,'YLim',[AxesProperties(3) AxesProperties(4)]),...
                    set(gca,'ZLim',[AxesProperties(5) AxesProperties(6)]),end
            pause(2-speed)
        end
    case 'surfc'
        for i=1:length(a)
            speed = get(handles.speedslider,'value');
            a=AStart:AEnd;
            a=a(i);
            set(handles.AValue,'string',sprintf('a=%1.0f',a))
            surfc(eval(Inputfunction));
            try set(gca,'XLim',[AxesProperties(1) AxesProperties(2)]),set(gca,'YLim',[AxesProperties(3) AxesProperties(4)]),...
                    set(gca,'ZLim',[AxesProperties(5) AxesProperties(6)]),end
            pause(2-speed)
        end
    case 'polar'
        for i=1:length(a)
            speed = get(handles.speedslider,'value');
            a=AStart:AEnd; a=a(i);
            set(handles.AValue,'string',sprintf('a=%1.0f',a))
            polar(x,eval(Inputfunction));
            try set(gca,'XLim',[AxesProperties(1) AxesProperties(2)]),set(gca,'YLim',[AxesProperties(3) AxesProperties(4)]),...
                    set(gca,'ZLim',[AxesProperties(5) AxesProperties(6)]),end
            pause(2-speed)
        end
    case 'bar'
        for i=1:length(a)
            speed = get(handles.speedslider,'value');
            a=AStart:AEnd;
            a=a(i);
            set(handles.AValue,'string',sprintf('a=%1.0f',a))
            bar(eval(Inputfunction));
            try set(gca,'XLim',[AxesProperties(1) AxesProperties(2)]),set(gca,'YLim',[AxesProperties(3) AxesProperties(4)]),...
                    set(gca,'ZLim',[AxesProperties(5) AxesProperties(6)]),end
            pause(2-speed)
        end
    otherwise
        errordlg('no dynamic graph for this case')
end
xlabel('x-axes'),ylabel('y-axes'),zlabel('z-axes'),title(sprintf('%s',state))
if Grid==1,grid on,else grid off,end

% --- Executes on button press in AxesProperties.
function AxesProperties_Callback(hObject, eventdata, handles)

set(handles.AdjustAxes,'value',0)
PlotOption = get(handles.PlotOption,'string');
PlotOption = PlotOption{get(handles.PlotOption,'value')};
switch PlotOption
    case 'Axes 1'
        try XLim=get(handles.axes1,'XLim');YLim=get(handles.axes1,'YLim');ZLim=get(handles.axes1,'ZLim');
        catch XLim=get(handles.plot1,'XLim');YLim=get(handles.plot1,'YLim');ZLim=get(handles.plot1,'ZLim');end
    case 'Axes 2'
        try XLim=get(handles.plot2,'XLim');catch errordlg('reference to non-existent "Axes 2"'),return,end
        try YLim=get(handles.plot2,'YLim');catch errordlg('reference to non-existent "Axes 2"'),return,end
        try ZLim=get(handles.plot2,'ZLim');catch errordlg('reference to non-existent "Axes 2"'),return,end
    case 'Axes 3'
        try XLim=get(handles.plot3,'XLim');catch errordlg('reference to non-existent "Axes 3"'),return,end
        try YLim=get(handles.plot3,'YLim');catch errordlg('reference to non-existent "Axes 3"'),return,end
        try ZLim=get(handles.plot3,'ZLim');catch errordlg('reference to non-existent "Axes 3"'),return,end
    case 'Axes 4'
        try XLim=get(handles.plot4,'XLim');catch errordlg('reference to non-existent "Axes 4"'),return,end
        try YLim=get(handles.plot4,'YLim');catch errordlg('reference to non-existent "Axes 4"'),return,end
        try ZLim=get(handles.plot4,'ZLim');catch errordlg('reference to non-existent "Axes 4"'),return,end
end
prompt={'Enter the XMin:','Enter the XMax:','Enter the YMin:','Enter the YMax:',...
    'Enter the ZMin:','Enter the ZMax:'};
name='Axes Properties';
numlines=1;
answer={sprintf('%1.0f',XLim(1)),sprintf('%1.0f',XLim(2)),sprintf('%1.0f',YLim(1)),sprintf('%1.0f',YLim(2)),...
    sprintf('%1.0f',ZLim(1)),sprintf('%1.0f',ZLim(2))};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=inputdlg(prompt,name,numlines,answer,options);
if isempty(answer)==1,return,end
AxesConstant(hObject,handles,answer,PlotOption)

function AxesConstant(hObject,handles,answer,PlotOption)


switch PlotOption
    case 'Axes 1'
        try
            set(handles.axes1,'XLim',[str2num(char(answer(1))) str2num(char(answer(2)))])
            set(handles.axes1,'YLim',[str2num(char(answer(3))) str2num(char(answer(4)))])
            set(handles.axes1,'ZLim',[str2num(char(answer(5))) str2num(char(answer(6)))])
        catch
            try
                set(handles.plot1,'XLim',[str2num(char(answer(1))) str2num(char(answer(2)))])
                set(handles.plot1,'YLim',[str2num(char(answer(3))) str2num(char(answer(4)))])
                set(handles.plot1,'ZLim',[str2num(char(answer(5))) str2num(char(answer(6)))])
            catch
                errordlg('Bad values for min/max make sure values are increasing')
                return,
            end
        end
    case 'Axes 2'
        try
            set(handles.plot2,'XLim',[str2num(char(answer(1))) str2num(char(answer(2)))])
            set(handles.plot2,'YLim',[str2num(char(answer(3))) str2num(char(answer(4)))])
            set(handles.plot2,'ZLim',[str2num(char(answer(5))) str2num(char(answer(6)))])
        catch
            errordlg('Bad values for min/max make sure values are increasing')
            return,
        end
    case 'Axes 3'
        try
            set(handles.plot3,'XLim',[str2num(char(answer(1))) str2num(char(answer(2)))])
            set(handles.plot3,'YLim',[str2num(char(answer(3))) str2num(char(answer(4)))])
            set(handles.plot3,'ZLim',[str2num(char(answer(5))) str2num(char(answer(6)))])
        catch
            errordlg('Bad values for min/max make sure values are increasing')
            return,
        end
    case 'Axes 4'
        try
            set(handles.plot4,'XLim',[str2num(char(answer(1))) str2num(char(answer(2)))])
            set(handles.plot4,'YLim',[str2num(char(answer(3))) str2num(char(answer(4)))])
            set(handles.plot4,'ZLim',[str2num(char(answer(5))) str2num(char(answer(6)))])
        catch
            errordlg('Bad values for min/max make sure values are increasing')
            return,
        end
end
handles.axesproperties=answer;
guidata(hObject,handles)


function SaveAllFields(hObject,handles)

PlotOption = get(handles.PlotOption,'string');
PlotOption = PlotOption{get(handles.PlotOption,'value')};
switch PlotOption
    case 'Axes 1'
        handles.S1Inputfunction = get(handles.Inputfunction,'string');
        handles.S1AStart = get(handles.AStart,'string');
        handles.S1AEnd = get(handles.AEnd,'string');
        handles.S1XVariable = get(handles.XVariable,'string');
        handles.S1YVariable = get(handles.YVariable,'string');
        handles.S1ZVariable = get(handles.ZVariable,'string');
        handles.S1State = get(handles.Plottype,'value');
    case 'Axes 2'
        handles.S2Inputfunction = get(handles.Inputfunction,'string');
        try handles.S2AStart = get(handles.AStart,'string');catch handles.S2Astart = '';end
        try handles.S2AEnd = get(handles.AEnd,'string');catch handles.S2AEnd = '';end
        try handles.S2XVariable = get(handles.XVariable,'string');catch handles.S2XVariable = '';end
        try handles.S2YVariable = get(handles.YVariable,'string');catch handles.S2YVariable = '';end
        try handles.S2ZVariable = get(handles.ZVariable,'string');catch handles.S2ZVariable = '';end
        handles.S2State = get(handles.Plottype,'value');
    case 'Axes 3'
        handles.S3Inputfunction = get(handles.Inputfunction,'string');
        try handles.S3AStart = get(handles.AStart,'string');catch handles.S3Astart = '';end
        try handles.S3AEnd = get(handles.AEnd,'string');catch handles.S3AEnd = '';end
        try handles.S3XVariable = get(handles.XVariable,'string');catch handles.S3XVariable = '';end
        try handles.S3YVariable = get(handles.YVariable,'string');catch handles.S3YVariable = '';end
        try handles.S3ZVariable = get(handles.ZVariable,'string');catch handles.S3ZVariable = '';end
        handles.S3State = get(handles.Plottype,'value');
    case 'Axes 4'
        handles.S4Inputfunction = get(handles.Inputfunction,'string');
        try handles.S4AStart = get(handles.AStart,'string');catch handles.S4Astart = '';end
        try handles.S4AEnd = get(handles.AEnd,'string');catch handles.S4AEnd = '';end
        try handles.S4XVariable = get(handles.XVariable,'string');catch handles.S4XVariable = '';end
        try handles.S4YVariable = get(handles.YVariable,'string');catch handles.S4YVariable = '';end
        try handles.S4ZVariable = get(handles.ZVariable,'string');catch handles.S4ZVariable = '';end
        handles.S4State = get(handles.Plottype,'value');
end
guidata(hObject,handles)

% --- Executes on selection change in PlotOption.
function PlotOption_Callback(hObject, eventdata, handles)

PlotOption = get(handles.PlotOption,'string');
PlotOption = PlotOption{get(handles.PlotOption,'value')};
switch PlotOption
    case 'Axes 1'
        try set(handles.Inputfunction,'string',handles.S1Inputfunction),end
        try set(handles.AStart,'string',handles.S1AStart),end
        try set(handles.AEnd,'string',handles.S1AEnd),end
        try set(handles.XVariable,'string',handles.S1XVariable),end
        try set(handles.YVariable,'string',handles.S1YVariable),end
        try set(handles.ZVariable,'string',handles.S1ZVariable),end
        try set(handles.Plottype,'value',handles.S1State),end
    case 'Axes 2'
        try set(handles.Inputfunction,'string',handles.S2Inputfunction),end
        try set(handles.AStart,'string',handles.S2AStart),end
        try set(handles.AEnd,'string',handles.S2AEnd),end
        try set(handles.XVariable,'string',handles.S2XVariable),end
        try set(handles.YVariable,'string',handles.S2YVariable),end
        try set(handles.ZVariable,'string',handles.S2ZVariable),end
        try set(handles.Plottype,'value',handles.S2State),end
    case 'Axes 3'
        try set(handles.Inputfunction,'string',handles.S3Inputfunction),end
        try set(handles.AStart,'string',handles.S3AStart),end
        try set(handles.AEnd,'string',handles.S3AEnd),end
        try set(handles.XVariable,'string',handles.S3XVariable),end
        try set(handles.YVariable,'string',handles.S3YVariable),end
        try set(handles.ZVariable,'string',handles.S3ZVariable),end
        try set(handles.Plottype,'value',handles.S3State),end
    case 'Axes 4'
        try set(handles.Inputfunction,'string',handles.S4Inputfunction),end
        try set(handles.AStart,'string',handles.S4AStart),end
        try set(handles.AEnd,'string',handles.S4AEnd),end
        try set(handles.XVariable,'string',handles.S4XVariable),end
        try set(handles.YVariable,'string',handles.S4YVariable),end
        try set(handles.ZVariable,'string',handles.S4ZVariable),end
        try set(handles.Plottype,'value',handles.S4State),end
end

function fcn_string(hObject, eventdata, handles)
cont = get(handles.fcnstring,'string');
if length(cont)~=1,cont = cont{get(handles.fcnstring,'value')};end
set(handles.Inputfunction,'string',cont)

function save_fcn(hObject, eventdata, handles)

string = get(handles.togbutton,'string');
fcnstringv = get(handles.fcnstring,'value');
fcnstrings = get(handles.fcnstring,'string');
b=get(handles.Inputfunction,'string');
cont=struct('structure',fcnstrings);
try
    if isempty(cont.structure)==1
        set(handles.fcnstring,'string',b)
        return
    end
end
if length(cont)==1
    s = struct('strings',{{cont.structure,b}});
else
    s = struct('strings',{{b}});
    s.strings = [fcnstrings' s.strings];
end
set(handles.fcnstring,'string',s.strings)

function ChangeAxes_Callback(hObject, eventdata, handles)

NoOfAxes = get(handles.NoOfAxes,'string');
PickAxes = NoOfAxes{get(handles.NoOfAxes,'Value')};

switch PickAxes
    case '1 Axes'
        handles.plot1=subplot(2,2,1,'position',[.105 .457 .568 .465]);
    case '2 Axes'
        handles.plot1=subplot(2,2,1,'position',[.079 .53 .27 .31]);
        handles.plot2=subplot(2,2,2,'position',[.4 .53 .27 .31]);
    case '3 Axes'
        handles.plot1=subplot(2,2,1,'position',[.099 .69 .22 .23]);
        handles.plot2=subplot(2,2,2,'position',[.42 .69 .22 .23]);
        handles.plot3=subplot(2,2,3,'position',[.255 .4 .22 .23]);
    case '4 Axes'
        handles.plot1=subplot(2,2,1,'position',[.095 .71 .2 .21]);
        handles.plot2=subplot(2,2,2,'position',[.41 .71 .2 .21]);
        handles.plot3=subplot(2,2,3,'position',[.095 .41 .2 .21]);
        handles.plot4=subplot(2,2,4,'position',[.41 .41 .2 .21]);
end
guidata(hObject,handles)

% --- Executes on button press in pushbutton5.
function SyntaxHelp(hObject, eventdata, handles)

Syntax = {'The correct syntax for:               '...
    'plot  -    function1                        '...
    'plot3 -  [function1],[function2],[function3]'...
    'surf  -   [function1,function2,function3]    '...
    'mesh - [function1,function2,function3]    '...
    'surfc -   [function1,function2,function3]    '...
    'bar  -    function1                        '...
    'contour - [function1,function2,function3]    '...
    'comet  -    function1                        '...
    'comet3  -  [function1,function2,function3] '...
    '                                            '...
    '                                            '...
    'The dynamic variable is "a"                 '...
    '                                             '...
    'An example of plot3 is [a*sin(x)],[cos(x)],[x]'...
    'with the x-variable set to 0:pi/50:10*pi     '...
    'click on the dynamic button and the value for'...
    '"a" will vary you can increase/decrease the  '...
    'speed with the slider                        '...
    'this should produce a helix                  '...
    '                                             '...
    'Another example is the peaks function        '...
    'just type peaks in the function field and    '...
    'give x-variable a matrix rand(4,4) choose the'...
    'surf option then click plot                  '...
    'to find help on other plot options use matlabs'...
    'help                                         '...
    '                                             '...
    'feel free to change or add more plots to the '...
    'program                                      '...
    '                                             '...
    'Author: Paul de Wit                          '...
    };

helpdlg(Syntax)


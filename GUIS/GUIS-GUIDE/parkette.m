function varargout = parkette(varargin)
% parkette.m erzeugt eine grafische Benutzeroberflaeche,
% die regulaere Parkette zeichnet.
% Autor: Teresa Krohn
% Letzte Aenderung: 2003-03-03
% 
% Aufruf: parkette
% Nun kann man aus den 93 Parketten, sortiert nach Laves-
% Netz, ein beliebiges aufrufen und zeichnen lassen.
% Es erscheint eine kurze Beschreibung des Parketts, ein
% einzelner Parkettstein und ein Ausschnitt aus dem
% gesamten Parkett.
%
% Weitere Informationen zu Parketten unter:
% http://www.mathematik.uni-stuttgart.de/mathA/lst7/teaching/download/ps_ws_02/regulaere_parkette.pdf

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @parkette_OpeningFcn, ...
                   'gui_OutputFcn',  @parkette_OutputFcn, ...
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


% --- Executes just before parkette is made visible.
function parkette_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to parkette (see VARARGIN)

% Choose default command line output for parkette
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(gcf,'Color',[1 1 1]);
axes(handles.axes1);
axis off;
axes(handles.axes2);
axis off;

%h_fig=handles.gcf;
%h = uicontrol(handles.figure1,'CallBack',[6.5 18.333 20.167 13.417],'String','Status Window','Style','text','Units','normalized');

% UIWAIT makes parkette wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = parkette_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function datei_Callback(hObject, eventdata, handles)
% hObject    handle to datei (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function drucken_Callback(hObject, eventdata, handles)
% hObject    handle to drucken (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)


% --------------------------------------------------------------------
function beenden_Callback(hObject, eventdata, handles)
% hObject    handle to beenden (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)

% --------------------------------------------------------------------
function info_Callback(hObject, eventdata, handles)
% hObject    handle to info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function info2_Callback(hObject, eventdata, handles)
% hObject    handle to info2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = msgbox(['Weitere Informationen unter: http://www.mathematik.uni-stuttgart.de/mathA/lst7/teaching/download/ps_ws_02/regulaere_parkette.pdf'],'Information');


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 01', 'RP 02', 'RP 03', 'RP 04', 'RP 05', 'RP 06', 'RP 07', 'RP 08', 'RP 09', 'RP 10', 'RP 11', 'RP 12', 'RP 13', 'RP 14', 'RP 15', 'RP 16', 'RP 17', 'RP 18', 'RP 19', 'RP 20' });


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
popup_sel_index = get(handles.popupmenu2, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 01; Laves-Netz: 333333; Symmetriegruppe: p6mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
set(gcf,'Color',[1 1 1]);
x1=0;
y1=0;
x2=1;
y2=0;
x3=1 + sqrt(1-(0.75*0.75));
y3=0.75;
x4=1;
y4=1.5;
x5=0;
y5=1.5;
x6= - sqrt(1-(0.75*0.75));
y6=0.75;
for k = -5:1:5
for m = -5:1:5
cx=[k*(x5-x1) + m*(x3-x1)];
cy=[k*(y5-y1) + m*(y3-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal;
axis([0.25 8.25 0.25 8.25]);
axis off;
hold off
axes(handles.axes2);
cla;
set(gcf,'Color',[1 1 1]);
x_1=[x1 x2 x3 x4 x5 x6 x1];
y_1=[y1 y2 y3 y4 y5 y6 y1];
fill(x_1,y_1,'w');
axis equal;
axis off;
hold off
case 2
set(handles.text21,'string','RP 02; Laves-Netz: 333333; Symmetriegruppe p3m1. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=1 + sqrt(1-(0.75*0.75));
y3=0.75;
x4=1;
y4=1.5;
x5=0;
y5=1.5;
x6= - sqrt(1-(0.75*0.75));
y6=0.75;
for k = -5:1:5
for m = -5:1:5
cx=[k*(x5-x1) + m*(x3-x1)];
cy=[k*(y5-y1) + m*(y3-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy];
fill(x_1,y_1,'w');
hold on
plot(x1+cx,y1+cy,'k.');
hold on
end
end
axis equal;
axis([0.25 8.25 0.25 8.25]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x1];
y_1=[y1 y2 y3 y4 y5 y6 y1];
fill(x_1,y_1,'w');
hold on
plot(x1,y1,'k.');
hold on
plot(x3,y3,'k.');
hold on
plot(x5,y5,'k.');
hold on

axis equal;
axis off;
hold off
case 3
set(handles.text21,'string','RP 03; Laves-Netz: 333333; Symmetriegruppe: p31m');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.5;
y2=0.2;
x3=1;
y3=0;
x12=x2*cos(2*pi/3)-y2*sin(2*pi/3);
y12=x2*sin(2*pi/3)+y2*cos(2*pi/3);
x4=x3-x12;
y4=y12;
x5=1+cos(pi/3);
y5=sin(pi/3);
x6=x5+x12;
y6=y5+y12;
x7=1;
y7=2*sin(pi/3);
x8=0.5;
y8=y7+0.2;
x9=0;
y9=y7;
x11=-cos(pi/3);
y11=sin(pi/3);
x10=x11+x4-x3;
y10=y11+y4;
for k = 0:1:4
for m = 0:1:5
cx=[k*(x9-x1) + m*(x5-x1)];
cy=[k*(y9-y1) + m*(y5-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([1 5 4 8]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 4
set(handles.text21,'string','RP 04; Laves-Netz: 333333; Symmetriegruppe: p31m; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.5;
y2=0.2;
x3=1;
y3=0;
x12=x2*cos(2*pi/3)-y2*sin(2*pi/3);
y12=x2*sin(2*pi/3)+y2*cos(2*pi/3);
x4=x3-x12;
y4=y12;
x5=1+cos(pi/3);
y5=sin(pi/3);
x6=x5+x12;
y6=y5+y12;
x7=1;
y7=2*sin(pi/3);
x8=0.5;
y8=y7+0.2;
x9=0;
y9=y7;
x11=-cos(pi/3);
y11=sin(pi/3);
x10=x11+x4-x3;
y10=y11+y4;
x14=x2;
y14=y5;
for k = 0:1:4
for m = 0:1:5
cx=[k*(x9-x1) + m*(x5-x1)];
cy=[k*(y9-y1) + m*(y5-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x12+cx x14+cx x8+cx x14+cx x4+cx];
y_2=[y12+cy y14+cy y8+cy y14+cy y4+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis equal;
axis([1 5 4 8]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x14 x12 x1];
y_1=[y1 y2 y3 y4 y14 y12 y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 5
set(handles.text21,'string','RP 05; Laves-Netz: 333333; Symmetriegruppe: p6');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.3;
y2=0.1;
x2a=0.7;
y2a=-0.1;
x3=1;
y3=0;
x12=x2a*cos(2*pi/3)-y2a*sin(2*pi/3);
y12=x2a*sin(2*pi/3)+y2a*cos(2*pi/3);
x12a=x2*cos(2*pi/3)-y2*sin(2*pi/3);
y12a=x2*sin(2*pi/3)+y2*cos(2*pi/3);
x5=1+cos(pi/3);
y5=sin(pi/3);
x4=x2*cos(pi/3)-y2*sin(pi/3)+x3;
y4=x2*sin(pi/3)+y2*cos(pi/3);
x4a=x2a*cos(pi/3)-y2a*sin(pi/3)+x3;
y4a=x2a*sin(pi/3)+y2a*cos(pi/3);
x6=x2*cos(2*pi/3)-y2*sin(2*pi/3)+x5;
y6=x2*sin(2*pi/3)+y2*cos(2*pi/3)+y5;
x6a=x2a*cos(2*pi/3)-y2a*sin(2*pi/3)+x5;
y6a=x2a*sin(2*pi/3)+y2a*cos(2*pi/3)+y5;
x7=1;
y7=2*sin(pi/3);
x8=x2a;
y8=y7+y2a;
x8a=x2;
y8a=y7+y2;
x9=0;
y9=y7;
x11=-cos(pi/3);
y11=sin(pi/3);
x10=x2a*cos(pi/3)-y2a*sin(pi/3)+x11;
y10=x2a*sin(pi/3)+y2a*cos(pi/3)+y11;
x10a=x2*cos(pi/3)-y2*sin(pi/3)+x11;
y10a=x2*sin(pi/3)+y2*cos(pi/3)+y11;
for k = 0:1:5
for m = 0:1:5
cx=[k*(x9-x1) + m*(x5-x1)];
cy=[k*(y9-y1) + m*(y5-y1)];
x_1=[x1+cx x2+cx x2a+cx x3+cx x4+cx x4a+cx x5+cx x6+cx x6a+cx x7+cx x8+cx x8a+cx x9+cx x10+cx x10a+cx x11+cx x12+cx x12a+cx x1+cx];
y_1=[y1+cy y2+cy y2a+cy y3+cy y4+cy y4a+cy y5+cy y6+cy y6a+cy y7+cy y8+cy y8a+cy y9+cy y10+cy y10a+cy y11+cy y12+cy y12a+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([0 6 4 10]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x2a x3 x4 x4a x5 x6 x6a x7 x8 x8a x9 x10 x10a x11 x12 x12a x1];
y_1=[y1 y2 y2a y3 y4 y4a y5 y6 y6a y7 y8 y8a y9 y10 y10a y11 y12 y12a y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 6
set(handles.text21,'string','RP 06; Laves-Netz: 333333; Symmetriegruppe: p3');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.3;
y2=0.2;
x3=1;
y3=0;
x12=x2*cos(2*pi/3)-y2*sin(2*pi/3);
y12=x2*sin(2*pi/3)+y2*cos(2*pi/3);
x5=1+cos(pi/3);
y5=sin(pi/3);
x4=cos(-2*pi/3)*x2-sin(-2*pi/3)*y2+x5;
y4=sin(-2*pi/3)*x2+cos(-2*pi/3)*y2+y5;
x6=x5+x12;
y6=y5+y12;
x7=1;
y7=2*sin(pi/3);
x8=x2;
y8=y7+y2;
x9=0;
y9=y7;
x11=-cos(pi/3);
y11=sin(pi/3);
x10=x11+x4-x3;
y10=y11+y4;
for k = 0:1:4
for m = 0:1:4
cx=[k*(x9-x1) + m*(x5-x1)];
cy=[k*(y9-y1) + m*(y5-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([1 5 4 8]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 7
set(handles.text21,'string','RP 07; Laves-Netz: 333333; Symmetriegruppe: p3; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.7;
y2=0;
x3=1;
y3=0;
x12=x2*cos(2*pi/3)-y2*sin(2*pi/3);
y12=x2*sin(2*pi/3)+y2*cos(2*pi/3);
x5=1+cos(pi/3);
y5=sin(pi/3);
x6=x5+x12;
y6=y5+y12;
x7=1;
y7=2*sin(pi/3);
x9=0;
y9=y7;
x11=-cos(pi/3);
y11=sin(pi/3);
x10=x11+x6-x3;
y10=y11+y7-y6;
x4=0.5;
y4=sin(pi/3);
for k = 0:1:4 
for m = 0:1:5 
cx=[k*(x9-x1) + m*(x5-x1)];
cy=[k*(y9-y1) + m*(y5-y1)];
x_1=[x1+cx x3+cx x5+cx x7+cx x9+cx x11+cx cx];
y_1=[y1+cy y3+cy y5+cy y7+cy y9+cy y11+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x2+cx x4+cx x10+cx];
y_2=[y2+cy y4+cy y10+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x4+cx x6+cx];
y_3=[y4+cy y6+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([1 5 4 8]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x4 x10 x11 x1];
y_1=[y1 y2 y4 y10 y11 y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 8
set(handles.text21,'string','RP 08; Laves-Netz: 333333; Symmetriegruppe: c2mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=3.95;
y2=0;
x3=5.85;
y3=3; 
x4=14.15;
y4=y3;
x5=16.05;
y5=0;
x6=20;
y6=0;
x7=20;
y7=16.5;
x8=x5;
y8=y7;
x9=x4;
y9=13.5;
x10=x3;
y10=y9;
x11=x2;
y11=16.5;
x12=0;
y12=y11;
x13=10;
y13=30;
x14=x13;
y14=y9;
for k = 0:1:5
for m = 0:1:2
cx = [k*(x6-x1)+m*((x12-x1)+(x9-x4))];
cy = [k*(y6-y1)+m*((y12-y1)+(y9-y4))];
pf1_x = [x1+cx;x2+cx;x3+cx;x4+cx;x5+cx;x6+cx;x7+cx;x8+cx;x9+cx;x14+cx;x13+cx;x14+cx;x10+cx;x11+cx;x12+cx];
pf1_y = [y1+cy;y2+cy;y3+cy;y4+cy;y5+cy;y6+cy;y7+cy;y8+cy;y9+cy;y14+cy;y13+cy;y14+cy;y10+cy;y11+cy;y12+cy];
fill(pf1_x,pf1_y,'w');
hold on
end
hold on
end
axis([15 75 10 75]);
axis equal;
axis off; 
hold off
axes(handles.axes2);
cla;
pf1_x=[x1;x2;x3;x4;x5;x6;x7;x8;x9;x10;x11;x12];
pf1_y=[y1;y2;y3;y4;y5;y6;y7;y8;y9;y10;y11;y12];
fill(pf1_x,pf1_y,'w');
axis equal;
axis([-0.25 20.25 -0.25 16.75]);
axis off;
hold off
case 9
set(handles.text21,'string','RP 09; Laves-Netz: 333333; Symmetriegruppe: p2mg; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=1;
x4=0;
y4=1;
for m = 0:1:4
 for k = 0:2:8
  cx=[m*(x2-x1)+k*(x4-x1)];
  cy=[m*(y2-y1)+k*(y4-y1)];
  x_a1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
  y_a1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
  x_a2=[1.5+x1+cx 1.5+x2+cx 1.5+x3+cx 1.5+x4+cx 1.5+x1+cx];
  y_a2=[1+y1+cy 1+y2+cy 1+y3+cy 1+y4+cy 1+y1+cy];
  fill(x_a1,y_a1,'w');
  hold on
  fill(x_a2,y_a2,'w');
  hold on
 end
end
axis([0.25 7.25 0.25 7.25]);
axis('off');
hold off
axes(handles.axes2);
cla;
x_a1=[x1 x2 x3 x4 x1];
y_a1=[y1 y2 y3 y4 y1];
fill(x_a1,y_a1,'w');
axis equal;
axis([-1 3 -1 2]);
axis off;
hold off
case 10
set(handles.text21,'string','RP 10; Laves-Netz: 333333; Symmetriegruppe: p2mg; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2.75;
y3=0.5;
x4=2.25;
y4=0.5;
x5=3;
y5=1;
x6=x4;
y6=1.5;
x7=x3;
y7=1.5;
x8=x2;
y8=2;
x9=x1;
y9=y8;
x10=x1;
y10=1.5;
x11=-0.5;
y11=1.5;
x12=-0.5;
y12=0.5;
x13=0;
y13=0.5;
x14=x1;
y14=-0.5;
x15=-0.5;
y15=-0.5;
x16=-0.5;
y16=-1;
x17=-2.5;
y17=-1;
x18=-3.25;
y18=-0.5;
x19=-2.75;
y19=-0.5;
x20=-3.5;
y20=0;
x21=x19;
y21=-y19;
x22=x18;
y22=-y18;
x23=x17;
y23=-y17;
x24=x15;
y24=1;
for k = 0:1:4
for m = 0:1:1
cx=[k*(x9-x1) + m*(x20-x2)];
cy=[k*(y9-y1) + m*(y20-y2)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x13+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y13+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x24+cx x23+cx x22+cx x21+cx x20+cx x19+cx x18+cx x17+cx x16+cx x15+cx x14+cx x1+cx];
y_1=[y24+cy y23+cy y22+cy y21+cy y20+cy y19+cy y18+cy y17+cy y16+cy y15+cy y14+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([-7.5 0.5 0.5 8]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y1];
plot(x_1,y_1,'k');
axis equal;
axis([-1 3.5 -0.5 2.5]);
axis off;
hold off
case 11
set(handles.text21,'string','RP 11; Laves-Netz: 333333; Symmetriegruppe: p2gg');
axes(handles.axes1);
cla;
x1=-2*cos(pi/9);
y1=-2*sin(pi/9);
x2=0;
y2=0;
x3=-0.2;
y3=1;
x4=0;
y4=2;
x5=x1;
y5=y1+2;
x6=x1-x3;
y6=y1+y3;

x7=x3-x5;
y7=y5-y3;
x8=x3-x6;
y8=y6-y3;
x9=x3-x1;
y9=y1-y3;
x10=x3;
y10=-y3;
for k = -2:1:3
for m = 0:1:3
cx=[k*(x10-x3) + m*(x8-x1)];
cy=[k*(y10-y3) + m*(y8-y1)];
x_1=[x2+cx x1+cx x6+cx x5+cx x4+cx x3+cx x2+cx x10+cx x9+cx x8+cx x7+cx x3+cx];
y_1=[y2+cy y1+cy y6+cy y5+cy y4+cy y3+cy y2+cy y10+cy y9+cy y8+cy y7+cy y3+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([0 8 -3 5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x2 x1 x6 x5 x4 x3 x2];
y_1=[y2 y1 y6 y5 y4 y3 y2];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 12
set(handles.text21,'string','RP 12; Laves-Netz: 333333; Symmetriegruppe: p2gg; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=3*cos(pi/6);
y2=1.5;
x3=4;
y3=2.5;
x4=3*cos(pi/6);
y4=y2+2;
x5=0;
y5=2;
x6=-1.5;
y6=1.5;
x7=2*cos(pi/3);
y7=0.2;
x8=x7;
y8=y7+2;
x9=3;
y9=1.4;
x10=x3-(x9-x2);
y10=(y9-y2)+y3;
phi1=atan(1/3);
x11=cos(phi1)*(sqrt(2.5)/3)+sin(phi1)*0.1+x6;
y11=sin(phi1)*(sqrt(2.5)/3)-cos(phi1)*0.1+y6;
x12=cos(phi1)*(2*sqrt(2.5)/3)-sin(phi1)*0.1+x6;
y12=sin(phi1)*(2*sqrt(2.5)/3)+cos(phi1)*0.1+y6;
phi2=atan(1)+pi/2;
x13=cos(phi2)*(sqrt(4.5)-0.3)-sin(phi2)*0.2;
y13=sin(phi2)*(sqrt(4.5)-0.3)+cos(phi2)*0.2;
x14=cos(phi2)*0.3+sin(phi2)*0.2;
y14=sin(phi2)*0.3-cos(phi2)*0.2;
for k = 1:1:7
for m = 1:1:7
cx=[k*(x5-x1) + m*(x1-x1)];
cy=[k*(y5-y1) + m*(y1-y1)];
x_1=[x5+cx x11+cx x12+cx x6+cx x13+cx x14+cx x1+cx x7+cx x2+cx x9+cx x3+cx x10+cx x4+cx];
y_1=[y5+cy y11+cy y12+cy y6+cy y13+cy y14+cy y1+cy y7+cy y2+cy y9+cy y3+cy y10+cy y4+cy];
plot(x_1,y_1,'k');
hold on
x_2=[-x5+x2+x3+cx -x11+x2+x3+cx -x12+x2+x3+cx -x6+x2+x3+cx -x13+x2+x3+cx -x14+x2+x3+cx -x1+x2+x3+cx -x7+x2+x3+cx -x2+x2+x3+cx];
y_2=[y5+y3-y2+cy y11+y3-y2+cy y12+y3-y2+cy y6+y3-y2+cy y13+y3-y2+cy y14+y3-y2+cy y1+y3-y2+cy y7+y3-y2+cy y2+y3-y2+cy];
plot(x_2,y_2,'k');
hold on
x_3=[-x1+x6+cx -x7+x6+cx -x2+x6+cx -x9+x6+cx -x3+x6+cx];
y_3=[-y1+y6+cy -y7+y6+cy -y2+y6+cy -y9+y6+cy -y3+y6+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([-4 8 3.5 15]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x5 x11 x12 x6 x13 x14 x1 x7 x2 x9 x3 x10 x4 x8 x5];
y_1=[y5 y11 y12 y6 y13 y14 y1 y7 y2 y9 y3 y10 y4 y8 y5];
plot(x_1,y_1,'k');
hold on
axis equal;
axis([-2 4.25 -0.25 3.75]);
axis off;
hold off
case 13
set(handles.text21,'string','RP 13; Laves-Netz: 333333; Symmetriegruppe: p2gg; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.2;
y2=0;
x3=1.5;
y3=0;
x4=1;
y4=0.5;
x5=0.7;
y5=0.5;
x6=0.5;
y6=0.5;
x7=2;
y7=0;
x8=2.5;
y8=0.5;
x9=1.2;
y9=0.5;
x10=x9+0.5;
y10=1;
x11=x5-0.5;
y11=1;
for k = 0:1:6
for m = -1:1:2
cx=[k*(x9-x1) + m*(x7-x1)];
cy=[k*(y9-y1) + m*(y7-y1)];
x_1=[x1+cx x3+cx x4+cx x6+cx x1+cx];
y_1=[y1+cy y3+cy y4+cy y6+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x3+cx x7+cx x8+cx x4+cx];
y_2=[y3+cy y7+cy y8+cy y4+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x4+cx x9+cx x10+cx x11+cx x5+cx];
y_3=[y4+cy y9+cy y10+cy y11+cy y5+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([3 6 0 3]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x3 x4 x6 x1];
y_1=[y1 y3 y4 y6 y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 14
set(handles.text21,'string','RP 14; Laves-Netz: 333333; Symmetriegruppe: cm');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0.4;
x3=2;
y3=0;
x4=2;
y4=0.6;
x5=2.5;
y5=0.75;
x6=2.5;
y6=1.35;
x7=2;
y7=1.5;
x8=1;
y8=1.9;
x9=0;
y9=1.5;
x10=-0.5;
y10=1.35;
x11=-0.5;
y11=0.75;
x12=0;
y12=0.6;
for k = 0:1:4
for m = 0:1:6
cx=[k*(x5-x1) + m*(x9-x1)];
cy=[k*(y5-y1) + m*(y9-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([1 8 3 10]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 15
set(handles.text21,'string','RP 15; Laves-Netz: 333333; Symmetriegruppe: cm');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=x2;
y3=0.5;
x4=2.5;
y4=0.5;
x5=3;
y5=1;
x6=x4;
y6=1.5;
x7=x2;
y7=1.5;
x8=x2;
y8=2;
x9=x1;
y9=y8;
x10=-0.5;
y10=1.5;
x11=-1;
y11=1.5;
x12=-1;
y12=0.5;
x13=-0.5;
y13=0.5;
x14=x13;
y14=-0.5;
x15=x12;
y15=-0.5;
x16=x12;
y16=-1;
x17=-3;
y17=-1;
x18=-3.5;
y18=-0.5;
x19=-4;
y19=y18;
x20=x19;
y20=y13;
x21=x18;
y21=-y18;
x22=x17;
y22=-y17;
x23=x12;
y23=-y16;
for k = 0:1:4
for m = 0:1:2
cx=[k*(x9-x1) + m*(x21-x14)];
cy=[k*(y9-y1) + m*(y21-y14)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x13+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y13+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x23+cx x22+cx x21+cx x20+cx x19+cx x18+cx x17+cx x16+cx x15+cx x14+cx x1+cx];
y_1=[y23+cy y22+cy y21+cy y20+cy y19+cy y18+cy y17+cy y16+cy y15+cy y14+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([-7 1.5 1.5 10]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y1];
plot(x_1,y_1,'k');
axis equal;
axis([-1.5 3.5 -1 3]);
axis off;
hold off
case 16
set(handles.text21,'string','RP 16; Laves-Netz: 333333; Symmetriegruppe: pg; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=-1;
y1=-0.25;
x2=x1;
y2=0.75;
x3=0;
y3=1;
x4=0;
y4=0;
x5=0;
y5=-0.75;
x6=1;
y6=-1;
x7=x6;
y7=0;
x8=0;
y8=0.25;
x9=x7;
y9=y7+0.25;
for k = 0:1:2
for m = 0:1:5
cx=[k*(x9-x1) + m*(x8-x5)];
cy=[k*(y9-y1) + m*(y8-y5)];
x_1=[x4+cx x1+cx x2+cx x3+cx x5+cx x6+cx x7+cx x8+cx];
y_1=[y4+cy y1+cy y2+cy y3+cy y5+cy y6+cy y7+cy y8+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([-0.5 4.25 1 6]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 17
set(handles.text21,'string','RP 17; Laves-Netz: 333333; Symmetriegruppe: pg; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=-2;
y1=0.2;
x2=0;
y2=0;
x3=0.5;
y3=0.75;
x4=0;
y4=1.5;
x5=-2;
y5=2;
x6=-3;
y6=1.25;
x7=-0.3;
y7=0;
x8=-0.5;
y8=0.3;
x9=0.5;
y9=0.4;
x10=0;
y10=1.1;
x11=x8;
y11=y8+y4;
x12=x7;
y12=y7+y4;
x13=-1.9;
y13=1.7;
x14=-3.1;
y14=0.95;
x15=x9-x8;
y15=y9+y8;
x16=x9-x7;
y16=y9+y7;
x17=x9-x1;
y17=y9+y1;
for k = -2:1:4
for m = -1:1:1
cx=[k*(x4-x2) + m*(x17-x6)];
cy=[k*(y4-y2) + m*(y17-y6)];
x_1=[x5+cx x13+cx x6+cx x14+cx x1+cx x7+cx x8+cx x2+cx x9+cx x3+cx x10+cx x4+cx];
y_1=[y5+cy y13+cy y6+cy y14+cy y1+cy y7+cy y8+cy y2+cy y9+cy y3+cy y10+cy y4+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x9+cx x15+cx x16+cx x17+cx];
y_2=[y9+cy y15+cy y16+cy y17+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis([-5 4 1 5]);
axis equal;
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x7 x8 x2 x9 x3 x10 x4 x11 x12 x5 x13 x6 x14 x1];
y_1=[y1 y7 y8 y2 y9 y3 y10 y4 y11 y12 y5 y13 y6 y14 y1];
plot(x_1,y_1,'k');
axis equal;
axis([-3.5 1 -0.5 2.5]);
axis off;
hold off
case 18
set(handles.text21,'string','RP 18; Laves-Netz: 333333; Symmetriegruppe: p2; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=1;
x4=0;
y4=1;
for m = -5:1:4
 for k = -5:1:8
  cx=[m*(1.5-x1)+k*(-0.5-x1)];
  cy=[m*(1-y1)+k*(1-y1)];
  x_a1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
  y_a1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
  fill(x_a1,y_a1,'w');
  hold on
 end
end
axis equal;
axis([0.25 7.25 0.25 7.25]);
axis off;
hold off
axes(handles.axes2);
cla;
x_a1=[x1 x2 x3 x4 x1];
y_a1=[y1 y2 y3 y4 y1];
fill(x_a1,y_a1,'w');
axis equal;
axis([-1 3 -1 2]);
axis off;
hold off
case 19
set(handles.text21,'string','RP 19; Laves-Netz: 333333; Symmetriegruppe: p2; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1.7;
y2=0.1;
x3=2;
y3=0.3;
x4=2.5;
y4=0.9;
x5=2.5;
y5=0.7;
x6=3;
y6=1.3;
x7=2.75;
y7=1.1;
x8=2.25;
y8=1.4;
x9=2;
y9=1.3;
x10=x2;
y10=y2+1;
x11=0;
y11=1;
x12=-0.5;
y12=1.2;
x13=-0.5;
y13=0.8;
x14=-1;
y14=1;
x15=-1;
y15=0.6;
x16=0;
y16=0.4;
x17=x6+0.3;
y17=y6+0.2;
x18=5;
y18=1.6;
for k = 0:1:1
for m = -1:1:7
cx=[k*(x18-x14) + m*(x9-x3)];
cy=[k*(y18-y14) + m*(y9-y3)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x13+cx x14+cx x15+cx x16+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y13+cy y14+cy y15+cy y16+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x6+cx x17+cx x18+cx];
y_2=[y6+cy y17+cy y18+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis equal;
axis([1 9 1 8]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 20
set(handles.text21,'string','RP 20; Laves-Netz: 333333; Symmetriegruppe: p1; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
t = (0:1/1000:1)'*2*pi;
x = 2*sin(t);
y = 0.3*abs(cos(t));
phi=3*pi/7;
x1=2;
y1=0;
x2=cos(phi)*0.4+x1;
y2=sin(phi)*0.4;
x3=cos(phi)*0.8-sin(phi)*0.2+x1;
y3=sin(phi)*0.8+cos(phi)*0.2;
x4=cos(phi)*1.2+sin(phi)*0.1+x1;
y4=sin(phi)*1.2-cos(phi)*0.1;
x5=cos(phi)*1.5-sin(phi)*0+x1;
y5=sin(phi)*1.5+cos(phi)*0;
x6=1.5;
y6=y5+0.3;
x7=0.8;
y7=y5+1.4;
x8=-2;
y8=0;
for k = 0:1:4
for m = 0:1:5
cx=[k*(x5-x8) + m*(x7-x1)];
cy=[k*(y5-y8) + m*(y7-y1)];
plot(x+cx,y+cy,'k')
hold on
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x5+cx x6+cx x7+cx];
y_2=[y5+cy y6+cy y7+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis([0 15 5 14]);
axis equal;
axis off;
hold off
axes(handles.axes2);
cla;
plot(x-0.1,y,'k')
hold on
plot(x-1.2,y+y7,'k');
hold on
x_2=[x5 x6 x7];
y_2=[y5 y6 y7];
plot(x_2,y_2,'k');
hold on
x6=x6-4.3;
y6=y8+0.4;
x7=x7-4.3;
y7=y8+1.5;
x_2=[x8-0.1 x6 x7];
y_2=[y8 y6 y7];
plot(x_2,y_2,'k');
hold on
x_1=[x1 x2 x3 x4 x5];
y_1=[y1 y2 y3 y4 y5];
plot(x_1,y_1,'k');
hold on
dx=-5.5;
dy=1.5;
x1=x1+dx;
y1=y1+dy;
x2=x2+dx;
y2=y2+dy;
x3=x3+dx;
y3=y3+dy;
x4=x4+dx;
y4=y4+dy;
x5=x5+dx;
y5=y5+dy;
x_1=[x1 x2 x3 x4 x5];
y_1=[y1 y2 y3 y4 y5];
plot(x_1,y_1,'k');
hold on
axis([-4 3 -1 4]);
axis off;
axis equal;
hold off
end % end switch!!

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 21' });

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
popup_sel_index = get(handles.popupmenu3, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 21; Laves-Netz: 63333; Symmetriegruppe: p6; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2*cos(pi/6);
y2=1;
x3=4;
y3=2;
x4=2;
y4=2+2*tan(pi/6);
x5=0;
y5=2;
x6=1.5;
y6=0.7;
x7=2.4;
y7=1.5;
x8=3.5;
y8=1.4;
x10=1;
y10=2.3;
x9=abs(cos(2*pi/3)*x10-sin(2*pi/3)*y10)+0.3;
y9=abs(sin(2*pi/3)*x10+cos(2*pi/3)*y10)+y3+0.1;
x11=cos(pi/3)*x6-sin(pi/3)*y6;
y11=sin(pi/3)*x6+cos(pi/3)*y6;
x12=cos(2*pi/3)*x4-sin(2*pi/3)*y4;
y12=sin(2*pi/3)*x4+cos(2*pi/3)*y4;
x13=cos(-2*pi/3)*x4-sin(-2*pi/3)*y4;
y13=sin(-2*pi/3)*x4+cos(-2*pi/3)*y4;
for k = 0:1:3
for m = 0:1:3
cx=[k*(x4-x12) + m*(x4-x13)];
cy=[k*(y4-y12) + m*(y4-y13)];
for n = 0:1:5
phi=n*pi/3;
ax1=cos(phi)*x1-sin(phi)*y1;
ay1=sin(phi)*x1+cos(phi)*y1;
ax11=cos(phi)*x11-sin(phi)*y11;
ay11=sin(phi)*x11+cos(phi)*y11;
ax5=cos(phi)*x5-sin(phi)*y5;
ay5=sin(phi)*x5+cos(phi)*y5;
ax10=cos(phi)*x10-sin(phi)*y10;
ay10=sin(phi)*x10+cos(phi)*y10;
ax4=cos(phi)*x4-sin(phi)*y4;
ay4=sin(phi)*x4+cos(phi)*y4;
x_1=[ax1+cx ax11+cx ax5+cx ax10+cx ax4+cx];
y_1=[ay1+cy ay11+cy ay5+cy ay10+cy ay4+cy];
plot(x_1,y_1,'k');
hold on
end
for n = 0:2:4
phi=n*pi/3;
ax2=cos(phi)*x2-sin(phi)*y2;
ay2=sin(phi)*x2+cos(phi)*y2;
ax7=cos(phi)*x7-sin(phi)*y7;
ay7=sin(phi)*x7+cos(phi)*y7;
ax8=cos(phi)*x8-sin(phi)*y8;
ay8=sin(phi)*x8+cos(phi)*y8;
ax3=cos(phi)*x3-sin(phi)*y3;
ay3=sin(phi)*x3+cos(phi)*y3;
x_1=[ax2+cx ax7+cx ax8+cx ax3+cx];
y_1=[ay2+cy ay7+cy ay8+cy ay3+cy];
plot(x_1,y_1,'k');
hold on
end
end
end
axis equal;
axis([0 10 2 12]);
axis off;
hold off
axes(handles.axes2);
cla;
x9=x9+0.3;
y9=y9+0.6;
x_1=[x1 x6 x2 x7 x8 x3 x9 x4 x10 x5 x11 x1];
y_1=[y1 y6 y2 y7 y8 y3 y9 y4 y10 y5 y11 y1];
plot(x_1,y_1,'k');
axis equal;
axis([-0.5 4.5 -0.5 3.5]);
axis off;
hold off
end % switch

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 22', 'RP 23', 'RP 24', 'RP 25', 'RP 26' });

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
popup_sel_index = get(handles.popupmenu4, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 22; Laves-Netz: 44333; Symmetriegruppe: c2mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=1;
x4=0;
y4=1;
x5=0;
y5=2;
x6=2;
y6=2;
x7=0.5;
y7=2;
for m = -2:1:4
 for k = -2:2:4
  cx=[m*(x2-x1)+k*(x5-x1)];
  cy=[m*(y2-y1)+k*(y5-y1)];  
  x_a1=[x1+cx x2+cx x3+cx x4+cx x3+cx x6+cx x5+cx x1+cx];
  y_a1=[y1+cy y2+cy y3+cy y4+cy y3+cy y6+cy y5+cy y1+cy];
  fill(x_a1,y_a1,'w');
  hold on
  x_a2=[x1+cx+1 x2+cx+1 x3+cx+1 x4+cx+1 x3+cx+1 x6+cx+1 x5+cx+1 x1+cx+1];
  y_a2=[y1+cy+2 y2+cy+2 y3+cy+2 y4+cy+2 y3+cy+2 y6+cy+2 y5+cy+2 y1+cy+2];
  fill(x_a2,y_a2,'w');
  hold on
 end
end
axis([0.25 7.25 0.25 7.25]);
axis equal;
axis('off');
hold off
axes(handles.axes2);
cla;
x_a=[x1 x2 x3 x4 x1];
y_a=[y1 y2 y3 y4 y1];
fill(x_a,y_a,'w');
axis equal;
axis([-1 3 -1 2]);
axis off;
hold off
case 2
set(handles.text21,'string','RP 23; Laves-Netz: 44333; Symmetriegruppe: p2mg; einfaches Parkett, Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=-1;
y1=-0.25;
x2=x1;
y2=0.75;
x3=0;
y3=1;
x4=0;
y4=0;
x5=1;
y5=-0.25;
x6=x5;
y6=0.75;
x7=x5;
y7=0.5;
x8=2;
y8=0.25;
x9=x8;
y9=y8-1;
x10=x5;
y10=y7-1;
x11=-x7;
y11=y7;
x12=-x8;
y12=y8;
x13=-x9;
y13=y9;
x14=-x10;
y14=y10;
for k = 0:1:6
for m = 0:1:1
cx=[k*(x3-x4) + m*(x12-x8)];
cy=[k*(y3-y4) + m*(y12-y8)];
x_1=[x3+cx x4+cx x1+cx x2+cx x3+cx x6+cx x5+cx x4+cx];
y_1=[y3+cy y4+cy y1+cy y2+cy y3+cy y6+cy y5+cy y4+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x7+cx x8+cx x9+cx x10+cx x5+cx];
y_2=[y7+cy y8+cy y9+cy y10+cy y5+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x11+cx x12+cx x13+cx x14+cx x1+cx];
y_3=[y11+cy y12+cy y13+cy y14+cy y1+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([-5.5 0.5 0 6]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 3
set(handles.text21,'string','RP 24; Laves-Netz: 44333; Symmetriegruppe: p2gg; einfaches Parkett');
axes(handles.axes1);
cla;
x1=-0.5;
y1=-0.25;
x2=-0.5;
y2=0.75;
x3=0;
y3=1;
x4=0;
y4=0;
x5=0;
y5=-0.5;
x6=0.5;
y6=-0.75;
x7=0.5;
y7=0.25;
x8=0;
y8=0.5;
x9=2*x7;
y9=0;
x10=x9;
y10=y9-y3;
x11=-x9;
y11=-0.5;
x12=x11;
y12=y8;
x13=x9;
y13=-0.25;
for k = 0:1:4
for m = 0:1:2
cx=[k*(x3-x4) + m*(x13-x11)];
cy=[k*(y3-y4) + m*(y13-y11)];
x_1=[x4+cx x1+cx x2+cx x3+cx x5+cx x6+cx x7+cx x8+cx];
y_1=[y4+cy y1+cy y2+cy y3+cy y5+cy y6+cy y7+cy y8+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x6+cx x10+cx x9+cx x7+cx];
y_2=[y6+cy y10+cy y9+cy y7+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x1+cx x11+cx x12+cx x3+cx];
y_3=[y1+cy y11+cy y12+cy y3+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([-0.25 3.75 0 4]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x4 x3 x2 x1];
y_1=[y1 y4 y3 y2 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 4
set(handles.text21,'string','RP 25; Laves-Netz: 44333; Symmetriegruppe: cm; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=2;
y1=-0.2;
x2=1.7;
y2=-0.3;
x3=1.5;
y3=0;
x4=0.4;
y4=-0.2;
x5=0;
y5=0;
x6=-x4;
y6=y4;
x7=-x3;
y7=y3;
x8=-x2;
y8=y2;
x9=-x1;
y9=y1;
x10=0;
y10=1.5;
phi=pi/4;
x11=cos(phi)*0.3+x1;
y11=sin(phi)*0.3+y1;
x12=cos(phi)*0.5-sin(phi)*0.2+x1;
y12=sin(phi)*0.5+cos(phi)*0.2+y1;
x13=cos(phi)*0.6+x1;
y13=sin(phi)*0.6+y1;
x14=3;
y14=y10/2+y1;
x15=2*2.5-x11+0.05;
y15=y11+y14+0.1;
x16=2*2.5-x12;
y16=y12+y14+0.1;
x17=2*2.5-x13;
y17=y13+y14+0.1;
x18=x1;
y18=y10+y1;
for k = -1:1:5
for m = -1:1:2
cx=[k*(x10-x5) + m*(x9-x14)];
cy=[k*(y10-y5) + m*(y9-y14)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x10+cx x5+cx];
y_2=[y10+cy y5+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x1+cx x11+cx x12+cx x13+cx x14+cx];
y_3=[y1+cy y11+cy y12+cy y13+cy y14+cy];
plot(x_3,y_3,'k');
hold on
x_4=[x14+cx x15+cx x16+cx x17+cx x18+cx];
y_4=[y14+cy y15+cy y16+cy y17+cy y18+cy];
plot(x_4,y_4,'k');
hold on
end
end
axis([-7 6 -1 8]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5];
y_1=[y1 y2 y3 y4 y5];
plot(x_1,y_1,'k');
hold on
x_5=[x1 x2 x3 x4 x5];
y_5=[y1+y10 y2+y10 y3+y10 y4+y10 y5+y10];
plot(x_5,y_5,'k');
hold on
x_2=[x10 x5];
y_2=[y10 y5];
plot(x_2,y_2,'k');
hold on
x_3=[x1 x11 x12 x13 x14];
y_3=[y1 y11 y12 y13 y14];
plot(x_3,y_3,'k');
hold on
x_4=[x14 x15 x16 x17 x18];
y_4=[y14 y15 y16 y17 y18];
plot(x_4,y_4,'k');
axis([-0.5 3.5 -1 2]);
axis off;
hold off
case 5
set(handles.text21,'string','RP 26; Laves-Netz: 44333; Symmetriegruppe: p2; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=2;
y1=0;
x2=1.8;
y2=0;
x3=1.7;
y3=0.1;
x4=1.5;
y4=0;
x5=1;
y5=0;
x6=0.5;
y6=0;
x7=0.3;
y7=-0.1;
x8=0.2;
y8=0;
x9=0;
y9=0;
phi=2*pi/5;
x10=cos(phi)*0.7+sin(phi)*0.2+x5;
y10=sin(phi)*0.7-cos(phi)*0.2;
x11=cos(phi)*0.3-sin(phi)*0.2+x5;
y11=sin(phi)*0.3+cos(phi)*0.2;
x12=cos(phi)+x5;
y12=sin(phi);
phi1=4*pi/5;
x16=cos(phi1)*0.1+sin(phi1)*0.1;
y16=sin(phi1)*0.1-cos(phi1)*0.1;
x17=cos(phi1)*0.2-sin(phi1)*0.1;
y17=sin(phi1)*0.2+cos(phi1)*0.1;
x18=cos(phi1)*0.3;
y18=sin(phi1)*0.3;
phi2=0.952;
x13=cos(phi2)*0.2+sin(phi2)*0.1+x18;
y13=sin(phi2)*0.2-cos(phi2)*0.1+y18;
x14=cos(phi2)*0.75-sin(phi2)*0.1+x18;
y14=sin(phi2)*0.75+cos(phi2)*0.1+y18;
x15=cos(phi2)*0.95+x18;
y15=sin(phi2)*0.95+y18;
x19=0;
y19=0;
for k = 0:1:3
for m = 0:1:5
cx=[k*(x18-x1) + m*(x12-x5)];
cy=[k*(y18-y1) + m*(y12-y5)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x5+cx x10+cx x11+cx x12+cx];
y_2=[y5+cy y10+cy y11+cy y12+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x18+cx x13+cx x14+cx x15+cx];
y_3=[y18+cy y13+cy y14+cy y15+cy];
plot(x_3,y_3,'k');
hold on
x_4=[x9+cx x16+cx x17+cx x18+cx];
y_4=[y9+cy y16+cy y17+cy y18+cy];
plot(x_4,y_4,'k');
hold on
end
end
axis equal;
axis([-4 1 1 5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x5 x6 x7 x8 x9];
y_1=[y5 y6 y7 y8 y9];
plot(x_1,y_1,'k');
hold on
x_1=[x5+0.3 x6+0.3 x7+0.3 x8+0.3 x9+0.35];
y_1=[y5+0.97 y6+0.97 y7+0.97 y8+0.97 y9+0.97];
plot(x_1,y_1,'k');
hold on
x_2=[x5 x10 x11 x12];
y_2=[y5 y10 y11 y12];
plot(x_2,y_2,'k');
hold on
x_3=[x18 x13 x14 x15];
y_3=[y18 y13 y14 y15];
plot(x_3,y_3,'k');
hold on
x_4=[x9 x16 x17 x18];
y_4=[y9 y16 y17 y18];
plot(x_4,y_4,'k');
hold on
axis equal;
axis([-0.5 1.75 -0.5 1.5]);
axis off;
hold off
end % switch

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 27', 'RP 28', 'RP 29' });

% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
popup_sel_index = get(handles.popupmenu5, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 27; Laves-Netz: 43433; Symmetriegruppe: p4mg; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=1;
x4=0;
y4=1;
x5=3;
y5=0;
x6=3;
y6=2;
x7=2;
y7=2;
x8=0;
y8=2;
x9=4;
y9=0;
x10=4;
y10=2;
for m = 0:1:4
 for k = 0:1:8
  cx=[m*(x8-x1)+k*(x9-x1)];
  cy=[m*(y8-y1)+k*(y9-y1)];  
  x_a1=[x1+cx x4+cx x3+cx x4+cx x8+cx x7+cx x2+cx x7+cx x6+cx x5+cx x9+cx x10+cx x6+cx x8+cx x1+cx];
  y_a1=[y1+cy y4+cy y3+cy y4+cy y8+cy y7+cy y2+cy y7+cy y6+cy y5+cy y9+cy y10+cy y6+cy y8+cy y1+cy];
  fill(x_a1,y_a1,'w');
  hold on
 end
end
axis([0.25 7.25 0.25 7.25]);
axis square;
axis('off');
hold off
axes(handles.axes2);
cla;
x_a=[x1 x2 x3 x4 x1];
y_a=[y1 y2 y3 y4 y1];
fill(x_a,y_a,'w');
axis equal;
axis([-1 3 -1 2]);
axis off;
hold off
case 2
set(handles.text21,'string','RP 28; Laves-Netz: 43433; Symmetriegruppe: p4; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=2;
x4=0;
y4=2;
x5=1.3;
y5=0;
x6=2;
y6=1.3;
x7=0.7;
y7=2;
x8=0;
y8=0.7;
x9=1;
y9=1;
for k = 0:1:3
for m = 0:1:3
cx=[k*(x4-x1) + m*(x2-x1)];
cy=[k*(y4-y1) + m*(y2-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x8+cx x6+cx];
y_2=[y8+cy y6+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x5+cx x7+cx];
y_3=[y5+cy y7+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([1 7 1 7]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x5 x9 x8 x1];
y_1=[y1 y5 y9 y8 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 3
set(handles.text21,'string','RP 29; Laves-Netz: 43433; Symmetriegruppe: p2gg; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=0.75;
y3=1;
x4=0.25;
y4=1;
x5=1.5;
y5=0;
x6=1.75;
y6=1;
for k = 0:1:5
for m = 0:1:3
cx=[k*(x4-x1) + m*(x5-x1)];
cy=[k*(y4-y1) + m*(y5-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x2+cx x5+cx x6+cx x3+cx];
y_2=[y2+cy y5+cy y6+cy y3+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis equal;
axis([1 5 0.5 4.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
end % switch

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 30', 'RP 31', 'RP 32' });

% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
popup_sel_index = get(handles.popupmenu6, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 30; Laves-Netz: 6434; Symmetriegruppe: p6mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
%Dreiecke:
x1=0;
y1=0;
x2=2;
y2=0;
x3=1;
y3=sqrt(3);
%Sechsecke:
x4=1;
y4=0.333*sqrt(3);
x5=2;
y5=0.667*sqrt(3);
x6=3;
y6=y4;
x7=3;
y7=-y6;
x8=2;
y8=-y5;
x9=1;
y9=-y4;
for k = -2:1:4
for m = -2:1:4
cx=[k*(x2-x1) + m*(x3-x1)];
cy=[k*(y2-y1) + m*(y3-y1)];
x_4=[x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x4+cx];
y_4=[y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y4+cy];
fill(x_4,y_4,'w');
hold on
x_1=[x1+cx x3+cx];
y_1=[y1+cy y3+cy];
plot(x_1,y_1,'k-');
hold on
x_2=[x1+cx x2+cx];
y_2=[y1+cy y2+cy];
plot(x_2,y_2,'k-');
hold on
x_3=[x2+cx x3+cx];
y_3=[y2+cy y3+cy];
plot(x_3,y_3,'k-');
hold on
end
end
axis equal;
axis([-1.25 5.25 -2.25 4.25]);
axis off;
hold off
axes(handles.axes2);
cla;
x10=0.5;
y10=0.5*y3;
x11=1;
y11=0;
x_a=[x1 x10 x4 x11 x1];
y_a=[y1 y10 y4 y11 y1];
fill(x_a,y_a,'w');
axis equal;
axis([-0.25 1.25 -0.25 1.25]);
axis off;
hold off
case 2
set(handles.text21,'string','RP 31; Laves-Netz: 6434; Symmetriegruppe: p3m1; einfaches Parkett, Dirichlet-Parkett');
axes(handles.axes1);
cla;
phi=pi/3;
x1=0;
y1=1.732;
x2=-1.5;
y2=2.598;
x3=-3;
y3=0;
x4=0;
y4=0;
x5=-0.3;
y5=0.4;
phi=2*pi/3;
x6=cos(-phi)*x5-sin(-phi)*y5+x2;
y6=sin(-phi)*x5+cos(-phi)*y5+y2;
ax=3;
ay=0;
bx=0;
by=3*y1;
dx=-x2;
dy=y2;
for k = -2:1:2
for m = -2:1:2
cx=[k*(x3-ax) + m*(ax-bx)];
cy=[k*(y3-ay) + m*(ay-by)];
x7=cos(phi)*x5-sin(phi)*y5+dx;
y7=sin(phi)*x5+cos(phi)*y5+dy;
x_1=[x3+cx x4+cx x5+cx x1+cx x6+cx x2+cx x3+cx];
y_1=[y3+cy y4+cy y5+cy y1+cy y6+cy y2+cy y3+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x2+cx bx+cx dx+cx ax+cx x4+cx];
y_2=[y2+cy by+cy dy+cy ay+cy y4+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x1+cx x7+cx dx+cx];
y_3=[y1+cy y7+cy dy+cy];
plot(x_3,y_3,'k');
hold on
x_4=x_1;
y_4=-y_1;
plot(x_4,y_4,'k');
hold on
x_5=x_3;
y_5=-y_3;
plot(x_5,y_5,'k');
hold on
end
end
axis equal;
axis([-8 8 -8 8]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x3 x4 x5 x1 x6 x2 x3];
y_1=[y3 y4 y5 y1 y6 y2 y3];
plot(x_1,y_1,'k');
hold on
axis equal;
axis([-4 1 -1 5]);
axis off;
hold off
case 3
set(handles.text21,'string','RP 32; Laves-Netz: 6434; Symmetriegruppe: p6; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
phi=pi/3;
x1=0;
y1=0;
x2=0.866;
y2=-0.5;
x3=x2+0.289;
y3=0;
x4=x2;
y4=-y2;
x5=0.4;
y5=-0.3;
x6=0.95;
y6=-0.2;
ax=-x2;
ay=-y2;
bx=-x2;
by=y2;
for k = 0:1:4
for m = -1:1:4
cx=[k*(x2-ax) + m*(x4-bx)];
cy=[k*(y2-ay) + m*(y4-by)];
for n = 0:1:5
phi=n*pi/3;
x7=cos(phi)*x5-sin(phi)*y5;
y7=sin(phi)*x5+cos(phi)*y5;
x8=cos(phi)*x6-sin(phi)*y6;
y8=sin(phi)*x6+cos(phi)*y6;
x9=cos(phi)*x1-sin(phi)*y1;
y9=sin(phi)*x1+cos(phi)*y1;
x10=cos(phi)*x2-sin(phi)*y2;
y10=sin(phi)*x2+cos(phi)*y2;
x11=cos(phi)*x3-sin(phi)*y3;
y11=sin(phi)*x3+cos(phi)*y3;
x_1=[x9+cx x7+cx x10+cx x8+cx x11+cx];
y_1=[y9+cy y7+cy y10+cy y8+cy y11+cy];
plot(x_1,y_1,'k');
hold on
end
end
end
axis equal;
axis([3 9 -4 2]);
axis off;
hold off
axes(handles.axes2);
cla;
phi=pi/3;
x7=cos(phi)*x5-sin(phi)*y5;
y7=sin(phi)*x5+cos(phi)*y5;
x8=cos(phi)*x6-sin(phi)*y6;
y8=sin(phi)*x6+cos(phi)*y6;
x9=cos(phi)*x1-sin(phi)*y1;
y9=sin(phi)*x1+cos(phi)*y1;
x10=cos(phi)*x2-sin(phi)*y2;
y10=sin(phi)*x2+cos(phi)*y2;
x11=cos(phi)*x3-sin(phi)*y3;
y11=sin(phi)*x3+cos(phi)*y3;
x_1=[x9 x7 x10 x8 x11];
y_1=[y9 y7 y10 y8 y11];
plot(x_1,y_1,'k');
hold on
phi=2*pi/3;
x7=cos(phi)*x5-sin(phi)*y5;
y7=sin(phi)*x5+cos(phi)*y5;
x9=cos(phi)*x1-sin(phi)*y1;
y9=sin(phi)*x1+cos(phi)*y1;
x10=cos(phi)*x2-sin(phi)*y2;
y10=sin(phi)*x2+cos(phi)*y2;
x_1=[x9 x7 x10];
y_1=[y9 y7 y10];
plot(x_1,y_1,'k');
hold on
phi=4*pi/3;
x8a=x8;
y8a=y8;
x8=cos(phi)*x8a-sin(phi)*y8a;
y8=sin(phi)*x8a+cos(phi)*y8a+y11+1;
x_2=[x10 x8 x11];
y_2=[y10 y8 y11];
plot(x_2,y_2,'k');
hold on
axis equal;
axis([-0.5 1.5 -0.5 1.5]);
axis off;
hold off
end % switch

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 33', 'RP 34', 'RP 35', 'RP 36', 'RP 37' });

% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
popup_sel_index = get(handles.popupmenu7, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 33; Laves-Netz: 6363; Symmetriegruppe: p6mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x4=1;
y4=0.333*sqrt(3);
x5=2;
y5=0.667*sqrt(3);
x6=3;
y6=y4;
x7=3;
y7=-y6;
x8=2;
y8=-y5;
x9=1;
y9=-y4;
x1=0.5*(x7-x9)+x9;
y1=0.5*(y4-y9)+y9;
for k = 0:1:6
for m = 0:1:6
cx=[k*(x4-x8) + m*(x9-x5)];
cy=[k*(y4-y8) + m*(y9-y5)];
x_4=[x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x4+cx];
y_4=[y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y4+cy];
plot(x_4,y_4,'k');
hold on
x_3=[x1+cx x5+cx x1+cx];
y_3=[y1+cy y5+cy y1+cy];
plot(x_3,y_3,'k');
hold on
x_2=[x1+cx x7+cx x1+cx];
y_2=[y1+cy y7+cy y1+cy];
plot(x_2,y_2,'k');
hold on
x_1=[x1+cx x9+cx x1+cx];
y_1=[y1+cy y9+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([-7.5 0.5 -4.5 3.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x4 x5 x6 x1 x4];
y_1=[y4 y5 y6 y1 y4];
plot(x_1,y_1,'k');
hold on
axis equal;
axis([1 3 -0.5 1.5]);
axis off;
hold off 
case 2
set(handles.text21,'string','RP 34; Laves-Netz: 6363; Symmetriegruppe: p3m1. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x4=1;
y4=0.333*sqrt(3);
x5=2;
y5=0.667*sqrt(3);
x6=3;
y6=y4;
x7=3;
y7=-y6;
x8=2;
y8=-y5;
x9=1;
y9=-y4;
x1=0.5*(x7-x9)+x9;
y1=0.5*(y4-y9)+y9;
x2=x1;
y2=y1+0.8;
x3=x1-0.7;
y3=y1-0.41;
x10=x1+0.7;
y10=y1-0.41;
for k = 0:1:6
for m = 0:1:6
cx=[k*(x4-x8) + m*(x9-x5)];
cy=[k*(y4-y8) + m*(y9-y5)];
x_4=[x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x4+cx];
y_4=[y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y4+cy];
plot(x_4,y_4,'k');
hold on
x_3=[x1+cx x5+cx x1+cx];
y_3=[y1+cy y5+cy y1+cy];
plot(x_3,y_3,'k');
hold on
x_2=[x1+cx x7+cx x1+cx];
y_2=[y1+cy y7+cy y1+cy];
plot(x_2,y_2,'k');
hold on
x_1=[x1+cx x9+cx x1+cx];
y_1=[y1+cy y9+cy y1+cy];
plot(x_1,y_1,'k');
hold on
plot(x2+cx,y2+cy,'k.');
hold on
plot(x3+cx,y3+cy,'k.');
hold on
plot(x10+cx,y10+cy,'k.');
hold on
end
end
axis equal;
axis([-7.5 0.5 -4.5 3.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x4 x5 x6 x1 x4];
y_1=[y4 y5 y6 y1 y4];
plot(x_1,y_1,'k');
hold on
plot(x10,y10+1.15,'k.');
hold on
plot(x3,y3+1.15,'k.');
hold on
axis equal;
axis off;
hold off
case 3
set(handles.text21,'string','RP 35; Laves-Netz: 6363; Symmetriegruppe: p3m1');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1.7;
y2=-0.3;
x3=2;
y3=0;
phi=2*pi/3;
x4=cos(phi)*x2-sin(phi)*y2;
y4=sin(phi)*x2+cos(phi)*y2;
x5=cos(phi)*x3-sin(phi)*y3;
y5=sin(phi)*x3+cos(phi)*y3;
x6=cos(-phi)*x2-sin(-phi)*y2;
y6=sin(-phi)*x2+cos(-phi)*y2;
x7=cos(-phi)*x3-sin(-phi)*y3;
y7=sin(-phi)*x3+cos(-phi)*y3;
x8=-1.7;
y8=-0.3;
x9=-2;
y9=0;
x10=cos(phi)*x8-sin(phi)*y8;
y10=sin(phi)*x8+cos(phi)*y8;
x11=cos(phi)*x9-sin(phi)*y9;
y11=sin(phi)*x9+cos(phi)*y9;
x12=cos(-phi)*x8-sin(-phi)*y8;
y12=sin(-phi)*x8+cos(-phi)*y8;
x13=cos(-phi)*x9-sin(-phi)*y9;
y13=sin(-phi)*x9+cos(-phi)*y9;
for k = 0:1:3
for m = 0:1:4
cx=[k*(x5-x7) + m*(x3-x7)];
cy=[k*(y5-y7) + m*(y3-y7)];
x_1=[x3+cx x2+cx x1+cx x8+cx x9+cx];
y_1=[y3+cy y2+cy y1+cy y8+cy y9+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x11+cx x10+cx x1+cx x6+cx x7+cx];
y_2=[y11+cy y10+cy y1+cy y6+cy y7+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x5+cx x4+cx x1+cx x12+cx x13+cx];
y_3=[y5+cy y4+cy y1+cy y12+cy y13+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([0.5 7 5 12]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x13 x12 x1 x2 x3];
y_1=[y13 y12 y1 y2 y3];
plot(x_1,y_1,'k');
hold on
cx=[x3-x7];
cy=[y3-y7];
x_2=[x9+cx x8+cx x1+cx x6+cx x7+cx];
y_2=[y9+cy y8+cy y1+cy y6+cy y7+cy];
plot(x_2,y_2,'k');
hold on
axis equal;
axis off;
hold off
case 4
set(handles.text21,'string','RP 36; Laves-Netz: 6363; Symmetriegruppe: p6');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1.7;
y2=-0.3;
x3=2;
y3=0;
phi=pi/3;
x4=cos(phi)*x2-sin(phi)*y2;
y4=sin(phi)*x2+cos(phi)*y2;
x5=cos(phi)*x3-sin(phi)*y3;
y5=sin(phi)*x3+cos(phi)*y3;
x6=cos(-phi)*x2-sin(-phi)*y2;
y6=sin(-phi)*x2+cos(-phi)*y2;
x7=cos(-phi)*x3-sin(-phi)*y3;
y7=sin(-phi)*x3+cos(-phi)*y3;
x8=-1.7;
y8=0.3;
x9=-2;
y9=0;
x10=cos(phi)*x8-sin(phi)*y8;
y10=sin(phi)*x8+cos(phi)*y8;
x11=cos(phi)*x9-sin(phi)*y9;
y11=sin(phi)*x9+cos(phi)*y9;
x12=cos(-phi)*x8-sin(-phi)*y8;
y12=sin(-phi)*x8+cos(-phi)*y8;
x13=cos(-phi)*x9-sin(-phi)*y9;
y13=sin(-phi)*x9+cos(-phi)*y9;
for k = 0:1:3
for m = 0:1:3
cx=[k*(x5-x7) + m*(x3-x11)];
cy=[k*(y5-y7) + m*(y3-y11)];
x_1=[x3+cx x2+cx x1+cx x8+cx x9+cx];
y_1=[y3+cy y2+cy y1+cy y8+cy y9+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x11+cx x10+cx x1+cx x6+cx x7+cx];
y_2=[y11+cy y10+cy y1+cy y6+cy y7+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x5+cx x4+cx x1+cx x12+cx x13+cx];
y_3=[y5+cy y4+cy y1+cy y12+cy y13+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([0.5 7 5 12]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x7 x6 x1 x2 x3];
y_1=[y7 y6 y1 y2 y3];
plot(x_1,y_1,'k');
hold on
x4=cos(pi)*x7-sin(pi)*y7+x3+x7;
y4=sin(pi)*x7+cos(pi)*y7+y3+y7;
x5=cos(pi)*x6-sin(pi)*y6+x3+x7;
y5=sin(pi)*x6+cos(pi)*y6+y3+y7;
x8=cos(pi)*x3-sin(pi)*y3+x3+x7;
y8=sin(pi)*x3+cos(pi)*y3+y3+y7;
x9=cos(pi)*x2-sin(pi)*y2+x3+x7;
y9=sin(pi)*x2+cos(pi)*y2+y3+y7;
x_2=[x8 x9 x1+x3+x7 x5 x4];
y_2=[y8 y9 y1+y3+y7 y5 y4];
plot(x_2,y_2,'k');
hold on
axis equal;
axis off;
hold off
case 5
set(handles.text21,'string','RP 37; Laves-Netz: 6363; Symmetriegruppe: p3; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
phi=pi/3;
x1=1;
y1=0;
x2=0;
y2=0;
x3=cos(phi)*x1-sin(phi)*y1;
y3=sin(phi)*x1+cos(phi)*y1;
x4=0.6;
y4=0.3;
x5=cos(phi)*0.3-sin(phi)*0.2;
y5=sin(phi)*0.3+cos(phi)*0.2;
Ax=cos(-phi)*1-sin(-phi)*0;
Ay=sin(-phi)*1+cos(-phi)*0;
Bx=-1;
By=0;
Cx=x3;
Cy=y3;
for k = -1:1:7
for m = 0:1:5
cx=[k*(Cx-Bx) + m*(Ax-Bx)];
cy=[k*(Cy-By) + m*(Ay-By)];
for n = 0:1:2
phi=n*2*pi/3;
x13=cos(phi)*x1-sin(phi)*y1;
y13=sin(phi)*x1+cos(phi)*y1;
x14=cos(phi)*x2-sin(phi)*y2;
y14=sin(phi)*x2+cos(phi)*y2;
x6=cos(phi)*x4-sin(phi)*y4;
y6=sin(phi)*x4+cos(phi)*y4;
x_1=[x13+cx x6+cx x14+cx];
y_1=[y13+cy y6+cy y14+cy];
plot(x_1,y_1,'k');
hold on
x15=cos(phi)*x2-sin(phi)*y2;
y15=sin(phi)*x2+cos(phi)*y2;
x16=cos(phi)*x3-sin(phi)*y3;
y16=sin(phi)*x3+cos(phi)*y3;
x7=cos(phi)*x5-sin(phi)*y5;
y7=sin(phi)*x5+cos(phi)*y5;
x_2=[x15+cx x7+cx x16+cx];
y_2=[y15+cy y7+cy y16+cy];
plot(x_2,y_2,'k');
hold on
end
end
end
axis equal;
axis([3 10 -4 3]);
axis off;
hold off
axes(handles.axes2);
cla;
phi=2*pi/3;
x13=cos(phi)*x1-sin(phi)*y1;
y13=sin(phi)*x1+cos(phi)*y1;
x14=cos(phi)*x2-sin(phi)*y2;
y14=sin(phi)*x2+cos(phi)*y2;
x6=cos(phi)*x4-sin(phi)*y4;
y6=sin(phi)*x4+cos(phi)*y4;
x_1=[x13 x6 x14];
y_1=[y13 y6 y14];
plot(x_1,y_1,'k');
hold on
x15=cos(phi)*x2-sin(phi)*y2;
y15=sin(phi)*x2+cos(phi)*y2;
x16=cos(phi)*x3-sin(phi)*y3;
y16=sin(phi)*x3+cos(phi)*y3;
x7=cos(phi)*x5-sin(phi)*y5;
y7=sin(phi)*x5+cos(phi)*y5;
x_2=[x15 x7 x16];
y_2=[y15 y7 y16];
plot(x_2,y_2,'k');
hold on
phi=5*pi/3;
x13=cos(phi)*x1-sin(phi)*y1-1.5;
y13=sin(phi)*x1+cos(phi)*y1+0.85;
x14=cos(phi)*x2-sin(phi)*y2-1.5;
y14=sin(phi)*x2+cos(phi)*y2+0.85;
x6=cos(phi)*x4-sin(phi)*y4-1.5;
y6=sin(phi)*x4+cos(phi)*y4+0.85;
x_1=[x13 x6 x14];
y_1=[y13 y6 y14];
plot(x_1,y_1,'k');
hold on
x15=cos(phi)*x2-sin(phi)*y2-1.5;
y15=sin(phi)*x2+cos(phi)*y2+0.85;
x16=cos(phi)*x3-sin(phi)*y3-1.5;
y16=sin(phi)*x3+cos(phi)*y3+0.87;
x7=cos(phi)*x5-sin(phi)*y5-1.5;
y7=sin(phi)*x5+cos(phi)*y5+0.9;
x_2=[x15 x7 x16];
y_2=[y15 y7 y16];
plot(x_2,y_2,'k');
hold on
axis equal;
axis off;
axis([-2 0.5 -0.5 1.5]);
hold off
end % switch

% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 38', 'RP 39', 'RP 40', 'RP 41', 'RP 42', 'RP 43', 'RP 44', 'RP 45', 'RP 46', 'RP 47', 'RP 48', 'RP 49', 'RP 50', 'RP 51', 'RP 52', 'RP 53', 'RP 54', 'RP 55', 'RP 56', 'RP 57', 'RP 58', 'RP 59', 'RP 60', 'RP 61', 'RP 62', 'RP 63', 'RP 64', 'RP 65', 'RP 66', 'RP 67', 'RP 68', 'RP 69', 'RP 70', 'RP 71', 'RP 72', 'RP 73' });

% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8
popup_sel_index = get(handles.popupmenu8, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 38; Laves-Netz: 4444; Symmetriegruppe: p4mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=1;
y3=1;
x4=0;
y4=1;
for k = -1:1:5
for m = -1:1:5
cx=[k*(x2-x1) + m*(x4-x1)];
cy=[k*(y2-y1) + m*(y4-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal;
axis([0.5 5.5 0.5 5.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
fill(x_1,y_1,'w');
axis([-0.5 1.5 -0.5 1.5]);
axis equal;
axis off;
hold off
case 2
set(handles.text21,'string','RP 39; Laves-Netz: 4444; Symmetriegruppe: p4mm. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=1;
y3=1;
x4=0;
y4=1;
x5=0.2;
y5=0;
x6=0;
y6=0.2;
x7=-0.2;
y7=0;
x8=0;
y8=-0.2;
for k = -5:1:2
for m = -5:1:2
cx=[k*(x2-x1) + m*(x4-x1)];
cy=[k*(y2-y1) + m*(y4-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
fill(x_1,y_1,'w');
hold on
dx=[2*k];
dy=[2*m];
plot(x5+dx,y5+dy,'k.');
hold on
plot(x6+dx,y6+dy,'k.');
hold on
plot(x7+dx,y7+dy,'k.');
hold on
plot(x8+dx,y8+dy,'k.');
hold on
plot(x5+dx+1,y5+dy+1,'k.');
hold on
plot(x6+dx+1,y6+dy+1,'k.');
hold on
plot(x7+dx+1,y7+dy+1,'k.');
hold on
plot(x8+dx+1,y8+dy+1,'k.');
hold on
end
end
axis equal;
axis([-4.5 0.5 -4.5 0.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
fill(x_1,y_1,'w');
hold on
plot(x5,y5,'k.');
hold on
plot(x6,y6,'k.');
hold on
plot(x7+1,y7+1,'k.');
hold on
plot(x8+1,y8+1,'k.');
axis equal;
axis off;
hold off
case 3
set(handles.text21,'string','RP 40; Laves-Netz: 4444; Symmetriegruppe: p4mm. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=1;
y3=1;
x4=0;
y4=1;
x5=0.2;
y5=0;
x6=0;
y6=0.2;
x7=-0.2;
y7=0;
x8=0;
y8=-0.2;
for k = -5:1:2
for m = -5:1:2
cx=[k*(x2-x1) + m*(x4-x1)];
cy=[k*(y2-y1) + m*(y4-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
fill(x_1,y_1,'w');
hold on
dx=[2*k];
dy=[2*m];
plot(x5+dx,y5+dy,'k.');
hold on
plot(x6+dx,y6+dy,'k.');
hold on
plot(x7+dx,y7+dy,'k.');
hold on
plot(x8+dx,y8+dy,'k.');
hold on
end
end
axis equal;
axis([-4.5 0.5 -4.5 0.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
fill(x_1,y_1,'w');
hold on
plot(x5,y5,'k.');
hold on
plot(x6,y6,'k.');
hold on
axis equal;
axis off;
hold off
case 4
set(handles.text21,'string','RP 41; Laves-Netz: 4444; Symmetriegruppe: p4gm. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=1;
y3=1;
x4=0;
y4=1;
x5=0.2;
y5=0;
x6=0;
y6=0.8;
x7=-0.2;
y7=0;
x8=0;
y8=-0.8;
x9=0.8;
y9=1;
x10=1;
y10=0.2;
x11=1;
y11=-0.2;
x12=0.2;
y12=1;
for k = -5:1:2
for m = -5:1:2
cx=[k*(x2-x1) + m*(x4-x1)];
cy=[k*(y2-y1) + m*(y4-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
fill(x_1,y_1,'w');
hold on
dx=[2*k];
dy=[2*m];
plot(x5+dx,y5+dy,'k.');
hold on
plot(x6+dx,y6+dy,'k.');
hold on
plot(x7+dx,y7+dy,'k.');
hold on
plot(x8+dx,y8+dy,'k.');
hold on
plot(x9+dx,y9+dy,'k.');
hold on
plot(x10+dx,y10+dy,'k.');
hold on
plot(x11+dx,y11+dy,'k.');
hold on
plot(x12+dx+1,y12+dy,'k.');
hold on
end
end
axis equal;
axis([-4.5 0.5 -4.5 0.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
fill(x_1,y_1,'w');
hold on
plot(x5,y5,'k.');
hold on
plot(x6,y6,'k.');
hold on
plot(x9,y9,'k.');
hold on
plot(x10,y10,'k.');
hold on
axis equal;
axis off;
hold off
case 5
set(handles.text21,'string','RP 42; Laves-Netz: 4444; Symmetriegruppe: p4gm');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0.5;
x3=2;
y3=0;
x4=2.5;
y4=1;
x5=2;
y5=2;
x6=1;
y6=1.5;
x7=0;
y7=2;
x8=-0.5;
y8=1;
x9=3;
y9=-0.5;
x10=4;
y10=0;
x11=3.5;
y11=1;
x12=4;
y12=2;
x13=3;
y13=2.5;
for k = -3:1:4
for m = -2:1:6
cx=[k*(x8-x11) + m*(x2-x13)];
cy=[k*(y8-y11) + m*(y2-y13)];
x_1=[x3+cx x2+cx x1+cx x8+cx x7+cx x6+cx x5+cx x4+cx x3+cx x9+cx x10+cx x11+cx x12+cx x13+cx x5+cx];
y_1=[y3+cy y2+cy y1+cy y8+cy y7+cy y6+cy y5+cy y4+cy y3+cy y9+cy y10+cy y11+cy y12+cy y13+cy y5+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([-13.75 0 -12 2]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y1];
plot(x_1,y_1,'k');
axis equal;
axis([-0.5 2.5 -0.5 2.5]);
axis off;
hold off
case 6
set(handles.text21,'string','RP 43; Laves-Netz: 4444; Symmetriegruppe: p4gm');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1.7;
y2=0.3;
x3=2;
y3=0;
x4=2.3;
y4=0.3;
x5=2;
y5=2;
x6=0.3;
y6=2.3;
x7=0;
y7=2;
x8=0.3;
y8=1.7;
x9=-0.3;
y9=1.7;
x10=-2;
y10=2;
x11=-1.7;
y11=0.3;
x12=-2;
y12=0;
x13=-1.7;
y13=-0.3;
x14=1.7;
y14=-0.3;
x15=2;
y15=-2;
x16=0.3;
y16=-1.7;
x17=0;
y17=-2;
x18=-0.3;
y18=-1.7;
for k = 0:1:3
for m = 0:1:3
cx=[k*(x3-x12) + m*(x5-x15)];
cy=[k*(y3-y12) + m*(y5-y15)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x1+cx x13+cx x12+cx x11+cx x10+cx x9+cx x7+cx];
y_2=[y1+cy y13+cy y12+cy y11+cy y10+cy y9+cy y7+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x1+cx x18+cx x17+cx x16+cx x15+cx x14+cx x3+cx];
y_3=[y1+cy y18+cy y17+cy y16+cy y15+cy y14+cy y3+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([1 9 1 9]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 7
set(handles.text21,'string','RP 44; Laves-Netz: 4444; Symmetriegruppe: p4gm; einfaches Parkett, Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=x2;
y3=1;
x4=x1;
y4=y3;
x5=-0.2;
y5=0.2;
x6=-0.3;
y6=0.5;
x7=0;
y7=0.7;
Bx=0;
By=-1;
Cx=2;
Cy=-1;
Dx=2;
Dy=1;
for k = 0:1:2
for m = 0:1:2
cx=[k*(Dx-Bx) + m*(Cx-x4)];
cy=[k*(Dy-By) + m*(Cy-y4)];
for n = 0:1:3
phi=n*pi/2;
x13=cos(phi)*x3-sin(phi)*y3;
y13=sin(phi)*x3+cos(phi)*y3;
x14=cos(phi)*x4-sin(phi)*y4;
y14=sin(phi)*x4+cos(phi)*y4;
x_1=[x13+cx x14+cx];
y_1=[y13+cy y14+cy];
plot(x_1,y_1,'k');
hold on
x15=cos(phi)*x3-sin(phi)*y3;
y15=sin(phi)*x3+cos(phi)*y3;
x16=cos(phi)*x2-sin(phi)*y2;
y16=sin(phi)*x2+cos(phi)*y2;
x_2=[x15+cx x16+cx];
y_2=[y15+cy y16+cy];
plot(x_2,y_2,'k');
hold on
x8=cos(phi)*x5-sin(phi)*y5;
y8=sin(phi)*x5+cos(phi)*y5;
x9=cos(phi)*x6-sin(phi)*y6;
y9=sin(phi)*x6+cos(phi)*y6;
x10=cos(phi)*x7-sin(phi)*y7;
y10=sin(phi)*x7+cos(phi)*y7;
x11=cos(phi)*(-1);
y11=sin(phi)*(-1);
x12=0;
y12=0;
x_5=[x11+cx x8+cx x9+cx x10+cx x12+cx];
y_5=[y11+cy y8+cy y9+cy y10+cy y12+cy];
plot(x_5,y_5,'k');
hold on
x_6=[2-x11+cx 2-x8+cx 2-x9+cx 2-x10+cx 2-x12+cx];
y_6=[y11+cy y8+cy y9+cy y10+cy y12+cy];
plot(x_6,y_6,'k');
hold on
end
end
end
axis([1.25 6.5 -2 2]);
axis equal;
axis off;
hold off
axes(handles.axes2);
cla;
phi=2*pi/2;
x13=cos(phi)*x3-sin(phi)*y3;
y13=sin(phi)*x3+cos(phi)*y3;
x14=cos(phi)*x4-sin(phi)*y4;
y14=sin(phi)*x4+cos(phi)*y4;
x_1=[x13 x14];
y_1=[y13 y14];
plot(x_1,y_1,'k');
hold on
x15=cos(phi)*x3-sin(phi)*y3;
y15=sin(phi)*x3+cos(phi)*y3;
x16=cos(phi)*x2-sin(phi)*y2;
y16=sin(phi)*x2+cos(phi)*y2;
x_2=[x15 x16];
y_2=[y15 y16];
plot(x_2,y_2,'k');
hold on
phi=pi/2;
x8a=cos(phi)*x8-sin(phi)*y8;
y8a=sin(phi)*x8+cos(phi)*y8;
x9a=cos(phi)*x9-sin(phi)*y9;
y9a=sin(phi)*x9+cos(phi)*y9;
x10a=cos(phi)*x10-sin(phi)*y10;
y10a=sin(phi)*x10+cos(phi)*y10;
x11a=cos(phi)*x11-sin(phi)*y11;
y11a=sin(phi)*x11+cos(phi)*y11;
x12a=0;
y12a=0;
x8=cos(phi)*x5-sin(phi)*y5;
y8=sin(phi)*x5+cos(phi)*y5;
x9=cos(phi)*x6-sin(phi)*y6;
y9=sin(phi)*x6+cos(phi)*y6;
x10=cos(phi)*x7-sin(phi)*y7;
y10=sin(phi)*x7+cos(phi)*y7;
x11=cos(phi)*(-1);
y11=sin(phi)*(-1);
x12=0;
y12=0;
x_5=[x11 x8 x9 x10 x12];
y_5=[y11 y8 y9 y10 y12];
plot(x_5,y_5,'k');
hold on
x_6=[x11a x8a x9a x10a x12a];
y_6=[y11a y8a y9a y10a y12a];
plot(x_6,y_6,'k');
hold on
axis on;
axis equal;
axis([-1.25 0.25 -1.25 1]);
axis off;
hold off
case 8
set(handles.text21,'string','RP 45; Laves-Netz: 4444; Symmetriegruppe: p4');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2*pi;
y2=0;
x3=2*pi;
y3=2*pi;
x4=0;
y4=2*pi;
t = (0:1/1000:1)'*2*pi;
for k = 0:1:3
for m = 0:1:3
cx=[k*(x2-x1) + m*(x4-x1)];
cy=[k*(y2-y1) + m*(y4-y1)];
x_1=t;
y_1=0.7*sin(t);
plot(x_1+cx,y_1+cy,'k');
hold on
x_2=t;
y_2=0.7*sin(t)+2*pi;
plot(x_2+cx,y_2+cy,'k');
hold on
y_3=t;
x_3=-0.7*sin(t);
plot(x_3+cx,y_3+cy,'k');
hold on
y_4=t;
x_4=-0.7*sin(t)+2*pi;
plot(x_4+cx,y_4+cy,'k');
hold on
end
end
axis equal;
axis([2 25 2 25]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=t;
y_1=0.7*sin(t);
plot(x_1,y_1,'k');
hold on
x_2=t;
y_2=0.7*sin(t)+2*pi;
plot(x_2,y_2,'k');
hold on
y_3=t;
x_3=-0.7*sin(t);
plot(x_3,y_3,'k');
hold on
y_4=t;
x_4=-0.7*sin(t)+2*pi;
plot(x_4,y_4,'k');
hold on
axis equal;
axis([-1.5 7.5 -1.5 7.5]);
axis off;
hold off
case 9
set(handles.text21,'string','RP 46; Laves-Netz: 4444; Symmetriegruppe: p4');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1.7;
y2=-0.3;
x3=2;
y3=0;
phi=pi/2;
x4=cos(2*phi)*x2-sin(2*phi)*y2;
y4=sin(2*phi)*x2+cos(2*phi)*y2;
x5=cos(2*phi)*x3-sin(2*phi)*y3;
y5=sin(2*phi)*x3+cos(2*phi)*y3;
x6=0.3;
y6=1.7;
x7=0;
y7=2;
x8=-0.3;
y8=-1.7;
x9=0;
y9=-2;
for k = 0:1:6
for m = 0:1:3
cx=[k*(x3-x9) + m*(x7-x9)];
cy=[k*(y3-y9) + m*(y7-y9)];
x_1=[x3+cx x2+cx x1+cx x4+cx x5+cx];
y_1=[y3+cy y2+cy y1+cy y4+cy y5+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x9+cx x8+cx x1+cx x6+cx x7+cx];
y_2=[y9+cy y8+cy y1+cy y6+cy y7+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis equal;
axis([1 8 5 12.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x3 x2 x1 x8 x9 x4+x3+x9 x3+x9+x1 x6+x3+x9 x3];
y_1=[y3 y2 y1 y8 y9 y4+y3+y9 y3+y9+y1 y6+y9+y3 y3];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 10
set(handles.text21,'string','RP 47; Laves-Netz: 4444; Symmetriegruppe: p4; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=-0.2;
y2=0.4;
x3=0.1;
y3=0.2;
x4=0;
y4=2;
x5=0.2;
y5=1.9;
x6=0.3;
y6=2.1;
x7=0.4;
y7=2;
x8=2;
y8=2;
x16=-2;
y16=0;
x17=2;
y17=0;
x18=0;
y18=2;
x19=0;
y19=-2;
for k = -1:1:1
for m = -1:1:1
cx=[k*(x16-x17) + m*(x18-x19)];
cy=[k*(y16-y17) + m*(y18-y19)];
for n = 1:1:3
phi=n*pi/2;
x9=cos(phi)*x2-sin(phi)*y2;
y9=sin(phi)*x2+cos(phi)*y2;
x10=cos(phi)*x3-sin(phi)*y3;
y10=sin(phi)*x3+cos(phi)*y3;
x11=cos(phi)*x4-sin(phi)*y4;
y11=sin(phi)*x4+cos(phi)*y4;
x12=cos(phi)*x5-sin(phi)*y5;
y12=sin(phi)*x5+cos(phi)*y5;
x13=cos(phi)*x6-sin(phi)*y6;
y13=sin(phi)*x6+cos(phi)*y6;
x14=cos(phi)*x7-sin(phi)*y7;
y14=sin(phi)*x7+cos(phi)*y7;
x15=cos(phi)*x8-sin(phi)*y8;
y15=sin(phi)*x8+cos(phi)*y8;
x_1=[x8+cx x7+cx x6+cx x5+cx x4+cx x3+cx x2+cx x1+cx x9+cx x10+cx x11+cx x12+cx x13+cx x14+cx x15+cx];
y_1=[y8+cy y7+cy y6+cy y5+cy y4+cy y3+cy y2+cy y1+cy y9+cy y10+cy y11+cy y12+cy y13+cy y14+cy y15+cy];
plot(x_1,y_1,'k');
hold on
end
end
end
axis equal;
axis([-4.5 4.5 -4.5 4.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=2;
x4=0;
y4=2;
x5=0.2;
y5=-0.1;
x6=0.3;
y6=0.1;
x7=0.4;
y7=0;
phi=-pi/2;
x8=cos(phi)*x7-sin(phi)*y7+2;
y8=sin(phi)*x7+cos(phi)*y7+2;
x9=cos(phi)*x6-sin(phi)*y6+2;
y9=sin(phi)*x6+cos(phi)*y6+2;
x10=cos(phi)*x5-sin(phi)*y5+2;
y10=sin(phi)*x5+cos(phi)*y5+2;
x11=0.2;
y11=1.9;
x12=0.4;
y12=2.2;
x13=cos(-phi)*1.6+sin(-phi)*0.2;
y13=sin(-phi)*1.6-cos(-phi)*0.2;
x14=cos(-phi)*1.8-sin(-phi)*0.1;
y14=sin(-phi)*1.8+cos(-phi)*0.1;
x_1=[x1 x5 x6 x7 x2 x8 x9 x10 x3 x11 x12 x4 x13 x14 x1];
y_1=[y1 y5 y6 y7 y2 y8 y9 y10 y3 y11 y12 y4 y13 y14 y1];
plot(x_1,y_1,'k');
axis equal;
axis([-0.5 2.5 -0.5 2.5]);
axis off;
hold off
case 11 
set(handles.text21,'string','RP 48; Laves-Netz: 4444; Symmetriegruppe: p2mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=1;
x4=0;
y4=1;
for m = 0:1:4
for k = 0:1:8
cx=[m*(x2-x1)+k*(x4-x1)];
cy=[m*(y2-y1)+k*(y4-y1)];
x_a1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_a1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
fill(x_a1,y_a1,'w');
hold on
end
end
axis equal;
axis([0.5 7.5 0.5 7.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_a1=[x1 x2 x3 x4 x1];
y_a1=[y1 y2 y3 y4 y1];
fill(x_a1,y_a1,'w');
axis equal;
axis([-1 3 -1 2]);
axis off;
hold off
case 12
set(handles.text21,'string','RP 49; Laves-Netz: 4444; Symmetriegruppe: p2mm. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=1;
x4=0;
y4=1;
x5=0;
y5=0.2;
x6=0;
y6=-0.2;
x7=2;
y7=0.2;
for m = 0:1:4
for k = 0:1:8
cx=[m*(x2-x1)+k*(x4-x1)];
cy=[m*(y2-y1)+k*(y4-y1)];
x_a1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_a1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
plot(x_a1,y_a1,'k');
hold on
plot(x5+cx,y5+2*cy,'k.');
hold on
plot(x6+cx,y6+2*cy,'k.');
hold on
end
end
axis equal;
axis([0.5 7.5 0.5 7.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
plot(x_1,y_1,'k');
hold on
plot(x5,y5,'k.');
hold on
plot(x7,y7,'k.');
hold on
axis equal;
axis off;
hold off
case 13
set(handles.text21,'string','RP 50; Symmetriegruppe: p2mm; Laves-Netz: 4444. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=1;
x4=0;
y4=1;
x5=0.2;
y5=0;
x6=-0.2;
y6=0;
x7=1.8;
y7=0;
for m = 0:1:4
for k = 0:1:8
cx=[m*(x2-x1)+k*(x4-x1)];
cy=[m*(y2-y1)+k*(y4-y1)];
plot(x5+cx,y5+2*cy,'k.');
hold on
plot(x6+cx,y6+2*cy,'k.');
hold on
x_a1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_a1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
plot(x_a1,y_a1,'k');
hold on
end
end
axis equal;
axis([0.5 7.5 0.5 7.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
plot(x_1,y_1,'k');
hold on
plot(x5,y5,'k.');
hold on
plot(x7,y7,'k.');
hold on
axis equal;
axis off;
hold off
case 14
set(handles.text21,'string','RP 51; Laves-Netz: 4444; Symmetriegruppe: c2mm');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1.5;
y2=1;
x3=0;
y3=2;
x4=-1.5;
y4=1;
for k = -1:1:3
for m = -1:1:3
cx=[k*(x3-x1) + m*(x2-x4)];
cy=[k*(y3-y1) + m*(y2-y4)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal;
axis([-1.25 6.25 -1.25 6.25]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
fill(x_1,y_1,'w');
axis equal;
axis([-1.75 2.25 -0.25 2.5]);
axis off;
hold off
case 15
set(handles.text21,'string','RP 52; Laves-Netz: 4444; Symmetriegruppe: c2mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0;
y2=2;
x3=-1;
y3=1.5;
x4=-1;
y4=0.5;
x5=1;
y5=0.5;
x6=1;
y6=1.5;
for k = 0:1:5
for m = 0:1:5
cx=[k*(x6-x1) + m*(x5-x4)];
cy=[k*(y6-y1) + m*(y5-y4)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx x5+cx x6+cx x2+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy y5+cy y6+cy y2+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([2.5 8.5 1 7]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 16
set(handles.text21,'string','RP 53; Laves-Netz: 4444; Symmetriegruppe: c2mm. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2;
y3=1;
x4=0;
y4=1;
x5=0.2;
y5=0;
x6=-0.2;
y6=0;
x7=1.8;
y7=1;
for m = 0:1:4
for k = 0:1:8
cx=[m*(x2-x1)+k*(x4-x1)];
cy=[m*(y2-y1)+k*(y4-y1)];
plot(x5+2*cx+2,y5+2*cy,'k.');
hold on
plot(x6+2*cx+2,y6+2*cy,'k.');
hold on
plot(x5+2*cx,y5+2*cy+1,'k.');
hold on
plot(x6+2*cx,y6+2*cy+1,'k.');
hold on
x_a1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_a1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
plot(x_a1,y_a1,'k');
hold on
end
end
axis equal;
axis([0.5 7.5 0.5 7.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
plot(x_1,y_1,'k');
hold on
plot(x5,y5,'k.');
hold on
plot(x7,y7,'k.');
hold on
axis equal;
axis off;
hold off
case 17
set(handles.text21,'string','RP 54; Laves-Netz: 4444; Symmetriegruppe: c2mm; einfaches Parkett, Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0;
y2=2;
x3=-1;
y3=1.5;
x4=-1;
y4=0.5;
x5=1;
y5=0.5;
x6=1;
y6=1.5;
x7=1;
y7=1;
x8=-1;
y8=1;
for k = 0:1:5
for m = 0:1:5
cx=[k*(x6-x1) + m*(x5-x4)];
cy=[k*(y6-y1) + m*(y5-y4)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx x5+cx x6+cx x2+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy y5+cy y6+cy y2+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x7+cx x8+cx];
y_2=[y7+cy y8+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis equal;
axis([2.5 8.5 1 7]);
axis off;
hold off
axes(handles.axes2);
cla;
x9=0;
y9=1;
x_1=[x1 x9 x8 x4 x1];
y_1=[y1 y9 y8 y4 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 18
set(handles.text21,'string','RP 55; Laves-Netz: 4444; Symmetriegruppe: p2mg');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.2;
y2=0.2;
x3=0.5;
y3=-0.1;
x4=0.8;
y4=0.2;
x5=1;
y5=0;
x6=1.3;
y6=0.4;
x7=0.7;
y7=0.6;
x8=1;
y8=1;
x9=x4;
y9=1+y4;
x10=x3;
y10=1+y3;
x11=x2;
y11=1+y2;
x12=0;
y12=1;
x13=0.3;
y13=0.6;
x14=-0.3;
y14=0.4;
x15=1+x2;
y15=-y2;
x16=1+x3;
y16=-y3;
x17=1+x4;
y17=-y4;
x18=2;
y18=0;
for k = 0:1:4
for m = 0:1:2
cx=[k*(x12-x1) + m*(x18-x1)];
cy=[k*(y12-y1) + m*(y18-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x13+cx x14+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y13+cy y14+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x5+cx x15+cx x16+cx x17+cx x18+cx];
y_2=[y5+cy y15+cy y16+cy y17+cy y18+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis equal;
axis([0.5 4.5 0.5 4.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 19
set(handles.text21,'string','RP 56; Laves-Netz: 4444; Symmetriegruppe: p2mg; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.5;
y2=0.2;
x3=1;
y3=0;
x4=0.5;
y4=0.75;
for k = 0:1:3
for m = 0:1:6
cx=[k*(x3-x1) + m*(x4-x2)];
cy=[k*(y3-y1) + m*(y4-y2)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([0.25 3.75 0.25 3.75]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 20
set(handles.text21,'string','RP 57; Laves-Netz: 4444; Symmetriegruppe: p2mg');
axes(handles.axes1);
cla;
x4=1;
y4=0.333*sqrt(3);
x5=2;
y5=0.667*sqrt(3);
x6=3;
y6=y4;
x7=3;
y7=-y6;
x8=2;
y8=-y5;
x9=1;
y9=-y4;
x1=0.5*(x7-x9)+x9;
y1=0.5*(y4-y9)+y9;
for k = -5:1:5
for m = -5:1:5
cx=[k*(x7-x4) + m*(x8-x4)];
cy=[k*(y7-y4) + m*(y8-y4)];
%Sechsecke:
x_4=[x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x4+cx];
y_4=[y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y4+cy];
fill(x_4,y_4,'w');
hold on
x_3=[x1+cx x5+cx x1+cx];
y_3=[y1+cy y5+cy y1+cy];
plot(x_3,y_3,'k-');
hold on
x_2=[x1+cx x7+cx x1+cx];
y_2=[y1+cy y7+cy y1+cy];
plot(x_2,y_2,'k-');
hold on
x_1=[x1+cx x9+cx x1+cx];
y_1=[y1+cy y9+cy y1+cy];
plot(x_1,y_1,'k-');
hold on
end
end
axis equal;
axis([-3.25 3.25 -2 3.25]);
axis off;
hold off
axes(handles.axes2);
cla;
x1=0;
y1=0;
x2=1.5;
y2=1;
x3=0;
y3=2;
x4=-1.5;
y4=1;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
fill(x_1,y_1,'w');
axis equal;
axis([-1.75 2.25 -0.25 2.5]);
axis off;
hold off
case 21
set(handles.text21,'string','RP 58; Laves-Netz: 4444; Symmetriegruppe: p2mg; einfaches Parkett, Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=-3;
y1=1;
x2=0;
y2=0;
x3=0;
y3=3;
x4=-3;
y4=3;
x5=-2.7;
y5=1.2;
x6=-0.3;
y6=-0.2;
x7=-2;
y7=2.6;
x8=-1;
y8=3.4;
x9=0;
y9=5;
x10=-3;
y10=6;
bx=3;
by=1;
for k = -2:1:3
for m = -2:1:3
cx=[k*(x10-x1) + m*(x1-bx)];
cy=[k*(y10-y1) + m*(y1-by)];
x_1=[x10+cx x4+cx x1+cx x5+cx x6+cx x2+cx x3+cx x9+cx x3+cx x7+cx x8+cx x4+cx];
y_1=[y10+cy y4+cy y1+cy y5+cy y6+cy y2+cy y3+cy y9+cy y3+cy y7+cy y8+cy y4+cy];
plot(x_1,y_1,'k');
hold on
plot(-x_1,y_1,'k');
hold on
end
end
axis equal;
axis([-7 7 -7 7]);
axis off;
hold off
axes(handles.axes2);
cla;
x_2=[x1 x5 x6 x2 x3 x7 x8 x4 x1];
y_2=[y1 y5 y6 y2 y3 y7 y8 y4 y1];
plot(x_2,y_2,'k');
hold on
axis equal;
axis([-3.5 0.5 -0.5 3.5]);
axis off;
hold off
case 22 
set(handles.text21,'string','RP 59; Laves-Netz: 4444; Symmetriegruppe: p2mg; einfaches Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0.5;
x3=2;
y3=2.5;
x4=0;
y4=2;
x5=1.5;
y5=3/8;
x6=1.5;
y6=7/8;
x7=1.2;
y7=5/8;
x8=1.2;
y8=11/8;
x9=1.7;
y9=1.7;
x10=1.7;
y10=1.7/4;
x11=1.9;
y11=2;
x12=2.1;
y12=1;
ax=-4;
ay=1;
bx=4;
by=1;
for k = 0:1:1
for m = -1:1:5
cx=[k*(ax-bx) + m*(x4-x1)];
cy=[k*(ay-by) + m*(y4-y1)];
x_1=[x4+cx x1+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x2+cx x11+cx x12+cx x3+cx];
y_1=[y4+cy y1+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y2+cy y11+cy y12+cy y3+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x4+cx x1+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x2+cx x11+cx x12+cx x3+cx];
y_1=[y4+cy y1+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y2+cy y11+cy y12+cy y3+cy];
plot(-x_1,y_1,'k');
hold on
phi=pi;
x13=4+cos(phi)*x5-sin(phi)*y5;
y13=1+sin(phi)*x5+cos(phi)*y5;
x14=4+cos(phi)*x6-sin(phi)*y6;
y14=1+sin(phi)*x6+cos(phi)*y6;
x15=4+cos(phi)*x7-sin(phi)*y7;
y15=1+sin(phi)*x7+cos(phi)*y7;
x16=4+cos(phi)*x8-sin(phi)*y8;
y16=1+sin(phi)*x8+cos(phi)*y8;
x17=4+cos(phi)*x9-sin(phi)*y9;
y17=1+sin(phi)*x9+cos(phi)*y9;
x18=4+cos(phi)*x10-sin(phi)*y10;
y18=1+sin(phi)*x10+cos(phi)*y10;
x19=4+cos(phi)*x1-sin(phi)*y1;
y19=1+sin(phi)*x1+cos(phi)*y1;
x20=4;
y20=3;
x_3=[x2+cx x18+cx x17+cx x16+cx x15+cx x14+cx x13+cx x19+cx x20+cx];
y_3=[y2+cy y18+cy y17+cy y16+cy y15+cy y14+cy y13+cy y19+cy y20+cy];
plot(x_3,y_3,'k');
hold on
plot(-x_3,y_3,'k');
hold on
end
end
axis equal;
axis([-5 5 2 11]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x4 x1 x5 x6 x7 x8 x9 x10 x2 x11 x12 x3];
y_1=[y4 y1 y5 y6 y7 y8 y9 y10 y2 y11 y12 y3];
plot(x_1,y_1,'k');
hold on
x_2=[x1 x5 x6 x7 x8 x9 x10 x2];
y_2=[y1+y4 y5+y4 y6+y4 y7+y4 y8+y4 y9+y4 y10+y4 y2+y4];
plot(x_2,y_2,'k');
hold on
axis equal;
axis([-0.5 2.5 -0.5 4]);
axis off;
hold off
case 23
set(handles.text21,'string','RP 60; Laves-Netz: 4444; Symmetriegruppe: p2gg');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.2;
y2=-0.3;
x3=1;
y3=0;
x4=0.85;
y4=0.25;
x5=cos(pi/3)+1;
y5=sin(pi/3);
x6=1.4;
y6=1.2;
x7=cos(pi/3);
y7=sin(pi/3);
x8=0.7;
y8=0.6;
x9=2;
y9=0;
for k = 0:1:5
for m = -1:1:5
cx=[k*(x5-x1) + m*(x9-x1)];
cy=[k*(y5-y1) + m*(y9-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([5 10 0 5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 24
set(handles.text21,'string','RP 61; Laves-Netz: 4444; Symmetriegruppe: p2gg; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1.5;
y2=0.5;
x3=2;
y3=0;
x4=2;
y4=0.3;
x5=1.8;
y5=0.5;
x6=2;
y6=0.6;
x7=2;
y7=1;
x8=0.5;
y8=1.5;
x9=0;
y9=1;
x10=0;
y10=0.7;
x11=-0.2;
y11=0.5;
x12=0;
y12=0.4;
x13=2.5;
y13=-0.5;
x14=4;
y14=0;
x15=4;
y15=0.4;
x16=3.8;
y16=0.5;
x17=4;
y17=0.7;
x18=4;
y18=1;
x19=4;
y19=1.3;
x20=4.2;
y20=1.5;
x21=4;
y21=1.6;
x22=4;
y22=2;
x23=3.5;
y23=0.5;
x24=2;
y24=1.3;
x25=2.2;
y25=1.5;
x26=2;
y26=1.6;
x27=2;
y27=2;
for k = 0:1:4
for m = 0:1:1
cx=[k*(x27-x3) + m*(x14-x1)];
cy=[k*(y27-y3) + m*(y14-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x3+cx x13+cx x14+cx x15+cx x16+cx x17+cx x18+cx x23+cx x7+cx x24+cx x25+cx x26+cx x27+cx];
y_2=[y3+cy y13+cy y14+cy y15+cy y16+cy y17+cy y18+cy y23+cy y7+cy y24+cy y25+cy y26+cy y27+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x18+cx x19+cx x20+cx x21+cx x22+cx];
y_3=[y18+cy y19+cy y20+cy y21+cy y22+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([1 7.5 1 7.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y1];
plot(x_1,y_1,'k');
axis equal;
axis off;
hold off
case 25
set(handles.text21,'string','RP 62; Laves-Netz: 4444; Symmetriegruppe: p2gg; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=1;
y1=0;
x2=2;
y2=0;
x3=1.8;
y3=0.2;
x4=2.2;
y4=0.4;
x5=2;
y5=0.6;
x6=1.08;
y6=1;
x7=1;
y7=0.5;
x8=x6;
y8=0.5;
x9=3-x4;
y9=-y4+0.2;
x10=3-x3;
y10=-y3-0.2;
x11=3-x5;
y11=-y5;
x12=3-x6;
y12=-y6;
x13=3-x7;
y13=-y7;
x14=3-x8;
y14=-y8;
x15=3+0.08;
y15=1;
x16=x2+1;
y16=y2;
for k = 0:1:3
for m = 0:1:2
cx=[k*(x6-x11) + m*x2];
cy=[k*(y6-y11) + m*y2];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x1+cx x9+cx x10+cx x11+cx x12+cx x14+cx x13+cx x2+cx];
y_2=[y1+cy y9+cy y10+cy y11+cy y12+cy y14+cy y13+cy y2+cy];
plot(x_2,y_2,'k');
hold on
x_2=[x16+cx x2+cx];
y_2=[y16+cy y2+cy];
plot(x_2,y_2,'k');
hold on
x_2=[x15+cx x5+cx];
y_2=[y15+cy y5+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis equal;
axis([1.5 7 -0.5 5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 26
set(handles.text21,'string','RP 63; Laves-Netz: 4444; Symmetriegruppe: p2gg; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=2;
y1=0;
x2=1;
y2=2;
x3=0;
y3=0;
x4=0.5;
y4=-0.5;
x5=1.8;
y5=0;
x6=1.9;
y6=0.2;
x7=0.8;
y7=y2;
x8=x2-0.1;
y8=y2-y6;
phi1=-pi/4;
x9=cos(phi1)*0.3+sin(phi1)*0.1;
y9=sin(phi1)*0.3-cos(phi1)*0.1;
x10=cos(phi1)*(1/sqrt(2)-0.3)-sin(phi1)*0.1;
y10=sin(phi1)*(1/sqrt(2)-0.3)+cos(phi1)*0.1;
phi2=atan(1/3);
x11=cos(phi2)*0.4-sin(phi2)*0.2+x4;
y11=sin(phi2)*0.4+cos(phi2)*0.2-0.6;
x12=cos(phi2)*(sqrt(5/2)-0.4)+sin(phi2)*0.2+x4;
y12=sin(phi2)*(sqrt(5/2)-0.4)-sin(phi2)*0.2-0.6;
x17=cos(phi1)*0.3+sin(phi1)*0.1-1;
y17=-(sin(phi1)*0.3-cos(phi1)*0.1)+y2;
x16=cos(phi1)*(1/sqrt(2)-0.3)-sin(phi1)*0.1-1;
y16=-(sin(phi1)*(1/sqrt(2)-0.3)+cos(phi1)*0.1)+y2;
x14=cos(phi2)*0.4-sin(phi2)*0.2+x4-1;
y14=-(sin(phi2)*0.4+cos(phi2)*0.2-0.6)+y2;
x13=cos(phi2)*(sqrt(5/2)-0.4)+sin(phi2)*0.2+x4-1;
y13=-(sin(phi2)*(sqrt(5/2)-0.4)-sin(phi2)*0.2-0.6)+y2;
x15=x4-1;
y15=y2-y4;
x18=-1;
y18=y2;
x21=x4-x2;
y21=y4-y2;
x19=x4-x8;
y19=y4-y8;
x20=x21+0.2;
y20=y21;
x24=x4-x1;
y24=y4;
x22=x4-x6;
y22=y4-y6;
x23=x24+0.2;
y23=y24;
for k = 1:1:2
for m = 1:1:6
cx=[k*(x21-x15) + m*(x3-x1)];
cy=[k*(y21-y15) + m*(y3-y1)];
x_1=[x18+cx x17+cx x16+cx x15+cx x14+cx x13+cx x2+cx];
y_1=[y18+cy y17+cy y16+cy y15+cy y14+cy y13+cy y2+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x2+cx x6+cx x5+cx x1+cx x12+cx x11+cx x4+cx x10+cx x9+cx x3+cx x8+cx x7+cx x2+cx];
y_2=[y2+cy y6+cy y5+cy y1+cy y12+cy y11+cy y4+cy y10+cy y9+cy y3+cy y8+cy y7+cy y2+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x4+cx x19+cx x20+cx x21+cx x22+cx x23+cx x24+cx];
y_3=[y4+cy y19+cy y20+cy y21+cy y22+cy y23+cy y24+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([-12 -5 -12 -5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_2=[x2 x6 x5 x1 x12 x11 x4 x10 x9 x3 x8 x7 x2];
y_2=[y2 y6 y5 y1 y12 y11 y4 y10 y9 y3 y8 y7 y2];
plot(x_2,y_2,'k');
hold on
axis equal;
axis([-0.5 2.5 -1 2.5]);
axis off;
hold off
case 27
set(handles.text21,'string','RP 64; Laves-Netz: 4444; Symmetriegruppe: pm');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=2.25;
y3=0.75;
x4=2;
y4=1.5;
x5=0;
y5=1.5;
x6=0.25;
y6=0.75;
for k = 0:1:4
for m = 0:1:4
cx=[k*(x4-x2) + m*(x2-x1)];
cy=[k*(y4-y2) + m*(y2-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([0.5 8.5 -0.5 7.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x1];
y_1=[y1 y2 y3 y4 y5 y6 y1];
plot(x_1,y_1,'k');
axis equal;
axis([-0.25 2.25 -0.5 2]);
axis off;
hold off
case 28
set(handles.text21,'string','RP 65; Laves-Netz: 4444; Symmetriegruppe: pm; einfaches Parkett');
axes(handles.axes1);
cla;
x1=-2;
y1=2;
x2=-2;
y2=0.5;
x3=0;
y3=1.5;
x4=0;
y4=0;
x5=2;
y5=0.5;
x6=-0.8;
y6=-0.2;
x7=-0.6;
y7=-0.1;
x8=-0.7;
y8=0;
x9=-0.75;
y9=-0.1;
x10=-1;
y10=0.2;
x11=-0.9;
y11=0.4;
for k = -1:1:3
for m = -3:1:4
cx=[k*(x5-x1) + m*(x2-x1)];
cy=[k*(y5-y1) + m*(y2-y1)];
x_1=[x1+cx x2+cx];
y_1=[y1+cy y2+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x3+cx x4+cx];
y_2=[y3+cy y4+cy];
plot(x_2,y_2,'k');
hold on
x_3=[x2+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x4+cx];
y_3=[y2+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y4+cy];
plot(x_3,y_3,'k');
hold on
x_4=[-x2+cx -x6+cx -x7+cx -x8+cx -x9+cx -x10+cx -x11+cx -x4+cx];
y_4=[y2+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y4+cy];
plot(x_4,y_4,'k');
hold on
end
end
axis([-1.75 6.75 -3 3]);
axis equal;
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2];
y_1=[y1 y2];
plot(x_1,y_1,'k');
hold on
x_2=[x3 x4];
y_2=[y3 y4];
plot(x_2,y_2,'k');
hold on
x_3=[x2 x6 x7 x8 x9 x10 x11 x4];
y_3=[y2 y6 y7 y8 y9 y10 y11 y4];
plot(x_3,y_3,'k');
hold on
x_4=[x2 x6 x7 x8 x9 x10 x11 x4];
y_4=[y2+1.5 y6+1.5 y7+1.5 y8+1.5 y9+1.5 y10+1.5 y11+1.5 y4+1.5];
plot(x_4,y_4,'k');
hold on
axis equal;
axis([-2.25 0.25 -1 2.25]);
axis off;
hold off
case 29
set(handles.text21,'string','RP 66; Laves-Netz: 4444; Symmetriegruppe: cm');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.2;
y2=-0.2;
x3=1;
y3=0;
x5=cos(pi/3)+1;
y5=sin(pi/3);
x7=cos(pi/3);
y7=sin(pi/3);
x6=x7+0.2;
y6=y7-0.2;
x8=cos(17*pi/20)*x2-sin(17*pi/20)*y2;
y8=sin(17*pi/20)*x2+cos(17*pi/20)*y2;
x4=x3+x8;
y4=y3+y8;
x9=2;
y9=0;
for k = 0:1:5 
for m = -1:1:5 
cx=[k*(x5-x1) + m*(x9-x1)];
cy=[k*(y5-y1) + m*(y9-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([5 10 0 5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 30
set(handles.text21,'string','RP 67; Laves-Netz: 4444; Symmetriegruppe: cm; einfaches Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=1/3;
x3=1;
y3=0.6;
x5=1.5;
y5=0.5;
x6=1.5;
y6=1.5;
x7=0.5;
y7=1.8;
x8=0.5;
y8=2.1;
x10=0;
y10=2;
for k = -2:1:2
for m = -2:1:2
cx=[k*(x6-x1) + m*(x10-x5)];
cy=[k*(y6-y1) + m*(y10-y5)];
x_1=[x1+cx x2+cx x3+cx x5+cx x6+cx x7+cx x8+cx x10+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y5+cy y6+cy y7+cy y8+cy y10+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal;
axis([-2.5 2.5 -2.5 2.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x5 x6 x7 x8 x10 x1];
y_1=[y1 y2 y3 y5 y6 y7 y8 y10 y1];
fill(x_1,y_1,'w');
hold on
axis equal;
axis([-0.25 1.75 -0.25 2.25]);
axis off;
hold off
case 31
set(handles.text21,'string','RP 68; Laves-Netz: 4444; Symmetriegruppe: pg; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=4;
y1=2;
x2=4;
y2=0;
x3=3.5;
y3=-0.25;
x4=3;
y4=0;
x5=2;
y5=0;
x6=2;
y6=2;
x7=1.5;
y7=2.25;
x8=1;
y8=2;
x9=0;
y9=2;
x10=3;
y10=2;
x11=3.5;
y11=2.25;
x12=3.5;
y12=0.25;
for k =0:1:5
for m = 0:1:5
cx=[k*(x6-x5)+m*(x9-x1)];
cy=[k*(y6-y5)+m*(y9-y1)];
x_1=[x9+cx x8+cx x7+cx x6+cx x5+cx x4+cx x3+cx x2+cx x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx];
y_1=[y9+cy y8+cy y7+cy y6+cy y5+cy y4+cy y3+cy y2+cy y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis([-6.5 3.5 0.5 8.5]);
axis equal
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x12 x4 x5 x6 x10 x11 x1];
y_1=[y1 y2 y12 y4 y5 y6 y10 y11 y1];
fill(x_1,y_1,'w');
axis equal;
axis([1 5 -1 3]);
axis off;
hold off
case 32
set(handles.text21,'string','RP 69; Laves-Netz: 4444; Symmetriegruppe: pg; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=2;
y1=0;
x2=2;
y2=1;
x3=2.25;
y3=1.5;
x4=2;
y4=2;
x5=1;
y5=2;
x6=0.5;
y6=1.75;
x7=0;
y7=2;
x8=0;
y8=0;
for k = -5:1:7
for m = -5:1:7
cx=[k*(x4-x8)+m*(x7-x1)];
cy=[k*(y4-y8)+m*(y7-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal
axis([-3.5 7.5 1.5 10.5]);
axis off; 
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8];
fill(x_1,y_1,'w');
axis equal;
axis([-1 3 -1 3]);
axis off;
hold off
case 33
set(handles.text21,'string','RP 70; Laves-Netz: 4444; Symmetriegruppe: p2');
axes(handles.axes1);
cla;
x1=-0.5;
y1=0;
x2=1.5;
y2=1;
x3=0.5;
y3=2;
x4=-1.5;
y4=1;
for k = -1:1:3
for m = -1:1:3
cx=[k*(x3-x1) + m*(x4-x2)];
cy=[k*(y3-y1) + m*(y4-y2)];
x_1=[x1+cx x2+cx x3+cx x4+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal;
axis([-5.25 1.25 0.25 6.75]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x1];
y_1=[y1 y2 y3 y4 y1];
fill(x_1,y_1,'w');
axis equal;
axis([-1.75 1.75 -0.25 2.25]);
axis off;
hold off
case 34
set(handles.text21,'string','RP 71; Laves-Netz: 4444; Symmetriegruppe: p2; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.8;
y2=0;
x3=0.9;
y3=-0.1;
x4=1;
y4=0;
x5=1.3;
y5=0;
x6=1.6;
y6=0;
x7=1.7;
y7=0.1;
x8=1.8;
y8=0;
x9=2.6;
y9=0;
phi=2.5*pi/7;
x10=cos(phi)*0.75-sin(phi)*0.3+x5;
y10=sin(phi)*0.75+cos(phi)*0.3;
x11=cos(phi)*1.5+sin(phi)*0.3+x5;
y11=sin(phi)*1.5-cos(phi)*0.3;
x12=cos(phi)*2.25+x5;
y12=sin(phi)*2.25;
x13=cos(phi)*0.2+sin(phi)*0.2;
y13=sin(phi)*0.2-cos(phi)*0.2;
x14=cos(phi)*2.05-sin(phi)*0.2;
y14=sin(phi)*2.05+cos(phi)*0.2;
x15=cos(phi)*2.25;
y15=sin(phi)*2.25;
for k = -2:1:1
for m = -2:1:1
cx=[k*(x9-x1) + m*(x12-x5)];
cy=[k*(y9-y1) + m*(y12-y5)];
x_1=[x15+cx x14+cx x13+cx x1+cx x2+cx x3+cx x4+cx x5+cx x10+cx x11+cx x12+cx x11+cx x10+cx x5+cx x6+cx x7+cx x8+cx x9+cx x8+cx x7+cx x6+cx x5+cx x4+cx x3+cx x2+cx x1+cx x13+cx x14+cx x15+cx];
y_1=[y15+cy y14+cy y13+cy y1+cy y2+cy y3+cy y4+cy y5+cy y10+cy y11+cy y12+cy y11+cy y10+cy y5+cy y6+cy y7+cy y8+cy y9+cy y8+cy y7+cy y6+cy y5+cy y4+cy y3+cy y2+cy y1+cy y13+cy y14+cy y15+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis([-2.25 2.5 -2.5 3.5]);
axis equal;
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x15 x14 x13 x1 x2 x3 x4 x5];
y_1=[y15 y14 y13 y1 y2 y3 y4 y5];
plot(x_1,y_1,'k');
hold on
x_2=[x5 x10 x11 x12];
y_2=[y5 y10 y11 y12];
plot(x_2,y_2,'k');
hold on
x_3=[x1+1 x2+0.95 x3+0.95 x4+0.95 x5+0.95];
y_3=[y1+2.05 y2+2.05 y3+2.05 y4+2.05 y5+2.05];
plot(x_3,y_3,'k');
hold on
axis equal;
axis([-0.5 2.5 -0.25 2.25]);
axis off;
hold off
case 35
set(handles.text21,'string','RP 72; Laves-Netz: 4444; Symmetriegruppe: p2; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
phi1=pi/2;
x1=0;
y1=0;
x2=0.3;
y2=0;
x3=0.3;
y3=-0.1;
x4=0.4;
y4=-0.1;
x5=0.4;
y5=0;
x5a=0.6;
y5a=0;
x5b=0.6;
y5b=0.1;
x5c=0.7;
y5c=0.1;
x5d=0.7;
y5d=0;
x6=1;
y6=0;
x7=cos(phi1)*0.2-sin(phi1)*0.1+1;
y7=sin(phi1)*0.2+cos(phi1)*0.1;
x8=cos(phi1)*0.6+sin(phi1)*0.1+1;
y8=sin(phi1)*0.6-cos(phi1)*0.1;
x9=cos(phi1)*0.8+1;
y9=sin(phi1)*0.8;
x10=x9-0.2;
y10=y9;
x11=x9-0.3;
y11=y9-0.1;
x12=x9-0.4;
y12=y9;
x13=x9-0.7;
y13=y9;
x14=x9-0.8;
y14=y9+0.1;
x15=x9-0.9;
y15=y9;
x16=x9-1.1;
y16=y9;
phi2=atan(0.375)+(pi/2);
x18=0;
y18=0.4;
x17=-0.1;
y17=0.4;
for k = 0:1:5
for m = 0:1:5
cx=[k*(x9-x1) + m*(x16-x6)];
cy=[k*(y9-y1) + m*(y16-y6)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x5a+cx x5b+cx x5c+cx x5d+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x13+cx x14+cx x15+cx x16+cx x17+cx x18+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y5a+cy y5b+cy y5c+cy y5d+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y13+cy y14+cy y15+cy y16+cy y17+cy y17+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal;
axis([-2 2 2 6]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x5a x5b x5c x5d x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x1];
y_1=[y1 y2 y3 y4 y5 y5a y5b y5c y5d y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y17 y1];
fill(x_1,y_1,'w');
hold on
axis equal;
axis([-0.5 1.5 -0.5 1]);
axis off;
hold off
case 36
set(handles.text21,'string','RP 73; Laves-Netz: 4444; Symmetriegruppe: p1; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
phi=2*pi/5;
x1=-1.5;
y1=0;
x2=-0.2;
y2=0.1;
x3=-0.6;
y3=-0.2;
x4=0;
y4=0;
x5=0.4*cos(phi);
y5=0.4*sin(phi);
x6=0.5*cos(phi)-0.2*sin(phi);
y6=0.5*sin(phi)+0.2*cos(phi);
x7=0.6*cos(phi);
y7=0.6*sin(phi);
x8=cos(phi);
y8=sin(phi);
for k = -3:1:5
for m = -2:1:3
cx=[k*(x4-x1) + m*(x8-x1)];
cy=[k*(y4-y1) + m*(y8-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x7+cx x6+cx x5+cx x4+cx x3+cx x2+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y7+cy y6+cy y5+cy y4+cy y3+cy y2+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal;
axis([-1.75 3.5 -2 2.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x3+x8 x2+x8 x1+x8 x7+x1 x6+x1 x5+x1 x4+x1 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y3+y8 y2+y8 y1+y8 y7 y6 y5 y4 y1];
fill(x_1,y_1,'w');
axis equal;
axis([-2 1 -0.25 1.5]);
axis off;
hold off
end % switch


% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 74', 'RP 75', 'RP 76' });

% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9
popup_sel_index = get(handles.popupmenu9, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 74; Laves-Netz: 12,12,3; Symmetriegruppe: p6mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2/sin(pi/3);
y2=0;
phi1=pi/6;
x3=cos(phi1)*4;
y3=sin(phi1)*4;
x8=0;
y8=-4;
phi=2*pi/3;
x9=cos(phi)*x3-sin(phi)*y3;
y9=sin(phi)*x3+cos(phi)*y3;
for k = -2:1:4
for m = -2:1:4
cx=[k*(x8-x1) + m*(x9-x1)];
cy=[k*(y8-y1) + m*(y9-y1)];
for n = 0:1:5
phi=n*pi/3;
x1a=cos(phi)*x1-sin(phi)*y1;
y1a=sin(phi)*x1+cos(phi)*y1;
x2a=cos(phi)*x2-sin(phi)*y2;
y2a=sin(phi)*x2+cos(phi)*y2;
x_1=[x1a+cx x2a+cx];
y_1=[y1a+cy y2a+cy];
plot(x_1,y_1,'k');
hold on
end
for n = 0:1:2
phi=2*n*pi/3;
x1a=cos(phi)*x1-sin(phi)*y1;
y1a=sin(phi)*x1+cos(phi)*y1;
x3a=cos(phi)*x3-sin(phi)*y3;
y3a=sin(phi)*x3+cos(phi)*y3;
x_1=[x1a+cx x3a+cx];
y_1=[y1a+cy y3a+cy];
plot(x_1,y_1,'k');
hold on
end
end
end
axis equal;
axis([-6 4 -6 4]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x1];
y_1=[y1 y2 y3 y1];
fill(x_1,y_1,'w');
axis equal;
axis([0 3.5 -1 2]);
axis off;
hold off
case 2
set(handles.text21,'string','RP 75; Laves-Netz: 12,12,3; Symmetriegruppe: p31m; einfaches Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=-1;
y2=2*cos(pi/6);
x3=-1;
y3=-2*cos(pi/6);
xa=2;
ya=0;
for k = -1:1:5
for m = -1:1:4
cx=[k*(x3-x2) + m*(x3-xa)];
cy=[k*(y3-y2) + m*(y3-ya)];
for n = 0:1:2
phi=2*n*pi/3;
x4=cos(phi)*2+sin(phi)*0;
y4=sin(phi)*2-cos(phi)*0;
x5=cos(phi)*0.3+sin(phi)*0.1;
y5=sin(phi)*0.3-cos(phi)*0.1;
x6=cos(phi)*0.2-sin(phi)*0.1;
y6=sin(phi)*0.2+cos(phi)*0.1;
x7=cos(phi)*0.5+sin(phi)*0.1;
y7=sin(phi)*0.5-cos(phi)*0.1;
x8=cos(phi)*0.4-sin(phi)*0.1;
y8=sin(phi)*0.4+cos(phi)*0.1;
x_1=[x4+cx x8+cx x7+cx x6+cx x5+cx x1+cx];
y_1=[y4+cy y8+cy y7+cy y6+cy y5+cy y1+cy];
plot(x_1,y_1,'k');
hold on
x_2=[-2-x4+cx -2-x8+cx -2-x7+cx -2-x6+cx -2-x5+cx -2-x1+cx];
y_2=[y4+cy y8+cy y7+cy y6+cy y5+cy y1+cy];
plot(x_2,y_2,'k');
hold on
end
x4=2;
y4=0;
x_3=[x2+cx x3+cx x4+cx x2+cx];
y_3=[y2+cy y3+cy y4+cy y2+cy];
plot(x_3,y_3,'k');
hold on
end
end
axis equal;
axis([-13.5 -1.5 -18.5 -6.5]);
axis off;
hold off
axes(handles.axes2);
cla;
phi=4*pi/3;
x5=cos(phi)*0.3+sin(phi)*0.1;
y5=sin(phi)*0.3-cos(phi)*0.1;
x6=cos(phi)*0.2-sin(phi)*0.1;
y6=sin(phi)*0.2+cos(phi)*0.1;
x7=cos(phi)*0.5+sin(phi)*0.1;
y7=sin(phi)*0.5-cos(phi)*0.1;
x8=cos(phi)*0.4-sin(phi)*0.1;
y8=sin(phi)*0.4+cos(phi)*0.1;
x_1=[x1 x5 x6 x7 x8 x3 x4];
y_1=[y1 y5 y6 y7 y8 y3 y4];
plot(x_1,y_1,'k');
hold on
phi=0*pi/3;
x5=0.3;
y5=-0.1;
x6=0.2;
y6=0.1;
x7=0.5;
y7=-0.1;
x8=0.4;
y8=0.1;
x_1=[x1 x5 x6 x7 x8 x4];
y_1=[y1 y5 y6 y7 y8 y4];
plot(x_1,y_1,'k');
hold on
axis equal;
axis([-1.5 2.5 -2 0.5]);
axis off;
hold off
case 3
set(handles.text21,'string','RP 76; Laves-Netz: 12,12,3; Symmetriegruppe: p6; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2/sin(pi/3);
y2=0;
phi1=pi/6;
x3=cos(phi1)*4;
y3=sin(phi1)*4;
x4=0.3;
y4=0.2;
phi2=-2*pi/3;
x5=cos(phi2)*x4-sin(phi2)*y4+x3;
y5=sin(phi2)*x4+cos(phi2)*y4+y3;
x6=cos(phi1)*3.5+sin(phi1)*0.2;
y6=sin(phi1)*3.5-cos(phi1)*0.2;
x7=cos(phi1)*0.5-sin(phi1)*0.2;
y7=sin(phi1)*0.5+cos(phi1)*0.2;
x8=0;
y8=-4;
phi=2*pi/3;
x9=cos(phi)*x3-sin(phi)*y3;
y9=sin(phi)*x3+cos(phi)*y3;
for k = -1:1:3
for m = -1:1:3
cx=[k*(x8-x1) + m*(x9-x1)];
cy=[k*(y8-y1) + m*(y9-y1)];
for n = 0:1:5
phi=n*pi/3;
x1a=cos(phi)*x1-sin(phi)*y1;
y1a=sin(phi)*x1+cos(phi)*y1;
x4a=cos(phi)*x4-sin(phi)*y4;
y4a=sin(phi)*x4+cos(phi)*y4;
x2a=cos(phi)*x2-sin(phi)*y2;
y2a=sin(phi)*x2+cos(phi)*y2;
x_1=[x1a+cx x4a+cx x2a+cx];
y_1=[y1a+cy y4a+cy y2a+cy];
plot(x_1,y_1,'k');
hold on
end
for n = 0:1:2
phi=2*n*pi/3;
x1a=cos(phi)*x1-sin(phi)*y1;
y1a=sin(phi)*x1+cos(phi)*y1;
x7a=cos(phi)*x7-sin(phi)*y7;
y7a=sin(phi)*x7+cos(phi)*y7;
x6a=cos(phi)*x6-sin(phi)*y6;
y6a=sin(phi)*x6+cos(phi)*y6;
x3a=cos(phi)*x3-sin(phi)*y3;
y3a=sin(phi)*x3+cos(phi)*y3;
x_1=[x1a+cx x7a+cx x6a+cx x3a+cx];
y_1=[y1a+cy y7a+cy y6a+cy y3a+cy];
plot(x_1,y_1,'k');
hold on
end
end
end
axis equal;
axis([-6 4 -6 4]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x4 x2 x5 x3 x6 x7 x1];
y_1=[y1 y4 y2 y5 y3 y6 y7 y1];
fill(x_1,y_1,'w');
axis equal;
axis([-0.5 4 -0.5 2.5]);
axis off;
hold off
end % switch

% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 77' });

% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10
popup_sel_index = get(handles.popupmenu10, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 77; Laves-Netz: 12,4,6; Symmetriegruppe: p6mm; einfaches Parkett, Dirichlet-Parkett');
axes(handles.axes1);
cla;
%Dreiecke:
x1=0;
y1=0;
x2=2;
y2=0;
x3=1;
y3=sqrt(3);
%Sechsecke:
x4=1;
y4=0.333*sqrt(3);
x5=2;
y5=0.667*sqrt(3);
x6=3;
y6=y4;
x7=3;
y7=-y6;
x8=2;
y8=-y5;
x9=1;
y9=-y4;
for k = -1:1:5
for m = -1:1:4
cx=[k*(x2-x1) + m*(x3-x1)];
cy=[k*(y2-y1) + m*(y3-y1)];
x_4=[x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x4+cx];
y_4=[y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y4+cy];
fill(x_4,y_4,'w');
hold on
x_1=[x1+cx x3+cx];
y_1=[y1+cy y3+cy];
plot(x_1,y_1,'k-');
hold on
x_2=[x1+cx x2+cx];
y_2=[y1+cy y2+cy];
plot(x_2,y_2,'k-');
hold on
x_3=[x2+cx x3+cx];
y_3=[y2+cy y3+cy];
plot(x_3,y_3,'k-');
hold on
for n = 1:1:11
phi=n*pi/6;
x10=cos(phi)*x1-sin(phi)*y1;
y10=sin(phi)*x1+cos(phi)*y1;
x11=cos(phi)*x3-sin(phi)*y3;
y11=sin(phi)*x3+cos(phi)*y3;
x12=cos(phi)*x2-sin(phi)*y2;
y12=sin(phi)*x2+cos(phi)*y2;
x_1=[x11+cx x10+cx];
y_1=[y11+cy y10+cy];
plot(x_1,y_1,'k-');
hold on
x_2=[x10+cx x12+cx];
y_2=[y10+cy y12+cy];
plot(x_2,y_2,'k-');
hold on
end
end
end
axis([2.2 7.2 -1 4]);
axis equal;
axis off;
hold off
axes(handles.axes2);
cla;
x1=0;
y1=0;
x2=0;
y2=2;
x3=1;
y3=0;
x_1=[x1 x2 x3 x1];
y_1=[y1 y2 y3 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
end % switch

% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 78', 'RP 79', 'RP 80', 'RP 81', 'RP 82' });

% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11
popup_sel_index = get(handles.popupmenu11, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 78; Laves-Netz: 884; Symmetriegruppe: p4mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=2;
y3=0;
x4=2;
y4=1;
x5=2;
y5=2;
x6=1;
y6=2;
x7=0;
y7=2;
x8=0;
y8=1;
for k = 0:1:3
for m = 0:1:3
cx=[k*(x3-x1) + m*(x7-x1)];
cy=[k*(y3-y1) + m*(y7-y1)];
x_1=[x1+cx x5+cx];
y_1=[y1+cy y5+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x3+cx x7+cx];
y_1=[y3+cy y7+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x2+cx x6+cx];
y_1=[y2+cy y6+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x4+cx x8+cx];
y_1=[y4+cy y8+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x1+cx x3+cx x5+cx x7+cx x1+cx];
y_1=[y1+cy y3+cy y5+cy y7+cy y1+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([0.5 7.5 0.5 7.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=1;
y3=1;
x_1=[x1 x2 x3 x1];
y_1=[y1 y2 y3 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis off;
hold off
case 2
set(handles.text21,'string','RP 79; Laves-Netz: 884; Symmetriegruppe: p4mm. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=2;
y3=0;
x4=2;
y4=1;
x5=2;
y5=2;
x6=1;
y6=2;
x7=0;
y7=2;
x8=0;
y8=1;
x9=0.3;
y9=0;
x10=1.7;
y10=0;
x11=1;
y11=0.7;
x12=1;
y12=-0.7;
for k = 0:1:3
for m = 0:1:3
cx=[k*(x3-x1) + m*(x7-x1)];
cy=[k*(y3-y1) + m*(y7-y1)];
x_1=[x1+cx x5+cx];
y_1=[y1+cy y5+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x3+cx x7+cx];
y_1=[y3+cy y7+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x2+cx x6+cx];
y_1=[y2+cy y6+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x4+cx x8+cx];
y_1=[y4+cy y8+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x1+cx x3+cx x5+cx x7+cx x1+cx];
y_1=[y1+cy y3+cy y5+cy y7+cy y1+cy];
plot(x_1,y_1,'k');
hold on
plot(x9+cx,y9+cy+1,'k.');
hold on
plot(x10+cx,y10+cy+1,'k.');
hold on
plot(x11+cx,y11+cy+1,'k.');
hold on
plot(x12+cx,y12+cy+1,'k.');
hold on
end
end
axis equal;
axis([0.5 7.5 0.5 7.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x1=0;
y1=0;
x2=1;
y2=0;
x3=1;
y3=1;
x_1=[x1 x2 x3 x1];
y_1=[y1 y2 y3 y1];
plot(x_1,y_1,'k');
hold on
plot(x9+0.4,y9,'k.');
hold on
axis equal;
axis off;
hold off
case 3
set(handles.text21,'string','RP 80; Laves-Netz: 884; Symmetriegruppe: p4gm; einfaches Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=-1;
y2=-1;
x3=1;
y3=-1;
x4=0;
y4=-0.2;
phi1=pi/2;
x5=cos(phi1)*x4-sin(phi1)*y4;
y5=sin(phi1)*x4+cos(phi1)*y4;
phi2=2*phi1;
x6=cos(phi2)*x4-sin(phi2)*y4;
y6=sin(phi2)*x4+cos(phi2)*y4;
x7=x3;
y7=-y3;
x8=cos(-phi1)*x4-sin(-phi1)*y4;
y8=sin(-phi1)*x4+cos(-phi1)*y4;
x9=x2;
y9=-y2;
x10=x9;
y10=-3;
for k = 0:1:5
for m = 0:1:4
cx=[k*(x2-x7) + m*(x9-x10)];
cy=[k*(y2-y7) + m*(y9-y10)];
x_1=[x9+cx x8+cx x1+cx x6+cx x7+cx x9+cx x2+cx x3+cx x5+cx x1+cx x4+cx x2+cx];
y_1=[y9+cy y8+cy y1+cy y6+cy y7+cy y9+cy y2+cy y3+cy y5+cy y1+cy y4+cy y2+cy];
plot(x_1,y_1,'k');
hold on
x_1=[x9+cx x8+cx x1+cx x6+cx x7+cx x9+cx x2+cx x3+cx x5+cx x1+cx x4+cx x2+cx];
y_1=[2*y2-y9+cy 2*y2-y8+cy 2*y2-y1+cy 2*y2-y6+cy 2*y2-y7+cy 2*y2-y9+cy 2*y2-y2+cy 2*y2-y3+cy 2*y2-y5+cy 2*y2-y1+cy 2*y2-y4+cy 2*y2-y2+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([-10.7 -2 -4 3.7]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x4 x2 x3 x5 x1];
y_1=[y1 y4 y2 y3 y5 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis([-1.5 1.5 -1.5 0.5]);
axis off;
hold off
case 4
set(handles.text21,'string','RP 81; Laves-Netz: 884; Symmetriegruppe: p4; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0;
y2=-2;
x3=2;
y3=0;
x4=-0.2;
y4=-1.7;
phi=pi/4;
x5=cos(phi)*0.3-sin(phi)*0.2;
y5=sin(phi)*0.3+cos(phi)*0.2+y2;
x6=cos(phi)*2.5+sin(phi)*0.2;
y6=sin(phi)*2.5-cos(phi)*0.2+y2;
x7=1.7;
y7=-0.2;
x8=-x4;
y8=-y4;
x9=0;
y9=-y2;
x10=-x7;
y10=-y7;
x11=-x3;
y11=0;
x12=cos(3*phi)*2.5+sin(3*phi)*0.2;
y12=sin(3*phi)*2.5-cos(3*phi)*0.2+y2;
x13=cos(3*phi)*0.3-sin(3*phi)*0.2;
y13=sin(3*phi)*0.3+cos(3*phi)*0.2+y2;
for k = 1:1:5
for m = 1:1:5
cx=[k*(x2-x11) + m*(x3-x2)];
cy=[k*(y2-y11) + m*(y3-y2)];
x_1=[x9+cx x8+cx x1+cx x10+cx x11+cx x12+cx x13+cx x2+cx x4+cx x1+cx x7+cx x3+cx x6+cx x5+cx x2+cx];
y_1=[y9+cy y8+cy y1+cy y10+cy y11+cy y12+cy y13+cy y2+cy y4+cy y1+cy y7+cy y3+cy y6+cy y5+cy y2+cy];
plot(x_1,y_1,'k');
hold on
end
end
axis equal;
axis([8 16 -4 4]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x3 x7 x1 x4 x2 x5 x6 x3];
y_1=[y3 y7 y1 y4 y2 y5 y6 y3];
plot(x_1,y_1,'k');
hold on
axis equal;
axis([-0.5 2.5 -2.5 0.5]);
axis off;
hold off
case 5
set(handles.text21,'string','RP 82; Laves-Netz: 884; Symmetriegruppe: c2mm; einfaches Parkett, Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=-2;
x3=2;
y3=0;
x4=4;
y4=0;
x5=4;
y5=-2;
x6=1.5;
y6=-1.1;
x7=0.5;
y7=-0.9;
x8=x3+x7;
y8=y6;
x9=x3+x6;
y9=y7;
for k = 1:1:6
for m = 1:1:8
cx=[k*(x2-x1) + m*(x4-x2)];
cy=[k*(y2-y1) + m*(y4-y2)];
x_1=[x5+cx x4+cx x3+cx x1+cx x6+cx x7+cx x2+cx x9+cx x8+cx x4+cx];
y_1=[y5+cy y4+cy y3+cy y1+cy y6+cy y7+cy y2+cy y9+cy y8+cy y4+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x2+cx x3+cx];
y_2=[y2+cy y3+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis equal;
axis([11.5 20.5 -4.5 4.5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x3 x1 x6 x7 x2 x3];
y_1=[y3 y1 y6 y7 y2 y3];
plot(x_1,y_1,'k');
hold on
axis equal;
axis([-0.5 2.5 -2.5 0.5]);
axis off;
hold off
end % switch

% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

set(hObject, 'String', {'RP 83', 'RP 84', 'RP 85', 'RP 86', 'RP 87', 'RP 88', 'RP 89', 'RP 90', 'RP 91', 'RP 92', 'RP 93' });

% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12
popup_sel_index = get(handles.popupmenu12, 'Value');
switch popup_sel_index
case 1
set(handles.text21,'string','RP 83; Laves-Netz: 666; Symmetriegruppe: p6mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=1;
y3=sqrt(3);
for k = -2:1:4
for m = -2:1:4
cx=[k*(x2-x1) + m*(x3-x1)];
cy=[k*(y2-y1) + m*(y3-y1)];
x_1=[x1+cx x3+cx];
y_1=[y1+cy y3+cy];
plot(x_1,y_1,'k-');
hold on
x_2=[x1+cx x2+cx];
y_2=[y1+cy y2+cy];
plot(x_2,y_2,'k-');
hold on
x_3=[x2+cx x3+cx];
y_3=[y2+cy y3+cy];
plot(x_3,y_3,'k-');
hold on
end
end
axis equal;
axis([-1.25 6.25 -2 5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x3];
y_1=[y1 y3];
plot(x_1,y_1,'k-');
hold on
x_2=[x1 x2];
y_2=[y1 y2];
plot(x_2,y_2,'k-');
hold on
x_3=[x2 x3];
y_3=[y2 y3];
plot(x_3,y_3,'k-');
axis equal;
axis off;
hold off
case 2
set(handles.text21,'string','RP 84; Laves-Netz: 666; Symmetriegruppe: p6mm. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=1;
y3=sqrt(3);
x4=0.3;
y4=0;
x5=1.1;
y5=1.5;
x6=2.9;
y6=1.5;
x7=3.7;
y7=0;
x8=x5;
y8=-y5;
x9=x6;
y9=-y6;
for k = -2:1:4
for m = -2:1:4
cx=[k*(x2-x1) + m*(x3-x1)];
cy=[k*(y2-y1) + m*(y3-y1)];
x_1=[x1+cx x3+cx];
y_1=[y1+cy y3+cy];
plot(x_1,y_1,'k-');
hold on
x_2=[x1+cx x2+cx];
y_2=[y1+cy y2+cy];
plot(x_2,y_2,'k-');
hold on
x_3=[x2+cx x3+cx];
y_3=[y2+cy y3+cy];
plot(x_3,y_3,'k-');
hold on
end
end
x10=4;
y10=0;
for k=-1:1:2
for m=-1:1:2
cx=[k*(x3-x10)];
cy=[k*(y3-y10)+m*2*y3];
plot(x4+cx,y4+cy,'k.');
hold on
plot(x5+cx,y5+cy,'k.');
hold on
plot(x6+cx,y6+cy,'k.');
hold on
plot(x7+cx,y7+cy,'k.');
hold on
plot(x8+cx,y8+cy,'k.');
hold on
plot(x9+cx,y9+cy,'k.');
hold on
end 
end
axis equal;
axis([-1.25 6.25 -2 5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x3];
y_1=[y1 y3];
plot(x_1,y_1,'k-');
hold on
x_2=[x1 x2];
y_2=[y1 y2];
plot(x_2,y_2,'k-');
hold on
x_3=[x2 x3];
y_3=[y2 y3];
plot(x_3,y_3,'k-');
hold on
plot(x4,y4,'k.');
hold on
plot(x5,y5,'k.');
axis equal;
axis off;
hold off
case 3
set(handles.text21,'string','RP 85; Laves-Netz: 666; Symmetriegruppe: p3m1. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=1;
y3=sqrt(3);
x4=0.3;
y4=0;
x6=2.9;
y6=1.5;
x8=1.1;
y8=-1.5;
x9=x6;
y9=-y6;
for k = -2:1:4
for m = -2:1:4
cx=[k*(x2-x1) + m*(x3-x1)];
cy=[k*(y2-y1) + m*(y3-y1)];
x_1=[x1+cx x3+cx];
y_1=[y1+cy y3+cy];
plot(x_1,y_1,'k-');
hold on
x_2=[x1+cx x2+cx];
y_2=[y1+cy y2+cy];
plot(x_2,y_2,'k-');
hold on
x_3=[x2+cx x3+cx];
y_3=[y2+cy y3+cy];
plot(x_3,y_3,'k-');
hold on
end
end
x10=4;
y10=0;
for k=-1:1:2
for m=-1:1:2
cx=[k*(x3-x10)];
cy=[k*(y3-y10)+m*2*y3];
plot(x4+cx,y4+cy,'k.');
hold on
plot(x6+cx,y6+cy,'k.');
hold on
plot(x9+cx,y9+cy,'k.');
hold on
end 
end
axis equal;
axis([-1.25 6.25 -2 5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x3];
y_1=[y1 y3];
plot(x_1,y_1,'k-');
hold on
x_2=[x1 x2];
y_2=[y1 y2];
plot(x_2,y_2,'k-');
hold on
x_3=[x2 x3];
y_3=[y2 y3];
plot(x_3,y_3,'k-');
hold on
plot(x4,y4,'k.');
hold on
axis equal;
axis off;
hold off
case 4
set(handles.text21,'string','RP 86; Laves-Netz: 666; Symmetriegruppe p31m. Zu dieser Kombination gibt es nur markierte Parkette.');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=1;
y3=sqrt(3);
x4=1.7;
y4=0;
x5=1.1;
y5=1.5;
x6=2.1;
y6=0.2;
x7=3.7;
y7=0;
x8=x5;
y8=-y5;
x9=x6;
y9=-y6;
for k = -2:1:4
for m = -2:1:4
cx=[k*(x2-x1) + m*(x3-x1)];
cy=[k*(y2-y1) + m*(y3-y1)];
x_1=[x1+cx x3+cx];
y_1=[y1+cy y3+cy];
plot(x_1,y_1,'k-');
hold on
x_2=[x1+cx x2+cx];
y_2=[y1+cy y2+cy];
plot(x_2,y_2,'k-');
hold on
x_3=[x2+cx x3+cx];
y_3=[y2+cy y3+cy];
plot(x_3,y_3,'k-');
hold on
end
end
x10=2;
y10=0;
for k=-5:1:3
for m=-5:1:3
cx=[k*(x3-x10)];
cy=[k*(y3-y10)+m*2*y3];
plot(x4+cx,y4+cy,'k.');
hold on
plot(x5+cx,y5+cy,'k.');
hold on
plot(x6+cx,y6+cy,'k.');
hold on
plot(x7+cx,y7+cy,'k.');
hold on
plot(x8+cx,y8+cy,'k.');
hold on
plot(x9+cx,y9+cy,'k.');
hold on
end 
end
axis equal;
axis([-1.25 6.25 -2 5]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x3];
y_1=[y1 y3];
plot(x_1,y_1,'k-');
hold on
x_2=[x1 x2];
y_2=[y1 y2];
plot(x_2,y_2,'k-');
hold on
x_3=[x2 x3];
y_3=[y2 y3];
plot(x_3,y_3,'k-');
hold on
plot(x4,y4,'k.');
hold on
plot(x5,y5,'k.');
hold on
x11=0.2;
y11=0.3;
plot(x11,y11,'k.');
axis equal;
axis off;
hold off
case 5
set(handles.text21,'string','RP 87; Laves-Netz: 666; Symmetriegruppe: p6');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=0.1;
y2=0.1;
x3=0.9;
y3=-0.1;
x4=1;
y4=0;
x5=1+(cos(2*pi/3)*x2-sin(2*pi/3)*y2);
y5=sin(2*pi/3)*x2+cos(2*pi/3)*y2;
x6=1+(cos(2*pi/3)*x3-sin(2*pi/3)*y3);
y6=sin(2*pi/3)*x3+cos(2*pi/3)*y3;
x7=0.5;
y7=sin(pi/3)*x4+cos(pi/3)*y4;
x8=cos(pi/3)*x3-sin(pi/3)*y3;
y8=sin(pi/3)*x3+cos(pi/3)*y3;
x9=cos(pi/3)*x2-sin(pi/3)*y2;
y9=sin(pi/3)*x2+cos(pi/3)*y2;
for k = -3:1:2
for m = -3:1:2
cx=[k*(x4-x1) + m*(x7-x4)];
cy=[k*(y4-y1) + m*(y7-y4)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal
axis([-2 2 -2 2]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y1];
fill(x_1,y_1,'w');
axis equal;
axis([-0.25 1.25 -0.25 1.25]);
axis off;
hold off
case 6
set(handles.text21,'string','RP 88; Laves-Netz: 666; Symmetriegruppe: p6; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=1;
y1=0;
x2=0.2;
y2=0;
x3=0.1;
y3=-0.1;
x4=0;
y4=0;
x5=0.21*cos(pi/3)+0.1*sin(pi/3);
y5=-0.1*cos(pi/3)+0.21*sin(pi/3);
x6=0.79*cos(pi/3)-0.1*sin(pi/3);
y6=0.79*sin(pi/3)+0.1*cos(pi/3);
x7=0.5;
y7=sin(pi/3)*x1+cos(pi/3)*y1;
x8=x3*cos(5*pi/3)-y3*sin(5*pi/3)+x7;
y8=x3*sin(5*pi/3)+y3*cos(5*pi/3)+y7;
x9=x2*cos(5*pi/3)-y2*sin(5*pi/3)+x7;
y9=x2*sin(5*pi/3)+y2*cos(5*pi/3)+y7;

ax=cos(2*pi/3)*x7-sin(2*pi/3)*y7;
ay=sin(2*pi/3)*x7+cos(2*pi/3)*y7;
bx=cos(4*pi/3)*x7-sin(4*pi/3)*y7;
by=sin(4*pi/3)*x7+cos(4*pi/3)*y7;

for k = 0:1:4
for m = -1:1:3
cx=[k*(ax-bx) + m*(ax-x7)];
cy=[k*(ay-by) + m*(ay-y7)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y1+cy];
plot(x_1,y_1,'k');
hold on
for n = 1:1:2
phi=2*n*pi/3;
x10=cos(phi)*x3-sin(phi)*y3;
y10=sin(phi)*x3+cos(phi)*y3;
x11=cos(phi)*x2-sin(phi)*y2;
y11=sin(phi)*x2+cos(phi)*y2;
x12=cos(phi)*x1-sin(phi)*y1;
y12=sin(phi)*x1+cos(phi)*y1;
x_2=[x4+cx x10+cx x11+cx x12+cx];
y_2=[y4+cy y10+cy y11+cy y12+cy];
plot(x_2,y_2,'k');
hold on
x13=cos(phi)*x7-sin(phi)*y7;
y13=sin(phi)*x7+cos(phi)*y7;
x14=cos(phi)*x6-sin(phi)*y6;
y14=sin(phi)*x6+cos(phi)*y6;
x15=cos(phi)*x5-sin(phi)*y5;
y15=sin(phi)*x5+cos(phi)*y5;
x_2=[x4+cx x15+cx x14+cx x13+cx];
y_2=[y4+cy y15+cy y14+cy y13+cy];
plot(x_2,y_2,'k');
hold on
x16=cos(phi)*x8-sin(phi)*y8;
y16=sin(phi)*x8+cos(phi)*y8;
x17=cos(phi)*x9-sin(phi)*y9;
y17=sin(phi)*x9+cos(phi)*y9;
x_3=[x12+cx x17+cx x16+cx x13+cx];
y_3=[y12+cy y17+cy y16+cy y13+cy];
plot(x_3,y_3,'k');
hold on
end
end
end
axis equal
axis([-7 -2 -2 3]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y1];
fill(x_1,y_1,'w');
axis equal;
axis([-0.25 1.25 -0.25 1.25]);
axis off;
hold off
case 7
set(handles.text21,'string','RP 89; Laves-Netz: 666; Symmetriegruppe: c2mm; Dirichlet-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=0;
x3=1;
y3=0.75;
for k = -2:1:4
for m = -2:1:4
cx=[k*(x2-x1) + m*(x3-x1)];
cy=[k*(y2-y1) + m*(y3-y1)];
x_1=[x1+cx x2+cx];
y_1=[y1+cy y2+cy];
plot(x_1,y_1,'k-');
hold on
x_2=[x1+cx x3+cx];
y_2=[y1+cy y3+cy];
plot(x_2,y_2,'k-');
hold on
x_3=[x3+cx x2+cx];
y_3=[y3+cy y2+cy];
plot(x_3,y_3,'k-');
hold on
end
end
axis([0.5 4.5 0 3]);
axis equal;
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x1];
y_1=[y1 y2 y3 y1];
fill(x_1,y_1,'w');
axis([-0.25 2.25 -0.25 1]);
axis equal;
axis off;
hold off
case 8
set(handles.text21,'string','RP 90; Laves-Netz: 666; Symmetriegruppe: p2mg; einfaches Parkett, Dirichlet-Parkett');
axes(handles.axes1);
cla;
phi=2*pi/3;
x1=0;
y1=0;
x2=0.2;
y2=0.2;
x3=0.8;
y3=-0.2;
x4=1;
y4=0;
x5=0.4*cos(phi)+x4;
y5=0.4*sin(phi);
x6=0.6*cos(phi)+0.2*sin(phi)+x4;
y6=0.6*sin(phi)-0.2*cos(phi);
x7=0.8*cos(phi)+x4;
y7=0.8*sin(phi);
x8=1.2*cos(phi)+x4;
y8=1.2*sin(phi);
x9=1.4*cos(phi)-0.2*sin(phi)+x4;
y9=1.4*sin(phi)+0.2*cos(phi);
x10=1.6*cos(phi)+x4;
y10=1.6*sin(phi);
x11=0;
y11=2*sin(phi);
x12=-x10;
y12=y10;
x13=-x9;
y13=y9;
x14=-x8;
y14=y8;
x15=-x7;
y15=y7;
x16=-x6;
y16=y6;
x17=-x5;
y17=y5;
x18=-x4;
y18=y4;
x19=-x3;
y19=y3;
x20=-x2;
y20=y2;
x21=-x4;
y21=y11+y18;
for k = -2:1:3
for m = -2:1:3
cx=[k*(x11-x1) + m*(x18-x4)];
cy=[k*(y11-y1) + m*(y18-y4)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x13+cx x14+cx x15+cx x16+cx x17+cx x18+cx x21+cx x18+cx x19+cx x20+cx x1+cx x11+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y13+cy y14+cy y15+cy y16+cy y17+cy y18+cy y21+cy y18+cy y19+cy y20+cy y1+cy y11+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis([-2.5 2.5 -2.5 2.5]);
axis equal;
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y1];
fill(x_1,y_1,'w');
axis([-0.25 1.75 -0.25 2.25]);
axis equal;
axis off;
hold off
case 9
set(handles.text21,'string','RP 91; Laves-Netz: 666; Symmetriegruppe: p2gg; einfaches Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
x1=0;
y1=0;
x2=2;
y2=1;
x3=0;
y3=2;
x4=0.5;
y4=0;
x5=1.5;
y5=1;
x6=0.2;
y6=0.7;
x7=-0.2;
y7=1.3;
x8=-x4;
y8=y3;
x9=-x2;
y9=y2;
x10=-x5;
y10=y5;
x11=x2+0.2;
y11=y2+y7;
x12=x2-0.2;
y12=y2+y6;
x13=x2;
y13=y2+y3;
for k = 1:1:7
for m = 0:1:3
cx=[k*(x3-x1) + m*(x13-x9)];
cy=[k*(y3-y1) + m*(y13-y9)];
x_1=[x13+cx x12+cx x11+cx x2+cx x5+cx x3+cx x8+cx x9+cx x10+cx x1+cx x4+cx x2+cx];
y_1=[y13+cy y12+cy y11+cy y2+cy y5+cy y3+cy y8+cy y9+cy y10+cy y1+cy y4+cy y2+cy];
plot(x_1,y_1,'k');
hold on
x_2=[x1+cx x7+cx x6+cx x3+cx];
y_2=[y1+cy y7+cy y6+cy y3+cy];
plot(x_2,y_2,'k');
hold on
end
end
axis equal;
axis([0 8 8 16]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x4 x2 x5 x3 x6 x7 x1];
y_1=[y1 y4 y2 y5 y3 y6 y7 y1];
plot(x_1,y_1,'k');
hold on
axis equal;
axis([-0.5 2.5 -0.5 2.5]);
axis off;
hold off
case 10
set(handles.text21,'string','RP 92; Laves-Netz: 666; Symmetriegruppe: cm; einfaches Parkett');
axes(handles.axes1);
cla;
phi=pi/4;
x1=0;
y1=0;
x2=2;
y2=0;
x6=1;
y6=sin(phi);
x7=cos(phi)*0.4;
y7=sin(phi)*0.4;
x8=cos(phi)*0.3+sin(phi)*0.1;
y8=sin(phi)*0.3-cos(phi)*0.1;
x9=cos(phi)*0.2;
y9=sin(phi)*0.2;
x3=cos(-phi)*0.4+x6;
y3=sin(-phi)*0.4+y6;
x4=cos(-phi)*0.3+sin(-phi)*0.1+x6;
y4=sin(-phi)*0.3-cos(-phi)*0.1+y6;
x5=cos(-phi)*0.2+x6;
y5=sin(-phi)*0.2+y6;
for k = -3:1:2
for m = -3:1:2
cx=[k*(x6-x1) + m*(x6-x2)];
cy=[k*(y6-y1) + m*(y6-y2)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal;
axis([-2.25 3.25 -3 2]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y1];
fill(x_1,y_1,'w');
axis equal;
axis([-0.25 2.25 -0.25 1.5]);
axis off;
hold off
case 11
set(handles.text21,'string','RP 93; Laves-Netz: 666; Symmetriegruppe: p2; einfaches Parkett, Dirichlet-Parkett, Escher-Parkett');
axes(handles.axes1);
cla;
phi=-pi/5;
phi1=0.73;
x1=0;
y1=0;
x2=0.3;
y2=0.2;
x3=2.7;
y3=-y2;
x4=3;
y4=0;
x5=-0.2*cos(phi)+x4;
y5=-0.2*sin(phi);
x6=-0.2*cos(phi)+0.1*sin(phi)+x4;
y6=-0.2*sin(phi)-0.1*cos(phi);
x7=-0.4*cos(phi)+0.1*sin(phi)+x4;
y7=-0.4*sin(phi)-0.1*cos(phi);
x8=-0.4*cos(phi)+x4;
y8=-0.4*sin(phi);
x9=-1.6*cos(phi)+x4;
y9=-1.6*sin(phi);
x10=-1.6*cos(phi)-0.1*sin(phi)+x4;
y10=-1.6*sin(phi)+0.1*cos(phi);
x11=-1.8*cos(phi)-0.1*sin(phi)+x4;
y11=-1.8*sin(phi)+0.1*cos(phi);
x12=-1.8*cos(phi)+x4;
y12=-1.8*sin(phi);
x13=-2*cos(phi)+x4;
y13=-2*sin(phi);
x14=1.5*cos(phi1)+0.2*sin(phi1);
y14=1.5*sin(phi1)-0.2*cos(phi1);
x15=0.35*cos(phi1)-0.2*sin(phi1);
y15=0.35*sin(phi1)+0.2*cos(phi1);
for k = -5:1:3
for m = -5:1:3
cx=[k*(x13-x1) + m*(x4-x1)];
cy=[k*(y13-y1) + m*(y4-y1)];
x_1=[x1+cx x2+cx x3+cx x4+cx x5+cx x6+cx x7+cx x8+cx x9+cx x10+cx x11+cx x12+cx x13+cx x14+cx x15+cx x1+cx];
y_1=[y1+cy y2+cy y3+cy y4+cy y5+cy y6+cy y7+cy y8+cy y9+cy y10+cy y11+cy y12+cy y13+cy y14+cy y15+cy y1+cy];
fill(x_1,y_1,'w');
hold on
end
end
axis equal;
axis([-2 6 -3 4.25]);
axis off;
hold off
axes(handles.axes2);
cla;
x_1=[x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x1];
y_1=[y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y1];
fill(x_1,y_1,'w');
axis([-0.25 3.25 -0.25 2]);
axis equal;
axis off;
hold off
end % switch

% set(handles.text21,'string','RP ; Laves-Netz: ; Symmetriegruppe: ');
% x1=;
% y1=;
% x2=;
% y2=;
% x3=;
% y3=;
% x4=;
% y4=;
% x5=;
% y5=;
% x6=;
% y6=;
% x7=;
% y7=;
% x8=;
% y8=;
% x9=;
% y9=;
% for k = 1:1:1
% for m = 1:1:1
% cx=[k*(x1-x1) + m*(x1-x1)];
% cy=[k*(y1-y1) + m*(y1-y1)];
% x_1=[x1+cx x2+cx x3+cx x1+cx];
% y_1=[y1+cy y2+cy y3+cy y1+cy];
% fill(x_1,y_1,'w');
% hold on
% x_2=[x1+cx x2+cx];
% y_2=[y1+cy y2+cy];
% plot(x_2,y_2,'k-');
% hold on
% end
% end
% axis equal;
% axis([-1.25 6.25 -2 4]);
% axis off;





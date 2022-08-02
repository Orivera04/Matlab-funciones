function varargout = Graficas3d(varargin)
% GRAFICAS3D M-file for Graficas3d.fig
%      GRAFICAS3D, by itself, creates a new GRAFICAS3D or raises the existing
%      singleton*.
%
%      H = GRAFICAS3D returns the handle to a new GRAFICAS3D or the handle to
%      the existing singleton*.
%
%      GRAFICAS3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRAFICAS3D.M with the given input arguments.
%
%      GRAFICAS3D('Property','Value',...) creates a new GRAFICAS3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Graficas3d_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Graficas3d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Graficas3d

% Last Modified by GUIDE v2.5 22-Sep-2010 18:28:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Graficas3d_OpeningFcn, ...
                   'gui_OutputFcn',  @Graficas3d_OutputFcn, ...
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

% --- Executes just before Graficas3d is made visible.
function Graficas3d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Graficas3d (see VARARGIN)

%Centrar Ventana
scrsz = get(0, 'ScreenSize');
pos_act=get(gcf,'Position');
xr=scrsz(3) - pos_act(3);
xp=round(xr/2);
yr=scrsz(4) - pos_act(4);
yp=round(yr/2);
set(gcf,'Position',[xp yp pos_act(3) pos_act(4)]);

axes(handles.logo)
img1=imread('logo.jpg');
imshow(img1);

% Choose default command line output for Graficas3d
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Graficas3d wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Graficas3d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    func=get(handles.edit1,'String');
    axes(handles.grafica)
    ezmesh(func),xlabel('Eje X'),ylabel('Eje Y'),zlabel('Eje Z');
catch
    MsgBox('Error al Tratar de Graficar','Graficas de Funciones en 3D');
    close Graficas3D
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opcion=get(handles.popupmenu1,'Value');
    switch(opcion)
        case    2
            axes(handles.grafica)
            sphere,axis square;
        case 3
            axes(handles.grafica)
            [X,Y,Z] = peaks(30);
            surfc(X,Y,Z)
            colormap hsv
            axis([-3 3 -3 3 -10 5])
    end
% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
func=get(handles.edit1,'String');
opcion2=get(handles.popupmenu2,'Value');
    switch(opcion2)
        case    2
            axes(handles.grafica)
            ezmeshc(func);
        case 3
            axes(handles.grafica)
            ezsurf(func);
        case 4
            axes(handles.grafica)
            ezsurfc(func);
        case 5
            axes(handles.grafica)
            ezmesh(func),xlabel('Eje X'),ylabel('Eje Y'),zlabel('Eje Z'),hidden off;
        case 6
            axes(handles.grafica)
            ezmesh(func),colormap([0 0 1]);
        case 7         
            xrang=str2double(Inputdlg('Ingrese el Xrang','Graficas en 3D'));
            yrang=str2double(Inputdlg('Ingrese el Yrang','Graficas en 3D'));
            axes(handles.grafica)
            ezmesh(func,[-xrang,xrang],[-yrang,yrang]);
        case 8
            [x,y]=meshgrid(-5:0.1:5);
            f=5-x.^2-y.^2;
            axes(handles.grafica)
            contour(f);
    end
catch
    MsgBox('No se puede Graficar la Funcion','Graficas de Funciones en 3D');
end

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


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



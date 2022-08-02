function varargout = GUIdemo(varargin)
% GUIDEMO M-file for GUIdemo.fig
%      GUIDEMO, by itself, creates a new GUIDEMO or raises the existing
%      singleton*.
%
%      H = GUIDEMO returns the handle to a new GUIDEMO or the handle to
%      the existing singleton*.
%
%      GUIDEMO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIDEMO.M with the given input arguments.
%
%      GUIDEMO('Property','Value',...) creates a new GUIDEMO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIdemo_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIdemo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIdemo

% Last Modified by GUIDE v2.5 01-Mar-2004 16:27:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUIdemo_OpeningFcn, ...
                   'gui_OutputFcn',  @GUIdemo_OutputFcn, ...
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


% --- Executes just before GUIdemo is made visible.
function GUIdemo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIdemo (see VARARGIN)

% Choose default command line output for GUIdemo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIdemo wait for user response (see UIRESUME)
% uiwait(handles.figure1);
image_file = get(handles.inEdit,'String');
if ~isempty(image_file)
im_original=imread(char(image_file));
set(handles.newIm,'HandleVisibility','OFF');
set(handles.orgIm,'HandleVisibility','ON');
axes(handles.orgIm);
image(im_original);
axis equal;
axis tight;
axis off;
set(handles.orgIm,'HandleVisibility','OFF');
end;

% --- Outputs from this function are returned to the command line.
function varargout = GUIdemo_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


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



% --- Executes during object creation, after setting all properties.
function inEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function inEdit_Callback(hObject, eventdata, handles)
% hObject    handle to inEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inEdit as text
%        str2double(get(hObject,'String')) returns contents of inEdit as a double


% --- Executes on button press in loadPush.
function loadPush_Callback(hObject, eventdata, handles)
% hObject    handle to loadPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image_file = get(handles.inEdit,'String');
if ~isempty(image_file)
im_original=imread(char(image_file));
set(handles.newIm,'HandleVisibility','OFF');
set(handles.orgIm,'HandleVisibility','ON');
axes(handles.orgIm);
image(im_original);
axis equal;
axis tight;
axis off;
set(handles.orgIm,'HandleVisibility','OFF');
end;
% --- Executes on button press in transfCheck.
function transfCheck_Callback(hObject, eventdata, handles)
% hObject    handle to transfCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of transfCheck


% --- Executes during object creation, after setting all properties.
function intSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to intSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function intSlider_Callback(hObject, eventdata, handles)
% hObject    handle to intSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
t = get(handles.intSlider,'value');
set(handles.valText,'String',num2str(t));

% --- Executes on button press in appPush.
function appPush_Callback(hObject, eventdata, handles)
% hObject    handle to appPush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Flag = get(handles.transfCheck,'value');%This flag is to indicate if the check box is selected.
scale = get(handles.intSlider,'value');
image_file = get(handles.inEdit,'String');
orim=imread(char(image_file));

orim = double(orim);

if Flag == 0 %Display color image

    nim = orim*scale;
    nim = (nim <=255 ).*nim + (nim>255)*255;
    set(handles.newIm,'HandleVisibility','OFF'); 
    set(handles.orgIm,'HandleVisibility','ON');
    axes(handles.orgIm);
    image(orim/255);
    axis equal;
    axis tight;
    axis off;
    set(handles.orgIm,'HandleVisibility','OFF');
    set(handles.orgIm,'HandleVisibility','OFF'); 
    set(handles.newIm,'HandleVisibility','ON');
    axes(handles.newIm);
    m = max(max(max(nim)));
    if m>255
        t = m;
    else t = 255;
    end;
    image(nim/t);
    axis equal;
    axis tight;
    axis off;
    set(handles.newIm,'HandleVisibility','OFF');
else
    im = floor((orim(:,:,1)+orim(:,:,2)+orim(:,:,3))/3);
    set(handles.newIm,'HandleVisibility','OFF');
    set(handles.orgIm,'HandleVisibility','ON'); 
    axes(handles.orgIm);
    image(im);
    colormap(gray(256));
    axis equal;
    axis tight;
    axis off;
    set(handles.orgIm,'HandleVisibility','OFF');
    
    nim = im*scale;
    nim = (nim>255)*255+(nim<=255 & nim>0).*nim;
    set(handles.newIm,'HandleVisibility','ON');
    axes(handles.newIm);
     image(nim);
    colormap(gray(256));
    axis equal;
    axis tight;
    axis off;
    set(handles.newIm,'HandleVisibility','OFF');
end;


% --- Executes on button press in closePush.
function closePush_Callback(hObject, eventdata, handles)
% hObject    handle to closePush (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;


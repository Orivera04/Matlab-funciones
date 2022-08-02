function varargout = Exemplo1(varargin)
% EXEMPLO1 M-file for Exemplo1.fig
%      EXEMPLO1, by itself, creates a new EXEMPLO1 or raises the existing
%      singleton*.
%
%      H = EXEMPLO1 returns the handle to a new EXEMPLO1 or the handle to
%      the existing singleton*.
%
%      EXEMPLO1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXEMPLO1.M with the given input arguments.
%
%      EXEMPLO1('Property','Value',...) creates a new EXEMPLO1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Exemplo1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Exemplo1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Exemplo1

% Last Modified by GUIDE v2.5 08-Jun-2004 16:01:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Exemplo1_OpeningFcn, ...
                   'gui_OutputFcn',  @Exemplo1_OutputFcn, ...
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


% --- Executes just before Exemplo1 is made visible.
function Exemplo1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Exemplo1 (see VARARGIN)

% Choose default command line output for Exemplo1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Exemplo1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Exemplo1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function grau_Callback(hObject, eventdata, handles)
% hObject    handle to grau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of grau as text
%        str2double(get(hObject,'String')) returns contents of grau as a double


% --- Executes during object creation, after setting all properties.
function grau_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grau (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in arquivo.
function arquivo_Callback(hObject, eventdata, handles)
% hObject    handle to arquivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns arquivo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from arquivo


% --- Executes during object creation, after setting all properties.
function arquivo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arquivo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



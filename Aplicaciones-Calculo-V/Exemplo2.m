function varargout = Exemplo2(varargin)
% EXEMPLO2 M-file for Exemplo2.fig
%      EXEMPLO2, by itself, creates a new EXEMPLO2 or raises the existing
%      singleton*.
%
%      H = EXEMPLO2 returns the handle to a new EXEMPLO2 or the handle to
%      the existing singleton*.
%
%      EXEMPLO2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXEMPLO2.M with the given input arguments.
%
%      EXEMPLO2('Property','Value',...) creates a new EXEMPLO2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Exemplo2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Exemplo2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help Exemplo2

% Last Modified by GUIDE v2.5 08-Jun-2004 16:04:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Exemplo2_OpeningFcn, ...
                   'gui_OutputFcn',  @Exemplo2_OutputFcn, ...
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


% --- Executes just before Exemplo2 is made visible.
function Exemplo2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Exemplo2 (see VARARGIN)

% Choose default command line output for Exemplo2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Exemplo2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Exemplo2_OutputFcn(hObject, eventdata, handles) 
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



function varargout = exercicios_propostos_08_a(varargin)
% EXERCICIOS_PROPOSTOS_08_A M-file for exercicios_propostos_08_a.fig
%      EXERCICIOS_PROPOSTOS_08_A, by itself, creates a new EXERCICIOS_PROPOSTOS_08_A or raises the existing
%      singleton*.
%
%      H = EXERCICIOS_PROPOSTOS_08_A returns the handle to a new EXERCICIOS_PROPOSTOS_08_A or the handle to
%      the existing singleton*.
%
%      EXERCICIOS_PROPOSTOS_08_A('Property','Value',...) creates a new EXERCICIOS_PROPOSTOS_08_A using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to exercicios_propostos_08_a_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      EXERCICIOS_PROPOSTOS_08_A('CALLBACK') and EXERCICIOS_PROPOSTOS_08_A('CALLBACK',hObject,...) call the
%      local function named CALLBACK in EXERCICIOS_PROPOSTOS_08_A.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help exercicios_propostos_08_a

% Last Modified by GUIDE v2.5 13-Aug-2002 11:56:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @exercicios_propostos_08_a_OpeningFcn, ...
                   'gui_OutputFcn',  @exercicios_propostos_08_a_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    varargout{1:nargout} = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before exercicios_propostos_08_a is made visible.
function exercicios_propostos_08_a_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for exercicios_propostos_08_a
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes exercicios_propostos_08_a wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = exercicios_propostos_08_a_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function V1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function V1_Callback(hObject, eventdata, handles)
% hObject    handle to V1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V1 as text
%        str2double(get(hObject,'String')) returns contents of V1 as a double


% --- Executes during object creation, after setting all properties.
function V2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to V2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function V2_Callback(hObject, eventdata, handles)
% hObject    handle to V2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of V2 as text
%        str2double(get(hObject,'String')) returns contents of V2 as a double


% --- Executes during object creation, after setting all properties.
function R1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function R1_Callback(hObject, eventdata, handles)
% hObject    handle to R1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R1 as text
%        str2double(get(hObject,'String')) returns contents of R1 as a double


% --- Executes during object creation, after setting all properties.
function R2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function R2_Callback(hObject, eventdata, handles)
% hObject    handle to R2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R2 as text
%        str2double(get(hObject,'String')) returns contents of R2 as a double


% --- Executes during object creation, after setting all properties.
function R3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function R3_Callback(hObject, eventdata, handles)
% hObject    handle to R3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R3 as text
%        str2double(get(hObject,'String')) returns contents of R3 as a double


% --- Executes during object creation, after setting all properties.
function R4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function R4_Callback(hObject, eventdata, handles)
% hObject    handle to R4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R4 as text
%        str2double(get(hObject,'String')) returns contents of R4 as a double


% --- Executes during object creation, after setting all properties.
function R5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to R5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function R5_Callback(hObject, eventdata, handles)
% hObject    handle to R5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of R5 as text
%        str2double(get(hObject,'String')) returns contents of R5 as a double



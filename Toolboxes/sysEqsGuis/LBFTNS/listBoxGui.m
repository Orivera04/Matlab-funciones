function varargout = listBoxGui(varargin)
% LISTBOXGUI M-file for listBoxGui.fig
%      LISTBOXGUI, by itself, creates a new LISTBOXGUI or raises the existing
%      singleton*.
%
%      H = LISTBOXGUI returns the handle to a new LISTBOXGUI or the handle to
%      the existing singleton*.
%
%      LISTBOXGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in LISTBOXGUI.M with the given input arguments.
%
%      LISTBOXGUI('Property','Value',...) creates a new LISTBOXGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before listBoxGui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to listBoxGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help listBoxGui

% Last Modified by GUIDE v2.5 06-May-2007 21:51:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @listBoxGui_OpeningFcn, ...
                   'gui_OutputFcn',  @listBoxGui_OutputFcn, ...
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


% --- Executes just before listBoxGui is made visible.
function listBoxGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to listBoxGui (see VARARGIN)

% Choose default command line output for listBoxGui
%Create an easy translation from a matrix into a string matrix for the
%listbox
handles.output = hObject;
handles.ithColVal=0;
handles.ithCol=1;
handles.ithRow=1;
handles.transMat=zeros(5,5);
bl=getMat2BlStr(handles.transMat);
set(handles.TransMat2Str_LB,'string',bl);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%Show the system of Equations
%if you're not importing the string from a load ftn you should do the following
%put each in a cell
constStr=[{'x=1'} {'y=2'} {'z=3'}]';
ftnStr=[{'a1=x*y+a0-z'} {'c1=y*z+c0+a0'}]';
%make each cell a string
constStr=char(constStr);
ftnStr=char(ftnStr);
sysEq=showEq(ftnStr,constStr);
handles.blFtnText=ftnStr;
handles.sysFtns=sysEq;
set(handles.sysEquations_Static,'string',sysEq);

%initialize their initial conditions 
ICStr=[{'c0'} {'a0'}]';
ICStr=char(ICStr);
handles.ICStr=ICStr;
handles.ICVal=[1 1]';
v=handles.ICVal;
handles.numIter=5;
%final task debug this!
for(i=1:handles.numIter)
    iter(i,:)=getNextIter(handles.sysFtns,handles.ICStr,v);
    %v's just a dummyHolder for updating iter
    v=iter(i,:);
end
res=[(1:5)' iter];
blMat=getMat2BlStr(res);
set(handles.recur_LB,'string',blMat);


%%%%%%%%%%%%%%%%%Create the constants
handles.constText=constStr;
handles.currSelConst=1;
handles.currSelConstStr=constStr(1,:);
set(handles.const_LB,'string',handles.constText);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes listBoxGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = listBoxGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in TransMat2Str_LB.
function TransMat2Str_LB_Callback(hObject, eventdata, handles)
% hObject    handle to TransMat2Str_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.ithRow=get(hObject,'Value');
set(handles.ithRow_Static,'string',['ithRow:' num2str(handles.ithRow)]); 
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns TransMat2Str_LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TransMat2Str_LB


% --- Executes during object creation, after setting all properties.
function TransMat2Str_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TransMat2Str_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function ithCol_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to ithCol_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ithCol=str2double(get(hObject,'String'));
set(handles.ithCol_Static,'string',['ithCol:' num2str(handles.ithCol)]); 
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of ithCol_Edit as text
%        str2double(get(hObject,'String')) returns contents of ithCol_Edit as a double


% --- Executes during object creation, after setting all properties.
function ithCol_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ithCol_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ithColVal_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to ithColVal_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%TransMatrix
handles.ithColVal=str2double(get(hObject,'String'));
set(handles.ithColVal_Static,'string',['ithColVal:' num2str(handles.ithColVal)]); 
bl=setStrMatEntry(handles.ithRow,handles.ithCol,handles.ithColVal,handles.transMat);
set(handles.TransMat2Str_LB,'string',bl);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of ithColVal_Edit as text
%        str2double(get(hObject,'String')) returns contents of ithColVal_Edit as a double


% --- Executes during object creation, after setting all properties.
function ithColVal_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ithColVal_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on selection change in const_LB.
function const_LB_Callback(hObject, eventdata, handles)
% hObject    handle to const_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.currSelConst=get(hObject,'Value');
str=get(hObject,'String');
handles.currSelConstStr=str(get(hObject,'Value'),:);
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns const_LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from const_LB


% --- Executes during object creation, after setting all properties.
function const_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in recur_LB.
function recur_LB_Callback(hObject, eventdata, handles)
% hObject    handle to recur_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns recur_LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from recur_LB


% --- Executes during object creation, after setting all properties.
function recur_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recur_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function const_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to const_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f rem]=strtok(handles.currSelConstStr,'=');
set(handles.const_Static,'string',['const: ' get(hObject,'String')]); 
%keep f 
f=[f '=' get(hObject,'String')];
%updates the constant values
handles.constText=modVerTxtEq(handles.currSelConst,handles.constText,f);
set(handles.const_LB,'string',handles.constText);

%updates the equation values
handles.sysFtns=showEq(handles.blFtnText,handles.constText);
set(handles.sysEquations_Static,'string',handles.sysFtns);
set(handles.const_Static,'string',f);

%%Whenever you'll automatically start the recursion


% Hints: get(hObject,'String') returns contents of const_Edit as text
%        str2double(get(hObject,'String')) returns contents of const_Edit as a double


% --- Executes during object creation, after setting all properties.
function const_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



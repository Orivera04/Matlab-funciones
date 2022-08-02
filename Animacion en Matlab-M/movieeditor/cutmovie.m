function varargout = cutmovie(varargin)
% M2 = CUTMOVIE(M1,beginframe,endframe) opens a gui to cut all frames 
%      before beginframe and after endframe of the MATLAB-movie M1 to give 
%      the MATLAB-movie M2. 
%      
%      from---------------------------------------------------------
%      | EDITTEXT: select beginframe                               |
%      | [Search] executes beginframe = SEARCHFRAME(M1,beginframe) |
%      -------------------------------------------------------------
%
%      to-----------------------------------------------------------
%      | EDITTEXT: select endframe                                 |
%      | [Search] executes endframe = SEARCHFRAME(M1,endframe)     |
%      -------------------------------------------------------------
%
%      [Cancel] M2 = false
%      [Cut]    M2 = cutted MATLAB-movie
%
% See also: MOVIEEDITOR, SEARCHFRAME
%
% Eduard van der Zwan 2005

% Edit the above text to modify the response to help cutmovie

% Last Modified by GUIDE v2.5 15-Mar-2005 16:30:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cutmovie_OpeningFcn, ...
                   'gui_OutputFcn',  @cutmovie_OutputFcn, ...
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


% --- Executes just before cutmovie is made visible.
function cutmovie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cutmovie (see VARARGIN)

% Choose default command line output for cutmovie
set(handles.figure1,'Units','pixels');
figsz = get(handles.figure1,'Position');
scrsz = get(0,'ScreenSize');
figsz(1:2)= (scrsz(3:4)/2)-(figsz(3:4)/2);
set(handles.figure1,'Position',figsz);
handles.output = 0;
[cax,args,nargs] = axescheck(varargin{:});
if nargs>=1 & isstruct(args{1})
    handles.M=args{1};
    a=size(handles.M);
    handles.Maxframe=a(2);
    if nargs>=2 & isnumeric(args{2}) & args{2}>=1 ...
            & args{2}<=handles.Maxframe
        handles.Fromframe=num2str(round(args{2}));
        set(handles.Fromedit,'String',handles.Fromframe);
    else
        handles.Fromframe='1';
        set(handles.Fromedit,'String',handles.Fromframe);
    end
    if nargs>=3 & isnumeric(args{3}) & args{3}>=args{2} ...
            & args{3}<=handles.Maxframe
        handles.Toframe=num2str(round(args{3}));
        set(handles.Toedit,'String',handles.Toframe);
    else
        handles.Toframe=num2str(handles.Maxframe);
        set(handles.Toedit,'String',handles.Toframe);
    end
    guidata(hObject, handles);
    uiwait(handles.figure1);
else
    guidata(hObject, handles);
    uiresume(handles.figure1);
end
    

% Update handles structure
% guidata(hObject, handles);

% UIWAIT makes cutmovie wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cutmovie_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);



function Fromedit_Callback(hObject, eventdata, handles)
% hObject    handle to Fromedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fromedit as text
%        str2double(get(hObject,'String')) returns contents of Fromedit as a double
val = round(str2double(get(handles.Fromedit,'String')));
if isnumeric(val) & length(val)==1 & val >= 1 & ...
        val <= str2double(get(handles.Toedit,'String'))
    set(handles.Fromedit,'String',num2str(val));
else
    set(handles.Fromedit,'String',handles.Fromframe);
end


% --- Executes during object creation, after setting all properties.
function Fromedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fromedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Searchfrompushbutton.
function Searchfrompushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Searchfrompushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=searchframe(handles.M,str2double(get(handles.Fromedit,'String')));
if val >= 1 & val <= str2double(get(handles.Toedit,'String'))
    set(handles.Fromedit,'String',num2str(val));
end

function Toedit_Callback(hObject, eventdata, handles)
% hObject    handle to Toedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Toedit as text
%        str2double(get(hObject,'String')) returns contents of Toedit as a double
val = round(str2double(get(handles.Toedit,'String')));
if isnumeric(val) & length(val)==1 & ...
        val >= str2double(get(handles.Fromedit,'String')) & ...
        val <= handles.Maxframe
    set(handles.Toedit,'String',num2str(val));
else
    set(handles.Toedit,'String',handles.Toframe);
end


% --- Executes during object creation, after setting all properties.
function Toedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Toedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Searchtopushbutton.
function Searchtopushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Searchtopushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=searchframe(handles.M,str2double(get(handles.Toedit,'String')));
if val >= str2double(get(handles.Fromedit,'String')) & val <= handles.Maxframe
    set(handles.Toedit,'String',num2str(val));
end



% --- Executes on button press in Cancelpushbutton.
function Cancelpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cancelpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=0;
guidata(hObject, handles);
uiresume(handles.figure1);

% --- Executes on button press in Cutpushbutton.
function Cutpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cutpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=handles.M(str2double(get(handles.Fromedit,'String')):...
    str2double(get(handles.Toedit,'String')));
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.figure1);
else
    % The GUI is no longer waiting, just close it
    delete(handles.figure1);
end



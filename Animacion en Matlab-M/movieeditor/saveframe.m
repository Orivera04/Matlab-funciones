function varargout = saveframe(varargin)
% logic = SAVEFRAME(M,frame) opens gui to save the image of 
%      MATLAB-movie M(frame)
%
%      frame-------------------------------------------
%      |EDITTEXT: select frame to save                |
%      |[Search] executes frame = SEARCHFRAME(M,frame)|
%      ------------------------------------------------
%
%      [Cancel] logic = false
%      [Save] browser is opened to give filename for image-file
%
% See also: MOVIEEDITOR, SEARCHFRAME
%
% Eduard van der Zwan 2005

% Edit the above text to modify the response to help saveframe

% Last Modified by GUIDE v2.5 16-Mar-2005 11:51:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @saveframe_OpeningFcn, ...
                   'gui_OutputFcn',  @saveframe_OutputFcn, ...
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


% --- Executes just before saveframe is made visible.
function saveframe_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to saveframe (see VARARGIN)

% Choose default command line output for saveframe
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
        handles.frame=num2str(round(args{2}));
        set(handles.frameedit,'String',handles.frame);
    else
        handles.frame='1';
        set(handles.frameedit,'String',handles.frame);
    end
    guidata(hObject, handles);
    uiwait(handles.figure1);
else
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% UIWAIT makes saveframe wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = saveframe_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);

function frameedit_Callback(hObject, eventdata, handles)
% hObject    handle to frameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frameedit as text
%        str2double(get(hObject,'String')) returns contents of frameedit as a double
val = round(str2double(get(handles.frameedit,'String')));
if isnumeric(val) & length(val)==1 & val >= 1 & val <= handles.Maxframe
    set(handles.frameedit,'String',num2str(val));
else
    set(handles.frameedit,'String',handles.frame);
end


% --- Executes during object creation, after setting all properties.
function frameedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Searchpushbutton.
function Searchpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Searchpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=searchframe(handles.M,str2double(get(handles.frameedit,'String')));
if val >= 1 & val <= handles.Maxframe
    set(handles.frameedit,'String',num2str(val));
end

% --- Executes on button press in Savepushbutton.
function Savepushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Savepushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile({'*.bmp','*.bmp';'*.jpg','*.jpg';'*.png','*.png';'*.tif','*.tif'},'Save Frame');
if FileName
    handles.output=1;
    imwrite(handles.M(str2double(handles.frame)).cdata,[PathName,FileName]);
    guidata(hObject, handles);
    uiresume(handles.figure1);
end


% --- Executes on button press in Cancelpushbutton.
function Cancelpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cancelpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=0;
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




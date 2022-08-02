function varargout = searchframe(varargin)
% frame2 = SEARCHFRAME(M,frame2) opens a gui to find frame2 in 
%      MATLAB-movie M. SEARCHFRAME starts at frame1.
%
%      Frame------------------------------------------------------
%      | EDITTEXT & SLIDER: select currentframe                  |
%      -----------------------------------------------------------
%
%      [Cancel] frame2 = false
%      [OK]     frame2 = currentframe
%
% See also: CUTMOVIE, SAVEFRAME
%
% Eduard van der Zwan 2005

% Edit the above text to modify the response to help searchframe

% Last Modified by GUIDE v2.5 15-Mar-2005 16:30:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @searchframe_OpeningFcn, ...
                   'gui_OutputFcn',  @searchframe_OutputFcn, ...
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


% --- Executes just before searchframe is made visible.
function searchframe_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to searchframe (see VARARGIN)

% Choose default command line output for searchframe
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
    set(handles.slider1,'Max',a(2));
    set(handles.slider1,'Min',1);
    if nargs>=2 & isnumeric(args{2}) & args{2} >= 1 & ...
            args{2} <= get(handles.slider1,'Max')
        set(handles.slider1,'Value',round(args{2}));
        set(handles.edit1,'String',num2str(round(args{2})));
    else
        set(handles.slider1,'Value',1);
        set(handles.edit1,'String','1');
    end        
    [Im,Map]=frame2im(handles.M(get(handles.slider1,'Value')));
    axis square off
    imshow(Im)
    guidata(hObject, handles);
    uiwait(handles.figure1);
else
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = searchframe_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=round(get(handles.slider1,'Value'));
guidata(hObject, handles);
uiresume(handles.figure1);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=round(get(handles.slider1,'Value'));
set(handles.edit1,'String',num2str(val));
[Im,Map]=frame2im(handles.M(val));
imshow(Im)


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
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



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

val = round(str2double(get(handles.edit1,'String')));
if isnumeric(val) & length(val)==1 & ...
    val >= get(handles.slider1,'Min') & ...
    val <= get(handles.slider1,'Max')
    
    set(handles.slider1,'Value',val);
    set(handles.edit1,'String',num2str(val));
    [Im,Map]=frame2im(handles.M(val));
    imshow(Im)
else
    set(handles.edit1,'String',num2str(round(get(handles.slider1,'Value'))));
end


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


% --- Executes on button press in Cancel_pushbutton.
function Cancel_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cancel_pushbutton (see GCBO)
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



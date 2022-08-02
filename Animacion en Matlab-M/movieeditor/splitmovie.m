function varargout = splitmovie(varargin)
% M2 = SPLITMOVIE(M1,layer,frame) opens gui to create a MATLAB-movie M2
%      which consists of one color layer of MATLAB-movie M1. The string
%      layer can be 'All', keeping the original, 'Red', 'Green' or 'Blue'.
%      SPLITMOVIE starts at frame.
%
%      Frame------------------------------------------------------
%      | EDITTEXT & SLIDER: select frame                         |
%      -----------------------------------------------------------
%
%      POP-UP MENU: select layer
%      [Cancel] M2 = false
%      [Split]  M2 = a MATLAB-movie with only the selected layer of M1
%
% See also: MOVIEEDITOR, PROGRESSBAR
%
% Acknowledgement: 
% For this functions i made use of PROGRESSBAR written by Steve Hoelzer
%
% Eduard van der Zwan 2005

% Edit the above text to modify the response to help splitmovie

% Last Modified by GUIDE v2.5 16-Mar-2005 11:17:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @splitmovie_OpeningFcn, ...
                   'gui_OutputFcn',  @splitmovie_OutputFcn, ...
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


% --- Executes just before splitmovie is made visible.
function splitmovie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to splitmovie (see VARARGIN)

% Choose default command line output for splitmovie
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
    if nargs>=2 & isstr(args{2}) & ...
            max(strcmp(args{2},get(handles.popupmenu1,'String')));
        set(handles.popupmenu1,'Value',...
            strmatch(args{2},get(handles.popupmenu1,'String'),'exact'));
    end
    if nargs>=3 & isnumeric(args{3}) & args{3} >= 1 & ...
            args{3} <= get(handles.slider1,'Max')
        set(handles.slider1,'Value',round(args{3}));
        set(handles.edit1,'String',num2str(round(args{3})));
    else
        set(handles.slider1,'Value',1);
        set(handles.edit1,'String','1');
    end        
    [Im,Map]=frame2im(handles.M(get(handles.slider1,'Value')));
    if ~size(Map)
        axis square off
        val2=get(handles.popupmenu1,'Value');
        if val2>1
            Im=Im(:,:,val2-1);
        end
        imshow(Im)
        guidata(hObject, handles);
        uiwait(handles.figure1);
    else
        guidata(hObject, handles);
        uiresume(handles.figure1);
    end
   
else
    guidata(hObject, handles);
    uiresume(handles.figure1);
end


% UIWAIT makes splitmovie wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = splitmovie_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% The figure can be deleted now
delete(handles.figure1);



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
    val2=get(handles.popupmenu1,'Value');
    Im=handles.M(round(get(handles.slider1,'Value'))).cdata;
    if val2>1
        Im=Im(:,:,val2-1);
    end
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


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=round(get(handles.slider1,'Value'));
set(handles.edit1,'String',num2str(val));
val2=get(handles.popupmenu1,'Value');
Im=handles.M(val).cdata;
if val2>1
    Im=Im(:,:,val2-1);
end
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


% --- Executes on button press in Splitpushbutton.
function Splitpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Splitpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val2=get(handles.popupmenu1,'Value');
a = size(handles.M);
if val2>1
    %h = waitbar(0,'Please wait...');
    progressbar
    for frame=1:a(2)
        Im=handles.M(frame).cdata;
        A(:,:,1,frame)=Im(:,:,val2-1);
        %waitbar(frame/a(2))
        progressbar(frame/a(2))
    end
    %close(h)
    Mout=immovie(A,colormap);
    handles.output=Mout;
else
    handles.output=0;
end
guidata(hObject, handles);
uiresume(handles.figure1);    


% --- Executes on button press in Cancelpushbutton.
function Cancelpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cancelpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=0;
guidata(hObject, handles);
uiresume(handles.figure1);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
val2=get(handles.popupmenu1,'Value');
Im=handles.M(round(get(handles.slider1,'Value'))).cdata;
if val2>1
    Im=Im(:,:,val2-1);
end
imshow(Im)

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


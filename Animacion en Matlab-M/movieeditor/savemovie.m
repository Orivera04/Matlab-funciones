function varargout = savemovie(varargin)
% logic = SAVEMOVIE(M) opens gui to save MATLAB-movie M as avi-file. The
%      compression type and ratio and the framerate can be set in the gui.
%
%      compression------------------------------------------
%      |POP-UP MENU: select compression type               |
%      |EDITTEXT: insert compression ration in %.          |
%      |          N.B. Default 100 when compression is None|
%      -----------------------------------------------------
%
%      framerate--------------------------------------------
%      |EDITTEXT: insert framerate in frame per second     |
%      -----------------------------------------------------
%      
%      [Cancel] logic = false
%      [Save]   browser is opened to give filename for avi-file 
%
% See also: MOVIEEDITOR, MPGWRITE
%
% Acknowledgement: 
% For this function i made use of MPGWRITE written by David Foti
%
% Eduard van der Zwan 2005

% Edit the above text to modify the response to help savemovie

% Last Modified by GUIDE v2.5 15-Mar-2005 16:30:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @savemovie_OpeningFcn, ...
                   'gui_OutputFcn',  @savemovie_OutputFcn, ...
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


% --- Executes just before savemovie is made visible.
function savemovie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to savemovie (see VARARGIN)

% Choose default command line output for savemovie
set(handles.figure1,'Units','pixels');
figsz = get(handles.figure1,'Position');
scrsz = get(0,'ScreenSize');
figsz(1:2)= (scrsz(3:4)/2)-(figsz(3:4)/2);
set(handles.figure1,'Position',figsz);
handles.output = 0;
[cax,args,nargs] = axescheck(varargin{:});
if nargs>=1 & isstruct(args{1})
    handles.M=args{1};
    guidata(hObject, handles);
    uiwait(handles.figure1);
else
    guidata(hObject, handles);
    uiresume(handles.figure1);
end

% UIWAIT makes savemovie wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = savemovie_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);

% --- Executes on selection change in Compressiontypepopupmenu.
function Compressiontypepopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to Compressiontypepopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Compressiontypepopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Compressiontypepopupmenu
if get(handles.Compressiontypepopupmenu,'Value')==1 & ...
        str2double(get(handles.compressionratioedit,'String'))<100
    set(handles.compressionratioedit,'String','100');
end

% --- Executes during object creation, after setting all properties.
function Compressiontypepopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Compressiontypepopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function compressionratioedit_Callback(hObject, eventdata, handles)
% hObject    handle to compressionratioedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of compressionratioedit as text
%        str2double(get(hObject,'String')) returns contents of compressionratioedit as a double
val = round(str2double(get(handles.compressionratioedit,'String')));
if isnumeric(val) & length(val)==1 & val >= 1 & val <= 100 &...
        get(handles.Compressiontypepopupmenu,'Value')>1
    set(handles.compressionratioedit,'String',num2str(val));
else
    set(handles.compressionratioedit,'String','100');
end


% --- Executes during object creation, after setting all properties.
function compressionratioedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compressionratioedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function framerateedit_Callback(hObject, eventdata, handles)
% hObject    handle to framerateedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of framerateedit as text
%        str2double(get(hObject,'String')) returns contents of framerateedit as a double
val = str2double(get(handles.framerateedit,'String'));
if isnumeric(val) & length(val)==1 & val > 0 
    set(handles.framerateedit,'String',num2str(val));
else
    set(handles.framerateedit,'String','20');
end

% --- Executes during object creation, after setting all properties.
function framerateedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to framerateedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Savepushbutton.
function Savepushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Savepushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.output=1;
[FileName,PathName] = uiputfile({'*.avi','*.avi';'*.mpg','*.mpg'},'Save Movie');
if FileName
    a=size(FileName);
    Extention=FileName(a(2)-2:a(2));
    if strcmpi(Extention,'avi')
        val=get(handles.Compressiontypepopupmenu,'Value');
        str=get(handles.Compressiontypepopupmenu,'String');
        Compressiontype=str(val);
        movie2avi(handles.M,[PathName,FileName],...
            'compression',Compressiontype{1},...
            'quality',str2double(get(handles.compressionratioedit,'String')),...
            'fps',str2double(get(handles.framerateedit,'String')));
    else
        mpgwrite(handles.M,handles.M(1).colormap,[PathName,FileName]);
    end
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


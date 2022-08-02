function varargout = rotatemovie(varargin)
% M2 = ROTATEMOVIE(M1,angle,frame) opens gui to rotate MATLAB-movie M1 over
%      angle degrees resulting in MATLAB-movie M2. ROTATEMOVIE starts at 
%      frame.
%
%      Rotation---------------------------------------------------
%      | EDITTEXT & SLIDER: select angle                         |
%      -----------------------------------------------------------
%
%      Frame------------------------------------------------------
%      | EDITTEXT & SLIDER: select currentframe                  |
%      -----------------------------------------------------------
%
%      [Cancel] M2 = false
%      [OK]     M2 = rotated MATLAB-movie M1
%
% See also: MOVIEEDITOR, PROGRESSBAR
%
% Acknowledgement: 
% For this functions i made use of PROGRESSBAR written by Steve Hoelzer
%
% Eduard van der Zwan 2005

% Edit the above text to modify the response to help rotatemovie

% Last Modified by GUIDE v2.5 15-Mar-2005 16:29:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rotatemovie_OpeningFcn, ...
                   'gui_OutputFcn',  @rotatemovie_OutputFcn, ...
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


% --- Executes just before rotatemovie is made visible.
function rotatemovie_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rotatemovie (see VARARGIN)

% Choose default command line output for rotatemovie
set(handles.figure1,'Units','pixels');
figsz = get(handles.figure1,'Position');
scrsz = get(0,'ScreenSize');
figsz(1:2)= (scrsz(3:4)/2)-(figsz(3:4)/2);
set(handles.figure1,'Position',figsz);
handles.output = 0;
[cax,args,nargs] = axescheck(varargin{:});

set(handles.Rotationslider,'Max',360);
set(handles.Rotationslider,'Min',0);
if nargs>=1 & isstruct(args{1})
    handles.M=args{1};
    a=size(handles.M);
    set(handles.Frameslider,'Max',a(2));
    set(handles.Frameslider,'Min',1);
    
    if nargs>=2 & isnumeric(args{2}) & args{2} >= -360 & args{2} <= 360
        if args{2} < 0
            rotation=360-args{2};
        else
            rotation=args{2};
        end
    else
        rotation=0;
    end        
    set(handles.Rotationedit,'String',num2str(rotation));
    set(handles.Rotationslider,'Value',rotation);
    
    if nargs>=3 & isnumeric(args{3}) & args{3} >= 1 & args{3} <= a(2)
        frame=args{3};
    else
        frame=1;
    end        
    set(handles.Frameedit,'String',num2str(frame));
    set(handles.Frameslider,'Value',frame);
    axis square off
    imshow(imrotate(handles.M(round(get(handles.Frameslider,'Value'))).cdata,...
        round(get(handles.Rotationslider,'Value'))))
    guidata(hObject, handles);
    uiwait(handles.figure1);
else
    guidata(hObject, handles);
    uiresume(handles.figure1);
end



% UIWAIT makes rotatemovie wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rotatemovie_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);


% --- Executes on button press in OKpushbutton.
function OKpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OKpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=size(handles.M);
rotate=round(get(handles.Rotationslider,'Value'));
%h = waitbar(0,'Please wait...');
progressbar
for frame=1:a(2)
    A(:,:,:,frame)=imrotate(handles.M(frame).cdata,rotate);
    %waitbar(frame/a(2))
    progressbar(frame/a(2))
end
%close(h)
Mout=immovie(A,handles.M(1).colormap);
handles.output=Mout;
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


function Rotationedit_Callback(hObject, eventdata, handles)
% hObject    handle to Rotationedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rotationedit as text
%        str2double(get(hObject,'String')) returns contents of Rotationedit as a double
val = round(str2double(get(handles.Rotationedit,'String')));
if isnumeric(val) & length(val)==1 & val >= -360 & val <= 360
    if val<0, val=360+val; end
    set(handles.Rotationslider,'Value',val);
    set(handles.Rotationedit,'String',num2str(val));
    imshow(imrotate(handles.M(round(get(handles.Frameslider,'Value'))).cdata,...
        round(get(handles.Rotationslider,'Value'))))
else
    set(handles.Rotationedit,'String',num2str(get(handles.Rotationslider,'Value')));
end

% --- Executes during object creation, after setting all properties.
function Rotationedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rotationedit (see GCBO)
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
function Rotationslider_Callback(hObject, eventdata, handles)
% hObject    handle to Rotationslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=round(get(handles.Rotationslider,'Value'));
set(handles.Rotationedit,'String',num2str(val));
imshow(imrotate(handles.M(round(get(handles.Frameslider,'Value'))).cdata,...
    round(get(handles.Rotationslider,'Value'))))


% --- Executes during object creation, after setting all properties.
function Rotationslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rotationslider (see GCBO)
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

function Frameedit_Callback(hObject, eventdata, handles)
% hObject    handle to Frameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frameedit as text
%        str2double(get(hObject,'String')) returns contents of Frameedit as a double
val = round(str2double(get(handles.Frameedit,'String')));
if isnumeric(val) & length(val)==1 & val >= 1 & ...
        val <= get(Frameslider,'Max')
    set(handles.Frameslider,'Value',val);
    set(handles.Frameedit,'String',num2str(val));
    imshow(imrotate(handles.M(round(get(handles.Frameslider,'Value'))).cdata,...
        round(get(handles.Rotationslider,'Value'))))

    guidata(hObject, handles);
else
    set(handles.Frameedit,'String',num2str(get(handles.Frameslider,'Value')));
end

% --- Executes during object creation, after setting all properties.
function Frameedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frameedit (see GCBO)
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
function Frameslider_Callback(hObject, eventdata, handles)
% hObject    handle to Frameslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val=round(get(handles.Frameslider,'Value'));
set(handles.Frameedit,'String',num2str(val));
imshow(imrotate(handles.M(round(get(handles.Frameslider,'Value'))).cdata,...
    round(get(handles.Rotationslider,'Value'))))

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Frameslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frameslider (see GCBO)
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


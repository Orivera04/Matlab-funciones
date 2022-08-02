function varargout = movieeditor(varargin)
% MOVIEEDITOR edit avi movies.
%      MOVIEEDITOR, by itself, opens a Graphical User Interface (gui) to 
%      edit movies. 
%      MOVIEEDITOR works best if the functions on the left side of the gui
%      are executed from top to botom. The botom functions require much
%      cpu-time and are better executed if the size of the movie is
%      decreased first using the functions in the top.
%      You can always stroll through the movie using the SLIDER and the 
%      EDITTEXT in the frame panel inderneath the image.
%
%      Open movie-------------------------------------------------
%      |[Open] executes M=OPENMOVIE                              |
%      -----------------------------------------------------------
%
%      Cut--------------------------------------------------------
%      |  from-----------------------------------------------    |
%      |  |EDITTEXT: select beginframe                      |    |  
%      |  |[Current] inserts currentframe as beginframe     |    |
%      |  ---------------------------------------------------    |
%      |  to-------------------------------------------------    |
%      |  |EDITTEXT: select endframe                        |    |
%      |  |[Current] inserts currentframe as endframe       |    |
%      |  ---------------------------------------------------    |
%      | [Cut] executes M = CUTMOVIE(M,beginframe,endframe)      | 
%      -----------------------------------------------------------
%
%      Crop-------------------------------------------------------
%      | [Crop] executes M = CROPMOVIE(M,currentframe)           |
%      -----------------------------------------------------------
%      
%      Split------------------------------------------------------
%      | POP-UP MENU: layer                                      |
%      | [Split] executes M = SPLITMOVIE(M,layer,currentframe)   |
%      -----------------------------------------------------------
%      
%      Rotate-----------------------------------------------------
%      | EDITTEXT: select angle                                  |
%      | [Rotate] executes M = ROTATEMOVIE(M,angle,currentframe) |
%      -----------------------------------------------------------
%      
%      Save-------------------------------------------------------
%      | [Movie] executes SAVEMOVIE(M)                           |
%      | [Image] executes SAVEFRAME(M,currentframe)              |
%      -----------------------------------------------------------
%
%      Frame------------------------------------------------------
%      | EDITTEXT & SLIDER: select currentframe                  |
%      -----------------------------------------------------------
%      
% See also: OPENMOVIE, CUTMOVIE, SPLITMOVIE, CROPMOVIE, ROTATEMOVIE,
% SAVEMOVIE, SAVEFRAME
%
% Acknowledgement: 
% - For the function SAVEMOVIE i made use of MPGWRITE written by David Foti
% - For this functions SPLITMOVIE, CROPMOVIE and ROTATEMOVIE i made use of 
%   PROGRESSBAR written by Steve Hoelzer
%
% Eduard van der Zwan 2005

% Edit the above text to modify the response to help movieeditor

% Last Modified by GUIDE v2.5 18-Mar-2005 17:01:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @movieeditor_OpeningFcn, ...
                   'gui_OutputFcn',  @movieeditor_OutputFcn, ...
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


% --- Executes just before movieeditor is made visible.
function movieeditor_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to movieeditor (see VARARGIN)

% Choose default command line output for movieeditor
set(handles.figure1,'Units','pixels');
figsz = get(handles.figure1,'Position');
scrsz = get(0,'ScreenSize');
figsz(1:2)= (scrsz(3:4)/2)-(figsz(3:4)/2);
set(handles.figure1,'Position',figsz);
handles.output = 0;
Im(:,:,:,1)=imread('movieeditor.tif');
Im(:,:,:,2)=Im(:,:,:,1);
axis square off
imshow(Im(:,:,:,1))
handles.M=immovie(Im);
set(handles.Frameslider,'Min',1);
set(handles.Frameslider,'Max',2);
set(handles.Frameslider,'Value',1);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes movieeditor wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = movieeditor_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Cutfromedit_Callback(hObject, eventdata, handles)
% hObject    handle to Cutfromedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cutfromedit as text
%        str2double(get(hObject,'String')) returns contents of Cutfromedit as a double
val = round(str2double(get(handles.Cutfromedit,'String')));
if isnumeric(val) & length(val)==1 & ...
        val >= get(handles.Frameslider,'Min') & ...
        val <= str2double(get(handles.Cuttoedit,'String'))
    set(handles.Cutfromedit,'String',num2str(val));
else
    set(handles.Cutfromedit,'String','1');
end

% --- Executes during object creation, after setting all properties.
function Cutfromedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cutfromedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Cutfromcurrentpushbutton.
function Cutfromcurrentpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cutfromcurrentpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if round(get(handles.Frameslider,'Value'))<=...
        str2double(get(handles.Cuttoedit,'String'))
    set(handles.Cutfromedit,'String',...
        num2str(round(get(handles.Frameslider,'Value'))))
end


function Cuttoedit_Callback(hObject, eventdata, handles)
% hObject    handle to Cuttoedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Cuttoedit as text
%        str2double(get(hObject,'String')) returns contents of Cuttoedit as a double
val = round(str2double(get(handles.Cuttoedit,'String')));
if isnumeric(val) & length(val)==1 & ...
        val >= str2double(get(handles.Cutfromedit,'String')) & ...
        val <= get(handles.Frameslider,'Max')
    set(handles.Cuttoedit,'String',num2str(val));
else
    set(handles.Cuttoedit,'String',...
        num2str(get(handles.Frameslider,'Max')));
end


% --- Executes during object creation, after setting all properties.
function Cuttoedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Cuttoedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Cuttocurrentpushbutton.
function Cuttocurrentpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cuttocurrentpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if round(get(handles.Frameslider,'Value'))>=...
        str2double(get(handles.Cutfromedit,'String'))
    set(handles.Cuttoedit,'String',...
        num2str(round(get(handles.Frameslider,'Value'))))
end


function Frameedit_Callback(hObject, eventdata, handles)
% hObject    handle to Frameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frameedit as text
%        str2double(get(hObject,'String')) returns contents of Frameedit as a double
val = round(str2double(get(handles.Frameedit,'String')));
if isnumeric(val) & length(val)==1 & ...
    val >= get(handles.Frameslider,'Min') & ...
    val <= get(handles.Frameslider,'Max')
    
    set(handles.Frameslider,'Value',val);
    set(handles.Frameedit,'String',num2str(val));
    [Im,Map]=frame2im(handles.M(val));
    imshow(Im)
else
    set(handles.Frameedit,'String',num2str(round(get(handles.Frameslider,'Value'))));
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
[Im,Map]=frame2im(handles.M(val));
imshow(Im)


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


% --- Executes on button press in Cutpushbutton.
function Cutpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Cutpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M2=cutmovie(handles.M,...
    str2double(get(handles.Cutfromedit,'String')),...
    str2double(get(handles.Cuttoedit,'String')));
if isstruct(M2)
    handles.M=M2;
    maxframe=size(handles.M);
    set(handles.Frameslider,'Value',1);
    set(handles.Frameslider,'Max',maxframe(2));
    set(handles.Frameedit,'String','1');
    set(handles.Cutfromedit,'String','1');
    set(handles.Cuttoedit,'String',num2str(maxframe(2)));
    set(handles.Rotateedit,'String','0');
    imshow(handles.M(get(handles.Frameslider,'Value')).cdata)
    guidata(hObject, handles);
end



function Rotateedit_Callback(hObject, eventdata, handles)
% hObject    handle to Rotateedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rotateedit as text
%        str2double(get(hObject,'String')) returns contents of Rotateedit as a double
val = round(str2double(get(handles.Rotateedit,'String')));
if isnumeric(val) & length(val)==1 & val >= -360 & val <= 360
    set(handles.Rotateedit,'String',num2str(val));
else
    set(handles.Rotateedit,'String','0');
end


% --- Executes during object creation, after setting all properties.
function Rotateedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rotateedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Rotatepushbutton.
function Rotatepushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Rotatepushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M2=rotatemovie(handles.M,...
    str2double(get(handles.Rotateedit,'String')),...
    round(get(handles.Frameslider,'Value')));
if isstruct(M2)
    handles.M=M2;
    set(handles.Rotateedit,'String','0');
    imshow(handles.M(round(get(handles.Frameslider,'Value'))).cdata)
    guidata(hObject, handles);
end


% --- Executes on button press in Splitpushbutton.
function Splitpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Splitpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(handles.Splitpopupmenu,'Value');
str=get(handles.Splitpopupmenu,'String');
M2=splitmovie(handles.M,str{val},round(get(handles.Frameslider,'Value')));
if isstruct(M2)
    handles.M=M2;
    set(handles.Splitpopupmenu,'Value',1);
    imshow(handles.M(round(get(handles.Frameslider,'Value'))).cdata)
    guidata(hObject, handles);
end

% --- Executes on selection change in Splitpopupmenu.
function Splitpopupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to Splitpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns Splitpopupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Splitpopupmenu


% --- Executes during object creation, after setting all properties.
function Splitpopupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Splitpopupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in Croppushbutton.
function Croppushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Croppushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M2=cropmovie(handles.M,...
    round(get(handles.Frameslider,'Value')));
if isstruct(M2)
    handles.M=M2;
    imshow(handles.M(round(get(handles.Frameslider,'Value'))).cdata)
    guidata(hObject, handles);
end


% --- Executes on button press in Openpushbutton.
function Openpushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Openpushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M2=openmovie;
if isstruct(M2)
    handles.M=M2;
    maxframe=size(handles.M);
    set(handles.Frameslider,'Value',1);
    set(handles.Frameslider,'Max',maxframe(2));
    set(handles.Frameedit,'String','1');
    set(handles.Cutfromedit,'String','1');
    set(handles.Cuttoedit,'String',num2str(maxframe(2)));
    set(handles.Rotateedit,'String','0');
    imshow(handles.M(round(get(handles.Frameslider,'Value'))).cdata)
    guidata(hObject, handles);
end

% --- Executes on button press in Savemoviepushbutton.
function Savemoviepushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Savemoviepushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savemovie(handles.M);

% --- Executes on button press in Saveimagepushbutton.
function Saveimagepushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to Saveimagepushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveframe(handles.M,round(get(handles.Frameslider,'Value')));



% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openmovie_Callback(hObject, eventdata, handles)
% hObject    handle to openmovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M2=openmovie;
if isstruct(M2)
    handles.M=M2;
    maxframe=size(handles.M);
    set(handles.Frameslider,'Value',1);
    set(handles.Frameslider,'Max',maxframe(2));
    set(handles.Frameedit,'String','1');
    set(handles.Cutfromedit,'String','1');
    set(handles.Cuttoedit,'String',num2str(maxframe(2)));
    set(handles.Rotateedit,'String','0');
    imshow(handles.M(round(get(handles.Frameslider,'Value'))).cdata)
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function savemovie_Callback(hObject, eventdata, handles)
% hObject    handle to savemovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
savemovie(handles.M);


% --------------------------------------------------------------------
function saveframe_Callback(hObject, eventdata, handles)
% hObject    handle to saveframe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveframe(handles.M,round(get(handles.Frameslider,'Value')));


% --------------------------------------------------------------------
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);

% --------------------------------------------------------------------
function cut_Callback(hObject, eventdata, handles)
% hObject    handle to cut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M2=cutmovie(handles.M,...
    str2double(get(handles.Cutfromedit,'String')),...
    str2double(get(handles.Cuttoedit,'String')));
if isstruct(M2)
    handles.M=M2;
    maxframe=size(handles.M);
    set(handles.Frameslider,'Value',1);
    set(handles.Frameslider,'Max',maxframe(2));
    set(handles.Frameedit,'String','1');
    set(handles.Cutfromedit,'String','1');
    set(handles.Cuttoedit,'String',num2str(maxframe(2)));
    set(handles.Rotateedit,'String','0');
    imshow(handles.M(get(handles.Frameslider,'Value')).cdata)
    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function crop_Callback(hObject, eventdata, handles)
% hObject    handle to crop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M2=cropmovie(handles.M,...
    round(get(handles.Frameslider,'Value')));
if isstruct(M2)
    handles.M=M2;
    imshow(handles.M(round(get(handles.Frameslider,'Value'))).cdata)
    guidata(hObject, handles);
end



% --------------------------------------------------------------------
function rotate_Callback(hObject, eventdata, handles)
% hObject    handle to rotate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
M2=rotatemovie(handles.M,...
    str2double(get(handles.Rotateedit,'String')),...
    round(get(handles.Frameslider,'Value')));
if isstruct(M2)
    handles.M=M2;
    set(handles.Rotateedit,'String','0');
    imshow(handles.M(round(get(handles.Frameslider,'Value'))).cdata)
    guidata(hObject, handles);
end

% --------------------------------------------------------------------
function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function split_Callback(hObject, eventdata, handles)
% hObject    handle to split (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val=get(handles.Splitpopupmenu,'Value');
str=get(handles.Splitpopupmenu,'String');
M2=splitmovie(handles.M,str{val},round(get(handles.Frameslider,'Value')));
if isstruct(M2)
    handles.M=M2;
    set(handles.Splitpopupmenu,'Value',1);
    imshow(handles.M(round(get(handles.Frameslider,'Value'))).cdata)
    guidata(hObject, handles);
end


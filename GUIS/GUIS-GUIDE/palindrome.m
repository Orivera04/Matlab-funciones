function varargout = palindrome(varargin)
% PALINDROME M-file for palindrome.fig
%
% Programed by Darin C. Koblick on 01-17-2009
% The purpose of this M-file is to serve as a GUI to my palinsum MEX file.
% User inputs can be file driven or manual entry.
%
% This function will call the palinsum.mex32 which will do all of the
% computationaly intensive tasks.
%
% Last Modified by GUIDE v2.5 17-Jan-2009 19:47:22
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @palindrome_OpeningFcn, ...
                   'gui_OutputFcn',  @palindrome_OutputFcn, ...
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



% --- Executes just before palindrome is made visible.
function palindrome_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to palindrome (see VARARGIN)

% Choose default command line output for palindrome
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes palindrome wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = palindrome_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in FileBrowse.
function FileBrowse_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile('*.mat','Select the Mat file which contains the palindrome data');
if FileName ~= 0
    load([PathName,FileName],'StartNum');
    %update DecimalPlace String
    set(handles.DecimalPlace,'String',num2str(length(StartNum)));
else
    StartNum = [];
end
set(handles.FileBrowse,'UserData',StartNum);


% --- Executes on button press in Start.
function Start_Callback(hObject, eventdata, handles)
% hObject    handle to Start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in StopButton.
function StopButton_Callback(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.StopButton,'UserData',true);


function StopDecimal_Callback(hObject, eventdata, handles)
% hObject    handle to StopDecimal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StopDecimal as text
%        str2double(get(hObject,'String')) returns contents of StopDecimal as a double





% --- Executes during object creation, after setting all properties.
function StopDecimal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StopDecimal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OutputFileName_Callback(hObject, eventdata, handles)
% hObject    handle to OutputFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputFileName as text
%        str2double(get(hObject,'String')) returns contents of OutputFileName as a double


% --- Executes during object creation, after setting all properties.
function OutputFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function startNum_Callback(hObject, eventdata, handles)
% hObject    handle to startNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startNum as text
%        str2double(get(hObject,'String')) returns contents of startNum as a double


% --- Executes during object creation, after setting all properties.
function startNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in StartButton.
function StartButton_Callback(hObject, eventdata, handles)
% hObject    handle to StartButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Grab the number of decimal places count to stop the program:
DecimalStopLimit = get(handles.StopDecimal,'String');
OutputFileNameString = get(handles.OutputFileName,'String');
StartingNumber = get(handles.startNum,'String');
StartNum = get(handles.FileBrowse,'UserData');

%Palindrome launch code sequence
if isempty(StartNum)
    sNum = regexp(StartingNumber,'\d{1}','match');
    for i=1:length(sNum)
        tNum(i) = str2num(sNum{i});
    end
    sNum = tNum;
else
   sNum = StartNum; 
   clear StartNum;
end
status = false;
if length(sNum) + 1000 < str2double(DecimalStopLimit)
count = ceil((length(sNum)+1000)/1000)*1000;
else
   count =  str2double(DecimalStopLimit);
end
set(handles.StopButton,'UserData',false);
stop = false;
while ~status
    stop = get(handles.StopButton,'UserData');
    [sNum,status] = palinsum(sNum,count);
    DecimalSize = length(sNum);
    set(handles.DecProg,'String',num2str(DecimalSize));
    drawnow;
    if (DecimalSize >= str2double(DecimalStopLimit)) | (stop == true)
        fprintf('%s <---- Computed %s decimals! \n',num2str(sNum),num2str(DecimalSize));
        StartNum = sNum;
        save(OutputFileNameString,'StartNum');
        break;
    end
    count = count + 1000;
end

if stop ~= true
    fprintf('%s <---- Palindrome! \n',num2str(sNum));
    StartNum = sNum;
    clear sNum;
    save(OutputFileNameString,'StartNum');
end

% --- Executes on button press in StopButton.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uipanel4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function DecimalPlace_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DecimalPlace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

 
% --- Executes during object creation, after setting all properties.
function FileBrowse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FileBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over StopButton.
function StopButton_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function StopButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function StopButton_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to StopButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



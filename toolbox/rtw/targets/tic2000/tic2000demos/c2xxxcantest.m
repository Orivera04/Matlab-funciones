function varargout = c2xxxcantest(varargin)
% C2XXXCANTEST M-file for c2xxxcantest.fig
%      C2XXXCANTEST, by itself, creates a new C2XXXCANTEST or raises the existing
%      singleton*.
%
%      H = C2XXXCANTEST returns the handle to a new C2XXXCANTEST or the handle to
%      the existing singleton*.
%
%      C2XXXCANTEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in C2XXXCANTEST.M with the given input arguments.
%
%      C2XXXCANTEST('Property','Value',...) creates a new C2XXXCANTEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before c2xxxcantest_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to c2xxxcantest_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/08 21:00:23 $

% Edit the above text to modify the response to help c2xxxcantest

% Last Modified by GUIDE v2.5 19-Nov-2003 15:35:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @c2xxxcantest_OpeningFcn, ...
                   'gui_OutputFcn',  @c2xxxcantest_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before c2xxxcantest is made visible.
function c2xxxcantest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to c2xxxcantest (see VARARGIN)

% Choose default command line output for c2xxxcantest
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

c = get(handles.output,'children');
set(c(1),'Value',0)
set(c(2),'Value',0)
set(c(3),'Value',1)

% UIWAIT makes c2xxxcantest wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = c2xxxcantest_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Okay.
function Okay_Callback(hObject, eventdata, handles)
c = get(handles.output,'children');
set(c(5),'Enable','off'); % disable "Apply"
modelName = gcs;
[boardNum, procNum] = getBoardProc(modelName);
if isempty(boardNum)
    errordlg(sprintf(['Could not find desired board.  Select the appropriate board in Code Composer '...
            'Studio Setup and make sure that the "DSPBoardLabel" field in the model''s target preference '...
            'block matches the name of the selected board.']));
    return;
end
CCS_Obj = ccsdsp('boardnum',boardNum,'procnum',procNum); % create CCSDSP object
if     (get(c(3),'Value'))
    data1 = 16000;     
elseif (get(c(2),'Value'))
    data1 = 32000;
elseif (get(c(1),'Value'))
    data1 = 48000;
end
write(CCS_Obj,[hex2dec('8FF0') 1], uint16(data1));
set(c(5),'Enable','on'); % renable "Apply"

% hObject    handle to Okay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
c = get(handles.output,'children');
set(c(1),'Value',0)
set(c(2),'Value',0)
set(c(3),'Value',1)


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
c = get(handles.output,'children');
set(c(1),'Value',0)
set(c(2),'Value',1)
set(c(3),'Value',0)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
c = get(handles.output,'children');
set(c(1),'Value',1)
set(c(2),'Value',0)
set(c(3),'Value',0)


%--------------------------------------------------------------------------
function [boardNum, procNum] = getBoardProc(modelName)
% Search for board label matches in CCS setup
boardNum = [];
procNum = [];
tgtblock = find_system(modelName,'masktype','c2000 Target Preferences');
tgtuserdata = get_param(tgtblock,'userdata'); 
BoardLabel = tgtuserdata{:}.tic2000TgtPrefs.DSPBoard.DSPBoardLabel;
s = ccsboardinfo;
for m = 1:length(s)
    if strcmpi(s(m).name, BoardLabel)
        boardNum = s(m).number;
        procNum =  s(m).proc.number;
        break;
    end
end

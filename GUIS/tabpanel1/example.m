function varargout = example(varargin)
% EXAMPLE M-file for example.fig
%      EXAMPLE, by itself, creates a new EXAMPLE or raises the existing
%      singleton*.
%
%      H = EXAMPLE returns the handle to a new EXAMPLE or the handle to
%      the existing singleton*.
%
%      EXAMPLE('Property','Value',...) creates a new EXAMPLE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to example_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      EXAMPLE('CALLBACK') and EXAMPLE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in EXAMPLE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help example

% Last Modified by GUIDE v2.5 24-Feb-2005 15:21:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @example_OpeningFcn, ...
                   'gui_OutputFcn',  @example_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before example is made visible.
function example_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for example
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes example wait for user response (see UIRESUME)
% uiwait(handles.figure1);
ssz = get(0,'ScreenSize');
set(handles.figure1,'position',[ (ssz(3:4)-[431 270])/2 431 270 ]);


% --- Outputs from this function are returned to the command line.
function varargout = example_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in myTabpanel_4_pushbutton1.
function myTabpanel_4_pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to myTabpanel_4_pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.myTabpanel_4_axes1)
plot([0:0.01:2*pi],sin([0:0.01:2*pi]),'Tag','myTabpanel_4_axes1');
set(handles.myTabpanel_4_axes1,'Tag','myTabpanel_4_axes1')
axis([0 2*pi -1 1]);

% --- Executes on button press in myTabpanel_4_pushbutton2.
function myTabpanel_4_pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to myTabpanel_4_pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.myTabpanel_4_axes1)
plot([0:0.01:2*pi],cos([0:0.01:2*pi]),'Tag','myTabpanel_4_axes1');
set(handles.myTabpanel_4_axes1,'Tag','myTabpanel_4_axes1')
axis([0 2*pi -1 1]);

% --- Executes on button press in myTabpanel_4_pushbutton3.
function myTabpanel_4_pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to myTabpanel_4_pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.myTabpanel_4_axes1)
plot([0:0.01:2*pi],exp([0:0.01:2*pi]),'Tag','myTabpanel_4_axes1');
set(handles.myTabpanel_4_axes1,'Tag','myTabpanel_4_axes1')
axis([0 2*pi 0 700]);


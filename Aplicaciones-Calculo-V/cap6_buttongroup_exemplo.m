function varargout = cap6_buttongroup_exemplo(varargin)
% CAP6_buttongroup_EXEMPLO M-file for cap6_buttongroup_exemplo.fig
%      CAP6_buttongroup_EXEMPLO, by itself, creates a new CAP6_buttongroup_EXEMPLO or raises the existing
%      singleton*.
%
%      H = CAP6_buttongroup_EXEMPLO returns the handle to a new CAP6_buttongroup_EXEMPLO or the handle to
%      the existing singleton*.
%
%      CAP6_buttongroup_EXEMPLO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAP6_buttongroup_EXEMPLO.M with the given input arguments.
%
%      CAP6_buttongroup_EXEMPLO('Property','Value',...) creates a new CAP6_buttongroup_EXEMPLO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cap6_buttongroup_exemplo_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cap6_buttongroup_exemplo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help cap6_buttongroup_exemplo

% Last Modified by GUIDE v2.5 19-Jun-2004 19:10:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cap6_buttongroup_exemplo_OpeningFcn, ...
                   'gui_OutputFcn',  @cap6_buttongroup_exemplo_OutputFcn, ...
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


% --- Executes just before cap6_buttongroup_exemplo is made visible.
function cap6_buttongroup_exemplo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cap6_buttongroup_exemplo (see VARARGIN)

% Choose default command line output for cap6_buttongroup_exemplo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cap6_buttongroup_exemplo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cap6_buttongroup_exemplo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
H=get(hObject);
bgObject=H.Parent;
selection = get(bgObject,'SelectedObject');

switch get(selection,'Tag')
    case 'radiobutton1'
        % SOMBREAMENTO: FLAT
        surf(peaks)
        shading('FLAT')
    case 'radiobutton2'
        % SOMBREAMENTO: FACETED
        surf(peaks)
        shading('FACETED')
    case 'radiobutton3'
        % SOMBREAMENTO: INTERP
        surf(peaks)
        shading('INTERP')  
end

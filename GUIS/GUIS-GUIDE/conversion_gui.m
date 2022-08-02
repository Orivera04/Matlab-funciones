function varargout = conversion_gui(varargin)
% CONVERSION_GUI M-file for conversion_gui.fig
%      CONVERSION_GUI, by itself, creates a new CONVERSION_GUI or raises the existing
%      singleton*.
%
%      H = CONVERSION_GUI returns the handle to a new CONVERSION_GUI or the handle to
%      the existing singleton*.
%
%      CONVERSION_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONVERSION_GUI.M with the given input arguments.
%
%      CONVERSION_GUI('Property','Value',...) creates a new CONVERSION_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before conversion_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to conversion_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help conversion_gui

% Last Modified by GUIDE v2.5 13-Jan-2005 20:24:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @conversion_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @conversion_gui_OutputFcn, ...
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


% --- Executes just before conversion_gui is made visible.
function conversion_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to conversion_gui (see VARARGIN)

handles.base1 = 2;
handles.base2 = 2;
handles.isothers = 0;
handles.isothers2 = 0;
set(handles.input_edit,'String','');

% Choose default command line output for conversion_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes conversion_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = conversion_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function others_edit_Callback(hObject, eventdata, handles)
% hObject    handle to others_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of others_edit as text
%        str2double(get(hObject,'String')) returns contents of others_edit as a double


% --- Executes during object creation, after setting all properties.
function others_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to others_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function input_edit_Callback(hObject, eventdata, handles)
% hObject    handle to input_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of input_edit as text
%        str2double(get(hObject,'String')) returns contents of input_edit as a double


% --- Executes during object creation, after setting all properties.
function input_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to input_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function others2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to others2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of others2_edit as text
%        str2double(get(hObject,'String')) returns contents of others2_edit as a double


% --- Executes during object creation, after setting all properties.
function others2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to others2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function output_edit_Callback(hObject, eventdata, handles)
% hObject    handle to output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of output_edit as text
%        str2double(get(hObject,'String')) returns contents of output_edit as a double


% --- Executes during object creation, after setting all properties.
function output_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to output_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in convert_pushbutton.
function convert_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to convert_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(strcmp(get(handles.input_edit,'String'),''))
    errordlg('Input cannot be empty string','Input Error','on')
    return;
else
    numStr = get(handles.input_edit,'String');
end
    
if(handles.isothers)
    base1 = str2num(get(handles.others_edit,'String'));
else
    base1 = handles.base1;
end

if(handles.isothers2)
    base2 = str2num(get(handles.others2_edit,'String'));
else
    base2 = handles.base2;
end

output = [];
n = length(numStr);

%---------- Toupper -------------------
for i = 1:n
   if('a'<= numStr(i) && numStr(i) <= 'z')
       numStr(i) = numStr(i) - 32;       
   end    
end
%--------------------------------------

%-------- Extract integer part & floating part ---------
intStr = [];
floatStr = [];

extract = 1;    
for i = 1:n
    if(strcmp(numStr(i),'.'))
        extract = 0;
        continue;
    end
    
    if(extract)        
        intStr = [intStr numStr(i)];        
    else       
        floatStr = [floatStr numStr(i)];    
    end        
end
n_int = length(intStr); 
n_float = length(floatStr); 
%------------------------------------------------------

digit = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
%-(integer part)- Conversion base1 to base 10 ----------------
base10num = 0;
for i =1:n_int
    temp = intStr(i) - 0;   % convert character to ascii code
	if((temp>=65)&&(temp<=90))
        base10num = base10num + (temp - 55)*power(base1,n_int-i);
	else
		base10num = base10num + (temp - 48)*power(base1,n_int-i);
    end
end
%-------------------------------------------------------------

%-(integer part)- Conversion base 10 to base2 -----------------
while(base10num > 0)    
    output = [digit(mod(base10num,base2)+1) output];    
    base10num = floor(base10num / base2);      
end
%-------------------------------------------------------------
output = [output '.'];

%-(floating part)- Conversion base1 to base 10 ---------------
for i=1:n_float
    temp = floatStr(i) - 0; % convert character to ascii code
	if((temp>=65)&&(temp<=90))
        base10num = base10num + (temp - 55)*power(base1,-i);
	else
		base10num = base10num + (temp - 48)*power(base1,-i);
    end
end
%-------------------------------------------------------------

%-(floating part)- Conversion base 10 to base2 -----------------
if(nargin < 4)
    sf = 50;
end
i = 1;
while(1)    
    y = base10num * base2;
    x = floor(y);  
    base10num = y - x;   
    output = [output digit(x+1)];
    i = i + 1;    
    if(base10num == 0)        
        break;
    elseif(i > sf)        
        output = [output ' (' num2str(sf) '+)'];
        break;
    end    
end
% --------------------------------------------------------------------
set(handles.output_edit,'String',output);
guidata(hObject, handles);




% --------------------------------------------------------------------
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.isothers = 0;
switch get(hObject,'Tag')
    case 'bin_radiobutton'
        handles.base1 = 2;
        set(handles.others_edit,'Enable','off');
    case 'oct_radiobutton'
        handles.base1 = 8;
        set(handles.others_edit,'Enable','off');
    case 'dec_radiobutton'
        handles.base1 = 10;
        set(handles.others_edit,'Enable','off');        
    case 'hex_radiobutton'
        handles.base1 = 16;
        set(handles.others_edit,'Enable','off');
    case 'others_radiobutton'
        set(handles.others_edit,'Enable','on');
        handles.isothers = 1;        
end
guidata(hObject, handles);



% --------------------------------------------------------------------
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.isothers2 = 0;
switch get(hObject,'Tag')
    case 'bin2_radiobutton'
        handles.base2 = 2;
        set(handles.others2_edit,'Enable','off');
    case 'oct2_radiobutton'
        handles.base2 = 8;
        set(handles.others2_edit,'Enable','off');
    case 'dec2_radiobutton'
        handles.base2 = 10;
        set(handles.others2_edit,'Enable','off');        
    case 'hex2_radiobutton'
        handles.base2 = 16;
        set(handles.others2_edit,'Enable','off');
    case 'others2_radiobutton'
        set(handles.others2_edit,'Enable','on');
        handles.isothers2 = 1;        
end
guidata(hObject, handles);

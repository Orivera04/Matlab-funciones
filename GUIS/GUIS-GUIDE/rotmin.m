function varargout = rotmin(varargin)
% ROTMIN M-file for rotmin.fig
%      ROTMIN, by itself, creates a new ROTMIN or raises the existing
%      singleton*.
%
%      H = ROTMIN returns the handle to a new ROTMIN or the handle to
%      the existing singleton*.
%
%      ROTMIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROTMIN.M with the given input arguments.
%
%      ROTMIN('Property','Value',...) creates a new ROTMIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before rotmin_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to rotmin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help rotmin

% Last Modified by GUIDE v2.5 05-Mar-2004 12:58:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @rotmin_OpeningFcn, ...
                   'gui_OutputFcn',  @rotmin_OutputFcn, ...
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


% --- Executes just before rotmin is made visible.
function rotmin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to rotmin (see VARARGIN)

% Choose default command line output for rotmin
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes rotmin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = rotmin_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
set(gcf,'DoubleBuffer','on')

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function roben_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roben (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function roben_Callback(hObject, eventdata, handles)
% hObject    handle to roben (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roben as text
%        str2double(get(hObject,'String')) returns contents of roben as a double



% --- Executes during object creation, after setting all properties.
function runten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to runten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function runten_Callback(hObject, eventdata, handles)
% hObject    handle to runten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of runten as text
%        str2double(get(hObject,'String')) returns contents of runten as a double


% --- Executes during object creation, after setting all properties.
function knoten_CreateFcn(hObject, eventdata, handles)
% hObject    handle to knoten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function knoten_Callback(hObject, eventdata, handles)
% hObject    handle to knoten (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of knoten as text
%        str2double(get(hObject,'String')) returns contents of knoten as a double


% --- Executes during object creation, after setting all properties.
function faktor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to faktor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function faktor_Callback(hObject, eventdata, handles)
% hObject    handle to faktor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of faktor as text
%        str2double(get(hObject,'String')) returns contents of faktor as a double


% --- Executes during object creation, after setting all properties.
function maxiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function maxiter_Callback(hObject, eventdata, handles)
% hObject    handle to maxiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxiter as text
%        str2double(get(hObject,'String')) returns contents of maxiter as a double


% --- Executes during object creation, after setting all properties.
function eps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function eps_Callback(hObject, eventdata, handles)
% hObject    handle to eps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eps as text
%        str2double(get(hObject,'String')) returns contents of eps as a double


% --- Executes during object creation, after setting all properties.
function hoehe_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hoehe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function hoehe_Callback(hObject, eventdata, handles)
% hObject    handle to hoehe (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hoehe as text
%        str2double(get(hObject,'String')) returns contents of hoehe as a double



% --- Executes on button press in solution.
function solution_Callback(hObject, eventdata, handles)
% hObject    handle to solution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Berechnung einer rotationssymmeztriechen Minimalfläche, 
% welche  der Differentialgleichung
% 
%    r*r'' = (r')^2 + 1
%
% genügt, r den Radius bezeichnet. Diskretisierung erfolgt 
% über Finite Differenzen, die Lösung der diskretisierten
% Gleichungen mit Hilfe des Newton-Verfahrens.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Parameter einlesen
hoehe = str2double(get(handles.hoehe,'String'));
n = str2double(get(handles.knoten,'String'));
faktor = str2double(get(handles.faktor,'String'));
roben = str2double(get(handles.roben,'String'));
runten = str2double(get(handles.runten,'String'));
maxiter = str2double(get(handles.maxiter,'String'));
eps = str2double(get(handles.eps,'String'));

h = hoehe/(n-1);

% Startlösung
rstart = faktor * ones(n,1);

% Newton-Verfahren
k = 0;

rnew = rstart;
rold = rnew + ones(n,1);

DF = zeros(n,n);
DF(1,1) = 1;
DF(n,n) = 1;

F = zeros(n,1);

while norm(rold-rnew) > eps & k < maxiter
	rold = rnew;
	% Aufbau der Jacobimatrix und des Funktionswertes
	% an dem Punkt rold
	F(1) = rold(1) - runten;
	F(n) = rold(n) - roben;
	for i = 2:n-1
		% Jacobimatrix
		DF(i,i-1) =   4*rold(i) + 2*(rold(i+1)-rold(i-1));
		DF(i,i)   = -16*rold(i) + 4*(rold(i-1)+rold(i+1));
		DF(i,i+1) =   4*rold(i) + 2*(rold(i-1)-rold(i+1));
		% Funktionswert
		F(i) = -8*rold(i)^2 - rold(i+1)^2 - rold(i-1)^2 + 4*rold(i)* ...
					 (rold(i-1)+rold(i+1)) + 2*rold(i+1)*rold(i-1) - 4*h^2;
	end
	rnew = rold - DF\F;
	k = k+1;
	
	z = linspace(0,hoehe,n);
	phi = linspace(0,2*pi,n+1);

	[z,phi] = meshgrid(z,phi);
	x = (ones(n+1,1)*rnew').*cos(phi);
	y = (ones(n+1,1)*rnew').*sin(phi);
	z;
	surf(x,y,z);
	%hold on;
	%axis tight;
	%grid off;
	%material([0.8,0.6,0.5,30]);
	%light('Position',[200,-20,-20]);
	%light('Position',[-20,300,-20]);
	%colormap summer;
	%shading interp;
	lighting phong;
	%axis off;
	hold off;
	xlabel('x-Achse');
	ylabel('y-Achse');
	%zlabel('z-Achse');
	
% write Iterate number
	set(handles.iterate,'String',k);

	pause(0.1);
end


% --- Executes during object creation, after setting all properties.
function iterate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iterate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function iterate_Callback(hObject, eventdata, handles)
% hObject    handle to iterate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iterate as text
%        str2double(get(hObject,'String')) returns contents of iterate as a double



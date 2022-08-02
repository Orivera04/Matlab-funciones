function varargout = mandel101(varargin)
% MANDEL101 M-file for mandel101.fig
%      MANDEL101, by itself, creates a new MANDEL101 or raises the existing
%      singleton*.
%
%      H = MANDEL101 returns the handle to a new MANDEL101 or the handle to
%      the existing singleton*.
%
%      MANDEL101('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANDEL101.M with the given input arguments.
%
%      MANDEL101('Property','Value',...) creates a new MANDEL101 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mandel101_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mandel101_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%       This program uses a vecorised mandelbrot algorithm (a pretty fast algorithm from
%       Lucio Andrade-Cetto which worked great for me.) I tried before the
%       Fractal Explorer from Laurant Cavin, but that program was not
%       running on my computer.

%       Known limitations: the code is very repetitive and I appreciate any
%       comments that will help to shorten the code to what is really
%       required. I am new to MatLab and I tried to put the repetitive
%       parts of the code into functions. However I couldn't get the code
%       to work. 

%       The program lets you zoom easily into the Mandelbrot Set by just
%       selecting a subset of the currently displayed graph and then press
%       the Command Button "Apply Zoom to MandelBrot set" and the new
%       calcualtion will be performed.

%       I will try to add more functions to the GUI and to improve the
%       code.

%       Enjoy

%       Any questions: jens.koopmann"at"   live.com



% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mandel101

% Last Modified by GUIDE v2.5 04-Jan-2009 16:55:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mandel101_OpeningFcn, ...
                   'gui_OutputFcn',  @mandel101_OutputFcn, ...
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


% --- Executes just before mandel101 is made visible.
function mandel101_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mandel101 (see VARARGIN)

% Choose default command line output for mandel101
handles.output = hObject;
handles.col=1;
handles.view=2;
handles.lowerR=-2
handles.higherR=2
handles.higherI=2
handles.lowerI=-2
handles.stepsR=600; 
handles.stepsI=800;  
handles.MaxIter=1000;

%hier werden die x und Y Koordinaten fur die Mandelbrotmenge angezeigt
set(handles.text1,'String',handles.lowerR);
set(handles.text2,'String',handles.higherR);
set(handles.text3,'String',handles.lowerI);
set(handles.text4,'String',handles.higherI);
set(handles.text5,'String',handles.MaxIter);
set(handles.text6,'String',handles.stepsI);
set(handles.text7,'String',handles.stepsR);
guidata(hObject, handles);
% Update handles structure
guidata(hObject, handles);

%Hier werden die Startwerte fur das Apfelmannchen eingegeben und spater
%konnen sie durche ein Zoom ersetzt werden.
lowerR=-2
higherR=2
higherI=2
lowerI=-2
stepsR=600; stepsI=800;  
MaxIter=1000;

%compute other constants  
  Rwidth=higherR-lowerR;
  Iwidth=higherI-lowerI;
  slR=Rwidth/(stepsR-1);
  slI=Iwidth/(stepsI-1);

% Initialize
 
[x,y]=meshgrid([0:stepsR-1]*slR+lowerR,[0:stepsI-1]*slI+lowerI);
  Zvalues=ones(size(x));
  initZ=zeros(size(x));
  c=(x+i*y);
tic
z=initZ;
    h_z=1:(stepsR*stepsI);
    h = waitbar(0,'Please wait...');
    for counter=1:MaxIter  
      waitbar(counter/MaxIter)  
      z(h_z)=z(h_z).^2+c(h_z);
      h_z= h_z(find(abs(z(h_z))<2));
      Zvalues(h_z)=Zvalues(h_z)+1;
    end
close(h)

disp(['Elapsed time: ' num2str(toc)])
if handles.col == 1
    colormap(jet)
elseif handles.col == 2
    colormap(hsv)
elseif handles.col == 3
    colormap(gray)
elseif handles.col == 4
    colormap(prism)
elseif handles.col == 5
    colormap(cool)
elseif handles.col == 6
    colormap(hot)
elseif handles.col == 7
    colormap(copper)
elseif handles.col == 8
    colormap(pink)
elseif handles.col == 9
    colormap(spring)
elseif handles.col == 10
    colormap(summer)
elseif handles.col == 11
    colormap(autumn)
elseif handles.col == 12
    colormap(winter)    
elseif handles.col == 13
    colormap(bone)
elseif handles.col == 14
    colormap(lines)    
end
%hier werden die errechneten Daten an Handles ubergegeben.
handles.x=x;
handles.y=y;
handles.Zvalues=Zvalues;
% Update handles structure
guidata(hObject, handles);
if handles.view == 2 
    pcolor(handles.x,handles.y,log(double(handles.Zvalues)));
elseif handles.view == 3
    meshz(handles.x,handles.y,log(double(handles.Zvalues)));
end
shading interp;
axis off
zoom on
h = pan;






% UIWAIT makes mandel101 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mandel101_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = pan;
dx=xlim
dy=ylim
lowerR=dx(1,1)
higherR=dx(1,2)
lowerI=dy(1,1)
higherI=dy(1,2)
stepsR=600; 
stepsI=800;  
MaxIter=1000;
set(handles.text1,'String',lowerR);
set(handles.text2,'String',higherR);
set(handles.text3,'String',lowerI);
set(handles.text4,'String',higherI);
set(handles.text5,'String',MaxIter);
set(handles.text6,'String',stepsI);
set(handles.text7,'String',stepsR);


%compute other constants  
  Rwidth=higherR-lowerR;
  Iwidth=higherI-lowerI;
  slR=Rwidth/(stepsR-1);
  slI=Iwidth/(stepsI-1);

% Initialize
 
[x,y]=meshgrid([0:stepsR-1]*slR+lowerR,[0:stepsI-1]*slI+lowerI);
  Zvalues=ones(size(x));
  initZ=zeros(size(x));
  c=(x+i*y);
tic
z=initZ;

    h_z=1:(stepsR*stepsI);
    h = waitbar(0,'Please wait...');
    for counter=1:MaxIter  
        waitbar(counter/MaxIter)
      z(h_z)=z(h_z).^2+c(h_z);
      h_z= h_z(find(abs(z(h_z))<2));
      Zvalues(h_z)=Zvalues(h_z)+1;
    end
    close(h)

disp(['Elapsed time: ' num2str(toc)])
%colormap jet(256);
if handles.col == 1
    colormap(jet)
elseif handles.col == 2
    colormap(hsv)
elseif handles.col == 3
    colormap(gray)
elseif handles.col == 4
    colormap(prism)
elseif handles.col == 5
    colormap(cool)
elseif handles.col == 6
    colormap(hot)
elseif handles.col == 7
    colormap(copper)
elseif handles.col == 8
    colormap(pink)
elseif handles.col == 9
    colormap(spring)
elseif handles.col == 10
    colormap(summer)
elseif handles.col == 11
    colormap(autumn)
elseif handles.col == 12
    colormap(winter)    
elseif handles.col == 13
    colormap(bone)
elseif handles.col == 14
    colormap(lines)    
end
%hier werden die errechneten Daten an Handles ubergegeben.
handles.x=x;
handles.y=y;
handles.Zvalues=Zvalues;
% Update handles structure
guidata(hObject, handles);
if handles.view == 2 
    pcolor(x,y,log(double(Zvalues)));
elseif handles.view == 3
    meshz(x,y,log(double(Zvalues)));
end
shading interp;
axis off
zoom on
%set(h,'ActionPostCallback',@mypostcallback);




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Hier werden die Startwerte fur das Apfelmannchen eingegeben und spater
%konnen sie durche ein Zoom ersetzt werden.
%lowerR=-2
%higherR=2
%higherI=2
%lowerI=-2
%stepsR=600; 
%stepsI=800;  
%MaxIter=1000;
dummy2 (-2, 2,-2,2,600,800,100)
set(handles.text1,'String',-2);
set(handles.text2,'String',2);
set(handles.text3,'String',-2);
set(handles.text4,'String',2);
set(handles.text5,'String',100);
set(handles.text6,'String',600);
set(handles.text7,'String',800);

%col=handles.col;
%compute other constants  
%  Rwidth=higherR-lowerR;
%  Iwidth=higherI-lowerI;
%  slR=Rwidth/(stepsR-1);
%  slI=Iwidth/(stepsI-1);

% Initialize
 
%[x,y]=meshgrid([0:stepsR-1]*slR+lowerR,[0:stepsI-1]*slI+lowerI);
%  Zvalues=ones(size(x));
%  initZ=zeros(size(x));
%  c=(x+i*y);
%tic
%z=initZ;
%    h_z=1:(stepsR*stepsI);
%    for counter=1:MaxIter      
%      z(h_z)=z(h_z).^2+c(h_z);
%      h_z= h_z(find(abs(z(h_z))<2));
%      Zvalues(h_z)=Zvalues(h_z)+1;
%    end
%disp(['Elapsed time: ' num2str(toc)])
%if handles.col == 1
%    colormap(jet)
%elseif handles.col == 2
%    colormap(hsv)
%elseif handles.col == 3
%    colormap(gray)
%elseif handles.col == 4
%    colormap(prism)
%elseif handles.col == 5
%    colormap(cool)
%elseif handles.col == 6
%    colormap(hot)
%elseif handles.col == 7
%    colormap(copper)
%elseif handles.col == 8
%    colormap(pink)
%elseif handles.col == 9
%    colormap(spring)
%elseif handles.col == 10
%    colormap(summer)
%elseif handles.col == 11
%    colormap(autumn)
%elseif handles.col == 12
%    colormap(winter)    
%elseif handles.col == 13
%    colormap(bone)
%elseif handles.col == 14
%    colormap(lines)    
%end
%if handles.view == 2 
%    pcolor(x,y,log(double(Zvalues)));
%elseif handles.view == 3
%    meshz(x,y,log(double(Zvalues)));
%end
%axis off
%hier werden die errechneten Daten an Handles ubergegeben.
%handles.x=x;
%handles.y=y;
%handles.Zvalues=Zvalues;
%% Update handles structure
%guidata(hObject, handles);

%shading interp;

%zoom on
%h = pan;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.col=get(hObject,'Value');
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.view=2
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.view=3
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dummy2 (-2, 2,-2,2,300,400,25)


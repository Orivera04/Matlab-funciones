function varargout = line_code(varargin)
%Data encoding simulation
%Author: Diego Orlando Barragán Guerrero
%For more information, visit: www.matpic.com
%diegokillemall@yahoo.com
%LOJA (ECUADOR)
%Long Live Judas Priest

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @line_code_OpeningFcn, ...
                   'gui_OutputFcn',  @line_code_OutputFcn, ...
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


% --- Executes just before line_code is made visible.
function line_code_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to line_code (see VARARGIN)

hold off;
        h=[1 1 0 1 0 0 1 1 0 1];
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=(t>n);
            else
                y=(t==n);
            end
            d=plot(t,y);title('Codificación UNIPOLAR NRZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            if h(n+1)==0
                y=(t<n)-0*(t==n);
            else
                y=(t<n)+1*(t==n);
            end
            d=plot(t,y);title('Code UNIPOLAR NRZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end

% Choose default command line output for line_code
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes line_code wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = line_code_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in random.
function random_Callback(hObject, eventdata, handles)
% hObject    handle to random (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=round(rand(1,1));
b=round(rand(1,1));
c=round(rand(1,1));
d=round(rand(1,1));
e=round(rand(1,1));
f=round(rand(1,1));
g=round(rand(1,1));
h=round(rand(1,1));
i0=round(rand(1,1));
j0=round(rand(1,1));
ran=[a,b,c,d,e,f,g,h,i0,j0];
set(handles.uno,'String',ran(1));
set(handles.dos,'String',ran(2));
set(handles.tres,'String',ran(3));
set(handles.cuatro,'String',ran(4));
set(handles.cinco,'String',ran(5));
set(handles.seis,'String',ran(6));
set(handles.siete,'String',ran(7));
set(handles.ocho,'String',ran(8));
set(handles.nueve,'String',ran(9));
set(handles.diez,'String',ran(10));

%-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-
handles.bits=[a,b,c,d,e,f,g,h,i0,j0];
cod=get(handles.select_code,'Value');
switch cod
    case 1
        hold off;
        h=handles.bits;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=(t>n);
            else
                y=(t==n);
            end
            d=plot(t,y);title('Code UNIPOLAR NRZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            if h(n+1)==0
                y=(t<n)-0*(t==n);
            else
                y=(t<n)+1*(t==n);
            end
            d=plot(t,y);title('Code UNIPOLAR NRZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end
    case 2
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=-(t<n)-(t==n);
            else
                y=-(t<n)+(t==n);
            end
            d=plot(t,y);title('Code POLAR NRZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            if h(n+1)==0
                y=(t<n)-1*(t==n);
            else
                y=(t<n)+1*(t==n);
            end
            d=plot(t,y);title('Code POLAR NRZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end
        
    case 3
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        %Graficación de los CEROS (0)
            if h(n) == 0
                if h(n+1)==0  
                    y=(t>n);
                else
                    y=(t==n);
                end
            d=plot(t,y);title('Code UNIPOLAR RZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        %Graficación de los UNOS (1)
            else
            if h(n+1)==0
                y=(t<n-0.5);
            else
                y=(t<n-0.5)+1*(t==n);
            end
            d=plot(t,y);title('Code UNIPOLAR RZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
            end
        n=n+1;
         
        end
        
    case 4
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=-(t<n-0.5)-(t==n);
            else
                y=-(t<n-0.5)+(t==n);
            end
            d=plot(t,y);title('Code BIPOLAR RZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            if h(n+1)==0
                y=(t<n-0.5)-1*(t==n);
            else
                 y=(t<n-0.5)+1*(t==n);
            end
            d=plot(t,y);title('Code BIPOLAR RZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end

    case 5
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        ami=-1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=(t>n);
            else
                if ami==1
                    y=-(t==n);
                else
                    y=(t==n);
                end
            end
            d=plot(t,y);title('Code AMI NRZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            ami=ami*-1;
            if h(n+1)==0
                if ami==1
                    y=(t<n);
                else
                    y=-(t<n);
                end
            else
                if ami==1
                    y=(t<n)-(t==n);
                else
                    y=-(t<n)+(t==n);
                end
            end
            d=plot(t,y);title('Code AMI NRZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end

    case 6
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        ami=-1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=(t>n);
            else
                if ami==1
                    y=-(t==n);
                else
                    y=(t==n);
                end
            end
            d=plot(t,y);title('Code AMI RZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            ami=ami*-1;
            if h(n+1)==0
                if ami==1
                    y=(t<n-0.5);
                else
                    y=-(t<n-0.5);
                end
            else
                if ami==1
                    y=(t<n-0.5)-(t==n);
                else
                    y=-(t<n-0.5)+(t==n);
                end
            end
            d=plot(t,y);title('Code AMI RZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end

    case 7
        hold off;
        h =handles.bits;
        h=~h;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=-(t<n)+2*(t<n-0.5)+1*(t==n);
            else
                y=-(t<n)+2*(t<n-0.5)-1*(t==n);
            end
            d=plot(t,y);title('Code MANCHESTER NRZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            if h(n+1)==0
                y=(t<n)-2*(t<n-0.5)+1*(t==n);
            else
                y=(t<n)-2*(t<n-0.5)-1*(t==n);
            end
            d=plot(t,y);title('Code MANCHESTER RZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end

end
%*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*

guidata(hObject, handles);


% --- Executes on selection change in select_code.
function select_code_Callback(hObject, eventdata, handles)
% hObject    handle to select_code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns select_code contents as cell array
%        contents{get(hObject,'Value')} returns selected item from select_code
a=str2double(get(handles.uno,'String'));
b=str2double(get(handles.dos,'String'));
c=str2double(get(handles.tres,'String'));
d=str2double(get(handles.cuatro,'String'));
e=str2double(get(handles.cinco,'String'));
f=str2double(get(handles.seis,'String'));
g=str2double(get(handles.siete,'String'));
h=str2double(get(handles.ocho,'String'));
i0=str2double(get(handles.nueve,'String'));
j0=str2double(get(handles.diez,'String'));

if (a~=0 && a~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.uno,'String','1');a=1;
    else
        set(handles.uno,'String','0');a=0;
    end
elseif (b~=0 && b~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.dos,'String','1');b=1;
    else
        set(handles.dos,'String','0');b=0;
    end
elseif (c~=0 && c~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.tres,'String','1');c=1;
    else
        set(handles.tres,'String','0');c=0;
    end
elseif (d~=0 && d~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.cuatro,'String','1');d=1;
    else
        set(handles.cuatro,'String','0');d=0;
    end
elseif (e~=0 && e~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.cinco,'String','1');e=1;
    else
        set(handles.cinco,'String','0');e=0;
    end
elseif (f~=0 && f~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.seis,'String','1');f=1;
    else
        set(handles.seis,'String','0');f=0;
    end
elseif (g~=0 && g~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.siete,'String','1');g=1;
    else
        set(handles.siete,'String','0');g=0;
    end
elseif (h~=0 && h~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.ocho,'String','1');h=1;
    else
        set(handles.ocho,'String','0');h=0;
    end
elseif (i0~=0 && i0~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.nueve,'String','1');i0=1;
    else
        set(handles.nueve,'String','0');i0=0;
    end
elseif (j0~=0 && j0~=1)
    co=questdlg('The value must be binary','ERROR','1','0','1');
    if strcmp(co,'1')
        set(handles.diez,'String','1');j0=1;
    else
        set(handles.diez,'String','0');j0=0;
    end
end

handles.bits=[a,b,c,d,e,f,g,h,i0,j0];
handles.cod=get(hObject,'Value');
switch handles.cod
    case 1
        hold off;
        h=handles.bits;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=(t>n);
            else
                y=(t==n);
            end
            d=plot(t,y);title('Code UNIPOLAR NRZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            if h(n+1)==0
                y=(t<n)-0*(t==n);
            else
                y=(t<n)+1*(t==n);
            end
            d=plot(t,y);title('Code UNIPOLAR NRZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end
    case 2
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=-(t<n)-(t==n);
            else
                y=-(t<n)+(t==n);
            end
            d=plot(t,y);title('Code POLAR NRZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            if h(n+1)==0
                y=(t<n)-1*(t==n);
            else
                y=(t<n)+1*(t==n);
            end
            d=plot(t,y);title('Code POLAR NRZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end
        
    case 3
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        %Graficación de los CEROS (0)
            if h(n) == 0
                if h(n+1)==0  
                    y=(t>n);
                else
                    y=(t==n);
                end
            d=plot(t,y);title('Code UNIPOLAR RZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        %Graficación de los UNOS (1)
            else
            if h(n+1)==0
                y=(t<n-0.5);
            else
                y=(t<n-0.5)+1*(t==n);
            end
            d=plot(t,y);title('Code UNIPOLAR RZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
            end
        n=n+1;
         
        end
        
    case 4
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=-(t<n-0.5)-(t==n);
            else
                y=-(t<n-0.5)+(t==n);
            end
            d=plot(t,y);title('Code BIPOLAR RZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            if h(n+1)==0
                y=(t<n-0.5)-1*(t==n);
            else
                 y=(t<n-0.5)+1*(t==n);
            end
            d=plot(t,y);title('Code BIPOLAR RZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end

    case 5
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        ami=-1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=(t>n);
            else
                if ami==1
                    y=-(t==n);
                else
                    y=(t==n);
                end
            end
            d=plot(t,y);title('Code AMI NRZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            ami=ami*-1;
            if h(n+1)==0
                if ami==1
                    y=(t<n);
                else
                    y=-(t<n);
                end
            else
                if ami==1
                    y=(t<n)-(t==n);
                else
                    y=-(t<n)+(t==n);
                end
            end
            d=plot(t,y);title('Code AMI NRZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end

    case 6
        hold off;
        h =handles.bits;
        n=1;
        h(11)=1;
        ami=-1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=(t>n);
            else
                if ami==1
                    y=-(t==n);
                else
                    y=(t==n);
                end
            end
            d=plot(t,y);title('Code AMI RZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            ami=ami*-1;
            if h(n+1)==0
                if ami==1
                    y=(t<n-0.5);
                else
                    y=-(t<n-0.5);
                end
            else
                if ami==1
                    y=(t<n-0.5)-(t==n);
                else
                    y=-(t<n-0.5)+(t==n);
                end
            end
            d=plot(t,y);title('Code AMI RZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end

    case 7
        hold off;
        h =handles.bits;
        h=~h;
        n=1;
        h(11)=1;
        while n<=10;
            t=n-1:0.001:n;
        if h(n) == 0
            if h(n+1)==0  
                y=-(t<n)+2*(t<n-0.5)+1*(t==n);
            else
                y=-(t<n)+2*(t<n-0.5)-1*(t==n);
            end
            d=plot(t,y);title('Code MANCHESTER NRZ');grid on
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        else
            if h(n+1)==0
                y=(t<n)-2*(t<n-0.5)+1*(t==n);
            else
                y=(t<n)-2*(t<n-0.5)-1*(t==n);
            end
            d=plot(t,y);title('Code MANCHESTER RZ');grid on;
            set(d,'LineWidth',2.5);
            hold on;
            axis([0 10 -1.5 1.5]);
        end
        n=n+1;
        end

end
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function select_code_CreateFcn(hObject, eventdata, handles)
% hObject    handle to select_code (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in espectro.
function espectro_Callback(hObject, eventdata, handles)
% hObject    handle to espectro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close line_code;
espec_lc

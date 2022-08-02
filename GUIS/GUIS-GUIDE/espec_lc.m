function varargout = espec_lc(varargin)
%Simulation of Line Codes
%Author: Diego Orlando Barragán Guerrero
%diegokillemall@yahoo.com
%LOJA (ECUADOR)
%Long Live Judas Priest

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @espec_lc_OpeningFcn, ...
                   'gui_OutputFcn',  @espec_lc_OutputFcn, ...
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


% --- Executes just before espec_lc is made visible.
function espec_lc_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to espec_lc (see VARARGIN)
    hold off;
    A=1;
    Tb=1.5;
    R=1/Tb;
    L=2*R;
    f=0:L/50:L;
    P=(A.^2*Tb)*(sinc(f*Tb/2)).^2.*(sin(pi*f*Tb/2)).^2;
    g=plot(f,P);
    title('ESPECTRAL DENSITY: MANCHESTER NRZ');
    hold on;xlabel('Frequency');ylabel('Normalized Power');
    axis([0 L 0 1.1*Tb]);set(g,'LineWidth',2.5);
    set(gca,'XTickMode','manual','XTick',[R,2*R]);grid on;
    set(gca,'YTickMode','manual','YTick',[0.5*Tb,Tb]);
    set(gca,'XTickLabel',{['R'];['2R']})
    set(gca,'YTickLabel',{['0.5*Tb'];['Tb']})
% Choose default command line output for espec_lc
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes espec_lc wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = espec_lc_OutputFcn(hObject, eventdata, handles) 
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
if (hObject==handles.Unipolar_NRZ)
    hold off;
    A=sqrt(2);
    Tb=1.5;
    R=1/Tb;
    L=2*R;
    f=0:L/50:L;
    del=0;
    P=(A.^2*Tb)/4*(sinc(f*Tb)).^2*(1+(1/Tb)*del);
    g=plot(f,P);
    title('ESPECTRAL DENSITY: UNIPOLAR NRZ');
    hold on;xlabel('Frequency');ylabel('Normalized Power');
    axis([0 L 0 1.1*Tb]);set(g,'LineWidth',2.5);
    stem(0,(A.^2*Tb)/2,'LineWidth',2.5);hold off;
    axis([0 L 0 1.09*Tb]);set(g,'LineWidth',2.5);
    set(gca,'XTickMode','manual','XTick',[R,2*R]);grid on;
    set(gca,'YTickMode','manual','YTick',[0.5*Tb,Tb]);
    set(gca,'XTickLabel',{'R =';'2R'})
    set(gca,'YTickLabel',{'0.5*Tb';'Tb'})

elseif(hObject==handles.Polar_NRZ)
    hold off;
    A=1;
    Tb=1.5;
    R=1/Tb;
    L=2*R;
    f=0:L/50:L;
    del=0;
    P=(A.^2*Tb)*(sinc(f*Tb)).^2;
    g=plot(f,P);hold on;xlabel('Frequency');ylabel('Normalized Power');
    title('ESPECTRAL DENSITY: POLAR NRZ')
    axis([0 L 0 1.01*Tb]);set(g,'LineWidth',2.5);
    set(gca,'XTickMode','manual','XTick',[R,2*R]);grid on;
    set(gca,'YTickMode','manual','YTick',[0.5*Tb,Tb]);
    set(gca,'XTickLabel',{['R'];['2R']})
    set(gca,'YTickLabel',{['0.5*Tb'];['Tb']})

elseif(hObject==handles.Unipolar_RZ)
    hold off;
    A=2;
    Tb=1;
    R=1/Tb;
    L=2*R;
    f=0:L/50:L;
    del=0;
    P=(A.^2*Tb)/16*(sinc(f*Tb/2)).^2;
    g=plot(f,P);
    title('ESPECTRAL DENSITY: UNIPOLAR NRZ');
    hold on;xlabel('Frequency');ylabel('Normalized Power');
    axis([0 L 0 1.1*Tb]);set(g,'LineWidth',2.5);
    stem([0 R],[(A.^2*Tb)/8 P(26)+0.1],'LineWidth',2.5);hold off;
    set(gca,'XTickMode','manual','XTick',[R,2*R]);grid on;
    set(gca,'YTickMode','manual','YTick',[0.5*Tb,Tb]);
    set(gca,'XTickLabel',{['R'];['2R']})
    set(gca,'YTickLabel',{['0.5*Tb'];['Tb']})

elseif(hObject==handles.Bipolar_RZ)
    hold off;
    A=2;
    Tb=1.5;
    R=1/Tb;
    L=2*R;
    f=0:L/50:L;
    P=(A.^2*Tb)/8*(sinc(f*Tb/2)).^2.*(1-cos(2*pi*f*Tb));
    g=plot(f,P);
    title('ESPECTRAL DENSITY: BIPOLAR RZ');
    hold on;xlabel('Frequency');ylabel('Normalized Power');
    axis([0 L 0 1.1*Tb]);set(g,'LineWidth',2.5);
    set(gca,'XTickMode','manual','XTick',[R,2*R]);grid on;
    set(gca,'YTickMode','manual','YTick',[0.5*Tb,Tb]);
    set(gca,'XTickLabel',{['R'];['2R']})
    set(gca,'YTickLabel',{['0.5*Tb'];['Tb']})

else
    hold off;
    A=1;
    Tb=1.5;
    R=1/Tb;
    L=2*R;
    f=0:L/50:L;
    P=(A.^2*Tb)*(sinc(f*Tb/2)).^2.*(sin(pi*f*Tb/2)).^2;
    g=plot(f,P);
    title('ESPECTRAL DENSITY: MANCHESTER NRZ');
    hold on;xlabel('Frequency');ylabel('Normalized Power');
    axis([0 L 0 1.1*Tb]);set(g,'LineWidth',2.5);
    set(gca,'XTickMode','manual','XTick',[R,2*R]);grid on;
    set(gca,'YTickMode','manual','YTick',[0.5*Tb,Tb]);
    set(gca,'XTickLabel',{['R'];['2R']})
    set(gca,'YTickLabel',{['0.5*Tb'];['Tb']})
 
end

% --- Executes on button press in volver.
function volver_Callback(hObject, eventdata, handles)
% hObject    handle to volver (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close espec_lc;
line_code

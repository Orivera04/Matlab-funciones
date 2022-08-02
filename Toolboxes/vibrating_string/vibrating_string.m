function varargout = vibrating_string(varargin)
% 
%   This GUI demonstrates the behavior of a Vibrating String with different 
%   initial conditions. Please start with 'vibrating_string' at command window.
%   
%   Three methods are employed to solve the wave equation of 
%   vibrating string with certain initial condition. These 
%   methods are as follows; 
%   1) Finite Difference Scheme 
%   2) Fourier Scheme 
%   3) Newmark Scheme 
%
%   The string is considered to have both ends fixed and a 
%   fixed length L. It is in equilibrium along the x-axis. In order 
%   to simplify calculations following assumptions are made; 
%   i)  There is no force due to gravity 
%   ii) String has a uniform density (mass/unit length)
%
%See INFO for more detailed explanations


% Author     : Mirza Faisal Baig
% Version    : 1.1
% Date       : October 21, 2003
% Updated on : January 13, 2004
%
% Variable/Button definitions within GUIDE:
%
% Method         : Radio Buttons. Method to be selected by the user
% dx             : Text box. User defined dx value.
% dt             : Text box. User defined dt value.
% T              : Text box. User defined final time.
% a              : Text box. Constant value for the constant "a".
% Function       : PopupMenu. Function to be selected by the user.
% Display Mode   : Radio Buttons. Display selection.
% RUN/STOP       : Push Button. To run or stop animation
% INFO           : Push Button. To display help
% CLOSE          : Push Button. to close the application



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @vibrating_string_OpeningFcn, ...
                   'gui_OutputFcn',  @vibrating_string_OutputFcn, ...
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


%--------------------------------------------------------------------------
function vibrating_string_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
movegui(hObject,'onscreen')    % To display application onscreen
movegui(hObject,'center')      % To display application in the center of screen

set(handles.beta_string,'Visible','OFF');
set(handles.beta_value,'Visible','OFF');
set(handles.theta_string,'Visible','OFF');
set(handles.theta_value,'Visible','OFF');
a=0;
b = 1;  %str2num(get(handles.length_string,'String'));
Tfinal = str2num(get(handles.t_final,'String'));
DX = str2num(get(handles.d_x,'String'));
n = (b-a)/DX;
initialize_plot(hObject, eventdata, handles)
handles.n = n;
guidata(hObject, handles);

%--------------------------------------------------------------------------
function varargout = vibrating_string_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%--------------------------------------------------------------------------
function run_wave_Callback(hObject, eventdata, handles)

a = 0; 
b = 1; %str2num(get(handles.length_string,'String'));
Tfinal = str2num(get(handles.t_final,'String')); % Read final time value
DX = str2num(get(handles.d_x,'String'));         % Step size in x-axis
n = (b-a)/DX;                                    % Number of discrete points
X=linspace(a,b,n+1);                             % x-axis points

DT = str2num(get(handles.d_t,'String'));         % Steps size in time 
a1 = str2num(get(handles.const_c,'String'));     % Constant "a" see INFO for more details

% To display the waring message is stability condition is violated
if a1*DT>DX
        msgbox('a*dt>dx, for stability a*dt<=dx (see INFO for more details)','Unstable Situation','warn','modal')
    return
end

num_sine = '1';   %get(handles.no_sinewave,'String'); 
temp_sin_func = ['sin(' num_sine '*pi.*x)'];     % Defining Sine function

if get(handles.function_select,'Value') == 1
    func = inline(temp_sin_func,'x');           % Defining Sine function
elseif get(handles.function_select,'Value') == 2
    func = @plucked_string1;                    % Defining Plucked string type 1 function
elseif get(handles.function_select,'Value') == 3
    func = @plucked_string2;                    % Defining Plucked string type 2 function
end

% Loop for solving wave equation and animated display of the solution
if strcmp(get(handles.run_wave,'String'),'RUN/PLOT')
    set(handles.run_wave,'String','STOP');
    % For Finite Difference Scheme
    if get(handles.finite_diff,'Value') == 1 
        set(handles.beta_string,'Visible','OFF');
        set(handles.beta_value,'Visible','OFF');
        set(handles.theta_string,'Visible','OFF');
        set(handles.theta_value,'Visible','OFF');
        [res1,res2] = diff_scheme(func,X,DX,DT,a1,a,b,Tfinal,n);
    % For Fourier Approximation        
    elseif get(handles.fourier_appr,'Value') == 1
        set(handles.beta_string,'Visible','OFF');
        set(handles.beta_value,'Visible','OFF');
        set(handles.theta_string,'Visible','OFF');
        set(handles.theta_value,'Visible','OFF');
        [res1,res2] = fourier_scheme(func,X,Tfinal,DT);
        res1 = res1';
    % For Newmark Scheme
    elseif get(handles.newmark_sch,'Value') == 1
        set(handles.beta_string,'Visible','ON');
        set(handles.beta_value,'Visible','ON');
        set(handles.theta_string,'Visible','ON');
        set(handles.theta_value,'Visible','ON');
        beta = str2num(get(handles.beta_value,'String'));
        theta = str2num(get(handles.theta_value,'String'));
        [res1,res2] = newmark_scheme(func,X,DX,DT,a1,a,b,Tfinal,n,beta,theta);
    end
    % Display the solution with animation
    j = 2;
    % For 2D plot and animation
    if get(handles.animate2d_disp,'Value') == 1,
        axis(handles.display_plot);           % Initialize plot figure
        wave_plot = plot(X,res1(:,1)','b','LineWidth',2);grid
        set(wave_plot,'Erase','XOR')
        axis([a,b,-1.5,1.5]);
        xlabel('x')
        %ylabel('function')
    % For 3D plot and animation    
    elseif get(handles.animate3d_disp,'Value') == 1,
        axis(handles.display_plot);           % Initialize plot figure
        wave_plot = plot3(res2(1)*ones(1,length(X)),X,res1(:,1)','b','LineWidth',2);grid
        set(wave_plot,'Erase','XOR')
        axis([res2(1),res2(length(res2)),a,b,-1.5,1.5]);
        xlabel('time')
        ylabel('x')
        %zlabel('function')
    % For 3D plot 
    elseif get(handles.plot_3d,'Value') == 1,
        axis(handles.display_plot);
        res2 = res2(1:10:end);
        X = X(1:5:end);
        res1 = res1(1:5:end,1:10:end);
        surf(res2,X',res1,'FaceColor','interp','EdgeColor','none','FaceLighting','phong')
        camlight left
        view(-29.5,18)
        axis([res2(1),res2(length(res2)),a,b,-1.5,1.5]);
        xlabel('time')
        ylabel('x')
        zlabel('function')
    end
    if get(handles.plot_3d,'Value') == 0,
        set(gca,'Userdata',1);
        set(gca,'Drawmode','fast'); 
        while get(gca,'Userdata')==1 
            % For 2D animation
            if get(handles.animate2d_disp,'Value') == 1,
                set(wave_plot,'XDATA',X,'YDATA',res1(:,j),'LineWidth',2);
                drawnow;
                pause(0.01)
            % For 2D animation    
            elseif get(handles.animate3d_disp,'Value') == 1,
                set(wave_plot,'XDATA',res2(j)*ones(1,length(X)),'YDATA',X,'ZDATA',res1(:,j)','LineWidth',2);
                drawnow;
                pause(0.01)
            end
            j = j+1;
            if j > length(res2)
                set(gca,'Userdata',-1);
                set(handles.run_wave,'String','RUN/PLOT');
            end
        end
    else
        set(handles.run_wave,'String','RUN/PLOT');
    end
else
    set(gca,'Userdata',-1);
    set(handles.run_wave,'String','RUN/PLOT');
end

%--------------------------------------------------------------------------
function finite_diff_Callback(hObject, eventdata, handles)
set(handles.beta_string,'Visible','OFF');    % Make beta string invisible
set(handles.beta_value,'Visible','OFF');     % Make beta edit box invisible
set(handles.theta_string,'Visible','OFF');   % Make theta string invisible
set(handles.theta_value,'Visible','OFF');    % Make theta string invisible
set(handles.fourier_appr,'Value',0)          
set(handles.newmark_sch,'Value',0)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function fourier_appr_Callback(hObject, eventdata, handles)
set(handles.beta_string,'Visible','OFF');    % Make beta string invisible
set(handles.beta_value,'Visible','OFF');     % Make beta edit box invisible
set(handles.theta_string,'Visible','OFF');   % Make theta string invisible
set(handles.theta_value,'Visible','OFF');    % Make theta string invisible
set(handles.finite_diff,'Value',0)
set(handles.newmark_sch,'Value',0)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function newmark_sch_Callback(hObject, eventdata, handles)
set(handles.beta_string,'Visible','ON');     % Make beta string visible
set(handles.beta_value,'Visible','ON');      % Make beta edit box visible
set(handles.theta_string,'Visible','ON');    % Make theta string visible
set(handles.theta_value,'Visible','ON');     % Make theta string visible
set(handles.beta_value,'String','0.025');    % Set the default value of beta
set(handles.theta_value,'String','0.5');     % Set the default value of theta

set(handles.finite_diff,'Value',0)
set(handles.fourier_appr,'Value',0)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function animate2d_disp_Callback(hObject, eventdata, handles)
set(handles.animate3d_disp,'Value',0)
set(handles.plot_3d,'Value',0)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function animate3d_disp_Callback(hObject, eventdata, handles)
set(handles.animate2d_disp,'Value',0)
set(handles.plot_3d,'Value',0)
initialize_plot(hObject, eventdata, handles) % Initial function plot


%--------------------------------------------------------------------------
function plot_3d_Callback(hObject, eventdata, handles)
set(handles.animate2d_disp,'Value',0)
set(handles.animate3d_disp,'Value',0)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function info_Callback(hObject, eventdata, handles)
open('vibrating_string_help.html'); % Open the help file

%--------------------------------------------------------------------------
function close_button_Callback(hObject, eventdata, handles)
close(gcbf) % to close GUI

%--------------------------------------------------------------------------
function function_select_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function function_select_Callback(hObject, eventdata, handles)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function d_x_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function d_x_Callback(hObject, eventdata, handles)
DX = str2num(get(handles.d_x,'String'));
DT = str2num(get(handles.d_t,'String'));
a1 = str2num(get(handles.const_c,'String'));
if a1*DT>DX
    msgbox('a*dt>dx, for stability a*dt<=dx (see INFO for more details)','Unstable Situation','warn','modal')
    return
end
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function d_t_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function d_t_Callback(hObject, eventdata, handles)
DX = str2num(get(handles.d_x,'String'));
DT = str2num(get(handles.d_t,'String'));
a1 = str2num(get(handles.const_c,'String'));
if a1*DT>DX
    msgbox('a*dt>dx, for stability a*dt<=dx (see INFO for more details)','Unstable Situation','warn','modal')
    return
end
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function const_c_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function const_c_Callback(hObject, eventdata, handles)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function t_final_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function t_final_Callback(hObject, eventdata, handles)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function beta_value_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function beta_value_Callback(hObject, eventdata, handles)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function theta_value_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function theta_value_Callback(hObject, eventdata, handles)
initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function initialize_plot(hObject, eventdata, handles)

a = 0;
b = 1;  %str2num(get(handles.length_string,'String'));
n=200;
X=linspace(a,b,n+1);
Tfinal = str2num(get(handles.t_final,'String'));
DT = str2num(get(handles.d_t,'String'));
T = 0:DT:Tfinal;
axis(handles.display_plot);

a1 = str2num(get(handles.const_c,'String'));
num_sine = '1'; %get(handles.no_sinewave,'String');
temp_sin_func = ['sin(' num_sine '*pi.*x)'];

if get(handles.function_select,'Value') == 1
    func = inline(temp_sin_func,'x');
elseif get(handles.function_select,'Value') == 2
    func = @plucked_string1;
elseif get(handles.function_select,'Value') == 3
    func = @plucked_string2;
elseif get(handles.function_select,'Value') == 4
    func = @square_wave;    
end
Y = feval(func,X);
%save temp1.mat
if get(handles.animate2d_disp,'Value') == 1,
    %wave_plot = plot(X,zeros(1,length(X))','b','LineWidth',2);grid
    wave_plot = plot(X,Y,'b','LineWidth',2);grid
    %set(wave_plot,'Erase','Normal')
    set(wave_plot,'Erase','XOR')
    axis([a,b,-1.5,1.5]);
    xlabel('x')
elseif get(handles.animate3d_disp,'Value') == 1,
    T = zeros(1,length(X));
    %z = zeros(length(X),length(X));
    %Y = [Y;T];
    %wave_plot = plot3(T,X,z','b','LineWidth',2);grid
    wave_plot = plot3(T,X,Y,'b','LineWidth',2);grid
    set(wave_plot,'Erase','XOR')
    axis([0,Tfinal,a,b,-1.5,1.5]);
    xlabel('time')
    ylabel('x')
    zlabel('function')
elseif get(handles.plot_3d,'Value') == 1,
    reset(gca);
    T = zeros(1,length(X));
    z = zeros(length(T),length(X));
    T = T(1:15:end);
    X = X(1:10:end);
    z = z(1:15:end,1:10:end);
    
    %wave_plot = surf(T,X,z'); shading flat
    wave_plot = surf(T,X,z','FaceColor','interp','EdgeColor','none','FaceLighting','phong');
    %wave_plot = surf(T,X,z','FaceColor','interp','EdgeColor','none','FaceLighting','phong');
    camlight left
    view(-29.5,18)
    axis([0,Tfinal,a,b,-1.5,1.5]);
    xlabel('time')
    ylabel('x')
    zlabel('function')
end


% EOF

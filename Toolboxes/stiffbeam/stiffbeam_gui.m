function varargout = stiffbeam_gui(varargin)
% 
%   This GUI demonstrates the solution of the ordinary differential equation
%   system of a vibrating stiff beam using defferent methods.
%
%   The methods are as follows;
%
%   1) Euler Explicit
%   2) Euler Modified
%   3) Heun
%   4) Klass. Runge-Kutta 4 
%   5) Hammer & Hollingworth 4 (implicit); Inner Iteration
%   6) Hammer & Hollingworth 4 (implicit); Newton Iteration
%   7) Adam-Bashforth 4 (explicit)
%   8) Adam-Moulten 4 (implicit)
%   9) Adams-Bashforth-Moulton 4
%  10) BDF-Verfahren 4 (implicit); Inner Iteration
%  11) BDF-Verfahren 4 (implicit); Newton Iteration
%  12) BDF-Verfahren 2 (implicit); Inner Iteration
%  13) BDF-Verfahren 2 (implicit); Newton Iteration
%
%  See INFO for more detailed explainations of these methods
%  Please start with 'stiffbeam_gui' at command window.

% Author : Mirza Faisal Baig
% Version: 1.0
% Date   : January 15, 2004
%
% Variable/Button definitions within GUIDE:
%
% Method         : Radio Buttons. Method to be selected by the user
% T              : Text box. User defined final time.
% S              : Text box. User defined space discretization value.
% n              : Text box. User defined time discretization value.
% Plot Steps     : Text box. User defined steps for plotting the next frame.
% RUN/STOP       : Push Button. To run or stop plotting
% RESET          : Push Bottum. To reset the figure.
% INFO           : Push Button. To display help
% CLOSE          : Push Button. to close the application


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stiffbeam_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @stiffbeam_gui_OutputFcn, ...
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
function stiffbeam_gui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
movegui(hObject,'onscreen')    % To display application onscreen
movegui(hObject,'center')      % To display application in the center of screen
axis off
guidata(hObject, handles);

%--------------------------------------------------------------------------
function varargout = stiffbeam_gui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%--------------------------------------------------------------------------
function run_Callback(hObject, eventdata, handles)

verf = get(handles.method_select,'Value');

T = str2num(get(handles.t_final,'String'));        % Read final time value
S = str2num(get(handles.space_dis,'String'));      % Step size in x-axis
n = str2num(get(handles.time_space,'String'));     % Steps size in time 

% Anzahl der Schritte
plott = str2num(get(handles.plot_steps,'String')); % Steps in plot the results
% Gleichung
equation = 'BEAMODE';

time = [0; T];
%time(2) = T;

% Anfangsbedingungen
y0 = zeros(S,1);
%y0(S,1) = 0.4; %modifizierte AB, welche zu Oszillationen führt
v0 = zeros(S,1);

% Anfangszeitpunkt
tt(1) = time(1);

% Schrittweite
h = (time(2)-time(1))/n;
% Anfangswerte
y = [y0; v0];

% Anfangskoordinaten berechnen
dS = 1/S; 
xxold(1) = 0; yyold(1) = 0; 
for j = 1 : S
	xxold(j+1) = xxold(j) + dS*cos(y(j,1));
	yyold(j+1) = yyold(j) + dS*sin(y(j,1));
end
if strcmp(get(handles.run,'String'),'RUN/PLOT')
    cla;
    set(handles.run,'String','STOP');
    % Grafikkonfiguration setzen
    %wave_plot = plot3(tt(1)*ones(1,S+1),yyold,xxold,'k-');
    wave_plot = fill3(tt(1)*ones(1,S+1),yyold,xxold,'k-');
    set(gca,'YDir','reverse')
    axis off;
    view([-5,-5,6])
    %set(gca,'CameraViewAngleMode','Manual')
    
    % Löser für Einschrittverfahren
        if verf <= 6
	        for k = 1:n
	        	tt(k+1) = time(1) + k*h;
	        	switch verf
	        	 case 1
	        		y(:,k+1) = EULER(equation, tt(k), y(:,k), h, '');
	        	 case 2
	        		y(:,k+1) = EULERMOD(equation, tt(k), y(:,k), h, '');
	        	 case 3
                     y(:,k+1) = HEUN(equation, tt(k), y(:,k), h, '');
                 case 4
                     y(:,k+1) = RK4(equation, tt(k), y(:,k), h, '');
                 case 5
                     [y(:,k+1), ll(k)] = RK4IMPL(equation, tt(k), y(:,k), h, '');
                 case 6
                     [y(:,k+1), ll(k)] = RK4IMPL_NEWTON(tt(k), y(:,k), h, '');
             end % end swtich
		
        	 % Berechnung der (x,y)-Punkte
             if (mod(k,plott) == 0) | (k==n)
                 xx(1) = 0; yy(1) = 0;
                 for j = 1 : S
                     xx(j+1) = xx(j) + dS*cos(y(j,k));
                     yy(j+1) = yy(j) + dS*sin(y(j,k));
                 end
			
			     hold on
			     help = ones(1,S+1);
			     %patch([tt(k-plott+1)*help, tt(k+1)*help],...
			     %		[yyold, yy(S+1:-1:1)],[xxold, xx(S+1:-1:1)],...
			     %			[0.7, 1.0, 0.7]);
		         x_plot = [tt(k-plott+1)*help, tt(k+1)*help];
                 y_plot = [yyold, yy(S+1:-1:1)];
                 z_plot = [xxold, xx(S+1:-1:1)];
                 fill3(x_plot,y_plot,z_plot,[0.7, 1.0, 0.7])
                 pause (0.05)
                 yyold = yy;
			     xxold = xx;
                 if strcmp(get(handles.run,'String'),'RUN/PLOT');
                     return
                 end
             end % end if mod
         end % end for k
         set(handles.run,'String','RUN/PLOT')
     end; % end if verf
     
     if (verf==12) | (verf==13)
         anlaufstep = 2;
     else
         anlaufstep = 4;
     end
     
     % Löser für Mehrschrittverfahren
     if verf > 6
         fvec = zeros(size(y,1),n+1);
         fvec(:,1) = feval(equation, tt(1), y(:,1), '');	
         % Anlaufrechnung
         for i = 1:anlaufstep
             tt(i+1) = time(1) + i*h;
             y(:,i+1) = RK4(equation, tt(i), y(:,i), h, '');
             tt(i+1) = time(1) + i*h;
             fvec(:,i+1) = feval(equation, tt(i), y(:,i+1),'');
         end
	
	     % Berechnung der (x,y)-Punkte
         if (mod(i,plott) == 0) | (i==n)
             xx(1) = 0; yy(1) = 0;
             for j = 1 : S
                 xx(j+1) = xx(j) + dS*cos(y(j,i));
                 yy(j+1) = yy(j) + dS*sin(y(j,i));
             end			
             hold on
             help = ones(1,S+1);
             %patch([tt(i-plott+1)*help, tt(i+1)*help],...
             %    [yyold, yy(S+1:-1:1)],[xxold, xx(S+1:-1:1)],...
             %                    [0.7, 1.0, 0.7]);
             x_plot = [tt(i-plott+1)*help, tt(i+1)*help];
             y_plot = [yyold, yy(S+1:-1:1)];
             z_plot = [xxold, xx(S+1:-1:1)];
             fill3(x_plot,y_plot,z_plot,[0.7, 1.0, 0.7])                 
			 yyold = yy;
			 xxold = xx;
			 pause(0.05);
             %if strcmp(get(handles.run,'String'),'RUN/PLOT');
                 %disp('i am here in the with break command loop')
             %    return
             %end            
         end % end if mod
        %set(handles.run,'String','RUN/PLOT')
        for i = anlaufstep+1:n
             tt(i+1) = time(1) + i*h;
            switch verf
                case 7
                    y(:,i+1) = AB4(y(:,i), fvec(:,i-3:i), h);
                    fvec(:,i+1) = feval(equation, tt(i+1), y(:,i+1), '');
                case 8
                    yp = AB4(y(:,i), fvec(:,i-3:i), h);
                    fvec(:,i+1) = feval(equation, tt(i+1), yp,'');
                    [y(:,i+1),l] = AM4(equation,tt(i+1),y(:,i),fvec(:,i-2:i+1),h,[]);
                    fvec(:,i+1) = feval(equation, tt(i+1), y(:,i+1), '');
                case 9
                    yp = AB4(y(:,i), fvec(:,i-3:i), h);
                    fvec(:,i+1) = feval(equation, tt(i+1), yp,'');
			        y(:,i+1) = ABM4(y(:,i), fvec(:,i-2:i+1), h);
			        fvec(:,i+1) = feval(equation, tt(i+1),y(:,i+1),'');
		        case 10
                    [y(:,i+1),ll(i)] = BDF4(equation, tt(i),y(:,i-3:i),h,[]);
                case 11
                    [y(:,i+1),ll(i)] = BDF4_NEWTON(equation,tt(i),y(:,i-3:i),h,[]);
                case 12
                    [y(:,i+1),ll(i)] = BDF2(equation,tt(i),y(:,i-1:i),h,[]);
                case 13
                    [y(:,i+1),ll(i)] = BDF2_NEWTON(equation,tt(i),y(:,i-1:i),h,[]);
            end % end switch verf
		
		    % Berechnung der (x,y)-Punkte
            if (mod(i,plott) == 0) | (i==n)
                xx(1) = 0; yy(1) = 0;
                for j = 1 : S
                    xx(j+1) = xx(j) + dS*cos(y(j,i));
                    yy(j+1) = yy(j) + dS*sin(y(j,i));
                end
			    hold on
			    help1 = ones(1,S+1);
                %patch([tt(i-plott+1)*help1, tt(i+1)*help1],...
                %    [yyold, yy(S+1:-1:1)],[xxold, xx(S+1:-1:1)],...
                %    [0.7, 1.0, 0.7]);
                x_plot = [tt(i-plott+1)*help1, tt(i+1)*help1];
                y_plot = [yyold, yy(S+1:-1:1)];
                z_plot = [xxold, xx(S+1:-1:1)];
                fill3(x_plot,y_plot,z_plot,[0.7, 1.0, 0.7])                 
                yyold = yy;
                xxold = xx;
                pause(0.05);
                if strcmp(get(handles.run,'String'),'RUN/PLOT');
                    %disp('i am here in the with break command loop')
                    return
                end
            end
           
        end
        set(handles.run,'String','RUN/PLOT')
    end;

else
   set(handles.run,'String','RUN/PLOT');
   %disp('OUT')
   return
end, % run/stop if



%--------------------------------------------------------------------------
%function animate_2d_Callback(hObject, eventdata, handles)
%set(handles.animate_3d,'Value',0)
%initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
%function animate_3d_Callback(hObject, eventdata, handles)
%set(handles.animate_2d,'Value',0)
%initialize_plot(hObject, eventdata, handles) % Initial function plot

%--------------------------------------------------------------------------
function info_Callback(hObject, eventdata, handles)
open('stiffbeam_gui_help.html'); % Open the help file

%--------------------------------------------------------------------------
function close_button_Callback(hObject, eventdata, handles)
close(gcbf) % to close GUI

%--------------------------------------------------------------------------
function method_select_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function method_select_Callback(hObject, eventdata, handles)

method_value = get(handles.method_select,'Value');

switch method_value
    case 1
        set(handles.time_space,'String','50000')
        set(handles.plot_steps,'String','1000')
    case 2
        set(handles.time_space,'String','2600')
        set(handles.plot_steps,'String','80')
    case 3
        set(handles.time_space,'String','2600')
        set(handles.plot_steps,'String','80')
    case 4
        set(handles.time_space,'String','430')
        set(handles.plot_steps,'String','5')
    case 5
        set(handles.time_space,'String','360')
        set(handles.plot_steps,'String','5')
    case 6
        set(handles.time_space,'String','50')
        set(handles.plot_steps,'String','1')
    case 7
        set(handles.time_space,'String','2856')
        set(handles.plot_steps,'String','100')
    case 8
        set(handles.time_space,'String','1350')
        set(handles.plot_steps,'String','30')
    case 9
        set(handles.time_space,'String','1350')
        set(handles.plot_steps,'String','30')
    case 10
        set(handles.time_space,'String','2300')
        set(handles.plot_steps,'String','50')
    case 11
        set(handles.time_space,'String','2300')
        set(handles.plot_steps,'String','50')
    case 12
        set(handles.time_space,'String','825')
        set(handles.plot_steps,'String','2')
    case 13
        set(handles.time_space,'String','80')
        set(handles.plot_steps,'String','2')
end        
cla;

%--------------------------------------------------------------------------
function space_dis_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function space_dis_Callback(hObject, eventdata, handles)
cla;

%--------------------------------------------------------------------------
function time_space_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function time_space_Callback(hObject, eventdata, handles)
cla;

%--------------------------------------------------------------------------
function t_final_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function t_final_Callback(hObject, eventdata, handles)
cla;

%--------------------------------------------------------------------------
function plot_steps_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function plot_steps_Callback(hObject, eventdata, handles)
cla;

%--------------------------------------------------------------------------
function reset_com_Callback(hObject, eventdata, handles)
cla;

% EOF



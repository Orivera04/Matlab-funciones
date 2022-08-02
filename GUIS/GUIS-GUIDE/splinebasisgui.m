function varargout = splinebasisgui(varargin)
% 
%   This GUI visualizes the basis functions of spline
%   spaces. Different bases can be chosen from the following:
%
%   1) B-Splines
%   2) Cardinal Splines
%   3) Naive Basis Functions (used for theoratical considerations)
%
%   For the B-Splines and the Naive basis functions, the approximation 
%   order can be chosen with the parameter k, for the Cardial Splines
%   always cubic splines are considered (k=4). 
%
%   The index n specifies the number of grid points (n+1) on the reference
%   interval [0,1], the nodes are indexed with i = 0,...,n. The index i
%   specifies the node for which the associated basis function(s) are
%   plotted.
%
%   Reference: 
%     [1] Deuflhard, Hohmann: Numerische Mathematik 1, deGruyter, 2002.


% Author     : Mirza Faisal Baig
% Version    : 1.0
% Date       : April, 21, 2004
%
% Variable/Button definitions within GUIDE:
%
% Grid           : Menu Option. Swicth grid ON and OFF
% k              : Text box. User defined value of k.
% i              : Text box. User defined value of i.
% n              : Text box. User defined value of n.
% RUN/STOP       : Push Button. To run/plot or stop animation
% INFO           : Push Button. To display help
% CLOSE          : Push Button. To close the application

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @splinebasisgui_OpeningFcn, ...
                   'gui_OutputFcn',  @splinebasisgui_OutputFcn, ...
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
function splinebasisgui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
movegui(hObject,'onscreen')              % To display application onscreen
movegui(hObject,'center')                % To display application in the center of screen
set(handles.gridopt,'checked','off')     % To check the grid option
handles.Leg = [];                        % Initialize Leg variable for later use
guidata(hObject, handles);

%--------------------------------------------------------------------------
function varargout = splinebasisgui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

%--------------------------------------------------------------------------
function run_wave_Callback(hObject, eventdata, handles)
LegendVar = [];
NoX = 501;
if get(handles.splinetype,'value') == 1      % loop for B-Splines
    i = str2num(get(handles.i,'String'));    % get value of i
    k = str2num(get(handles.k,'String'));    % get value of k
    n = str2num(get(handles.n,'String'));    % get value of n
    if (i+k) > n+1
        msgbox('"i+k" should be less than or equal to "n+1"', ...
            'Warning','None','modal')    
        return
    end
    if i < 1
        msgbox('"i" should be greater than "0"', ...
            'Warning','None','modal')    
        return
    end
    i1 = i; xi = linspace(0,1,n+1); x = linspace(0,1,NoX);
    N = zeros(i,length(x),k);
    for kk = 1:k
        for p = 1:length(x)
            if xi(i1) <= x(p) & xi(i1+1) > x(p)
                N(i1,p,1) = 1;
            end
        end
        i1 = i1+1;
    end
    i1 = i1-2;
    for kk = 2:k
        for ii = i:i1,
             N(ii,:,kk) = ((x-xi(ii))./(xi(ii+kk-1)-xi(ii))).*N(ii,:,kk-1)+ ...
                ((xi(ii+kk)-x)./(xi(ii+kk)-xi(ii+1))).*N(ii+1,:,kk-1);
        end 
        i1 = ii-1;
    end 
    line_pattern = ['   ';'b  ';'g-.';'m-.';'c-.';'r-.';'y-.';'k-.';...
            'bs-';'gs-';'ms-';'cs-';'rs-';'ys-';'ks-';'bd-';'gd-';'rd-';'cd-';'md-';'yd-';'kd-';...
            'bv-';'gv-';'mv-';'cv-';'rv-';'yv-';'kv-';'b<-';'g<-';'r<-';'c<-';'m<-';'y<-';'k<-';...
            'b>-';'g>-';'m>-';'c>-';'r>-';'y>-';'k>-';'bp-';'gp-';'rp-';'cp-';'mp-';'yp-';'kp-';...
            'bh-';'gh-';'mh-';'ch-';'rh-';'yh-';'kh-'];
    
    h = stairs(x,N(i,:,1),':');
    set(h,'LineWidth',1.5)
    legend1(1).text = 'N_i_1';
    hold on
    for ni = 2:k,
        plot(x,N(i,:,ni),line_pattern(ni,:),'LineWidth',1.5)
        legend1(ni).text = ['N_i_' num2str(ni)];
    end
    LegendVar = legend(legend1.text);
		set(LegendVar,'FontSize',12);
    axis([0 x(end) -0.05 1.05])
    hold off
    
elseif get(handles.splinetype,'Value') == 2       % loop for Cardinal Spline
    n = str2num(get(handles.n,'String'));         % get value of n   
    i = str2num(get(handles.i,'String'));         % get value of i
    if rem(n,2)~=0
        msgbox('"n" should be an even integer','Warning','None','modal')
        return
    end
    if i > n+2
        msgbox('"i" should be less than or equal to "n+2"','Warning','None','modal')
        return
    end
    if i < 1
        msgbox('"i" should be greater than "0"', ...
            'Warning','None','modal')    
        return
    end
    x = linspace(0, 1, n+1);
    y=zeros(n+3,1); y(i) = 1; xx=0:0.01:1;
    yy=spline(x,y,xx);
    plot(xx,yy,'r-','LineWidth',1.5); hold on;
    plot(x,0*x,'k-d','LineWidth',1.5); hold off
    
elseif get(handles.splinetype,'Value') == 3     % loop for Naive Basis Function
    i = str2num(get(handles.i,'String'));       % get value of i   
    k = str2num(get(handles.k,'String'));       % get value of k
    if k < 2
        msgbox('"k" should be greater than or equal to "2"','Warning','None','modal')
        return
    end
     if i < 0
        msgbox('"i" should be greater than or equal to "0"', ...
            'Warning','None','modal')    
        return
    end
    n = str2num(get(handles.n,'String'));       % get value of n
    xi = linspace(0,1,n+1); x = linspace(0,1,NoX);
    for in1 = 0:k-2,N1(in1+1,:) = (x-xi(1)).^in1; end
    for p = 1:length(x)
        if x(p) >= xi(i+1)
            N2(p) = (x(p)-xi(i+1))^(k-1);
        elseif x(p) < xi(i+1)
            N2(p) = 0;
        end
    end
    plot(x,N2,'r-.','Linewidth',1.5)
    line_pattern = ['b- ';'g- ';'r- ';'k- ';'m- ';'c- ';'y- '; ...
                    'bs-';'gs-';'ms-';'cs-';'rs-';'ys-';'ks-';'bd-';'gd-';'rd-';'cd-';'md-';'yd-';'kd-'; ...
                    'bv-';'gv-';'mv-';'cv-';'rv-';'yv-';'kv-';'b<-';'g<-';'r<-';'c<-';'m<-';'y<-';'k<-'; ...
                    'b>-';'g>-';'m>-';'c>-';'r>-';'y>-';'k>-';'bp-';'gp-';'rp-';'cp-';'mp-';'yp-';'kp-'; ...
                    'bh-';'gh-';'mh-';'ch-';'rh-';'yh-';'kh-'];
            
    legend2.text = ['N_' num2str(i)];
    [RowN1,ColN1] = size(N1);
    if i == 0,
        hold on
        for jj = 1:RowN1,
            plot(x,N1(jj,:),line_pattern(jj,:),'Linewidth',1.5)
            legend2(jj+1).text = ['N_i_' num2str(jj-1)];
        end
    end
    LegendVar = legend(legend2.text,2);
		set(LegendVar,'FontSize',12);
    axis([0 x(end) -0.05 1.05]);
    hold off
end

if strcmp(get(handles.gridopt,'checked'),'off')
    set(handles.display_plot,'XGrid','Off','YGrid','Off','ZGrid','Off') % Make the grid invisible
else 
    set(handles.display_plot,'XGrid','On','YGrid','On','ZGrid','On')   % Make the grid visible
end
handles.Leg = LegendVar;
guidata(hObject, handles);

%--------------------------------------------------------------------------
function info_Callback(hObject, eventdata, handles)
helpwin('splinebasisgui.m')

%--------------------------------------------------------------------------
function close_button_Callback(hObject, eventdata, handles)
close(gcbf) % to close GUI

%--------------------------------------------------------------------------
% Executes on button press in save_plot.
function save_plot_Callback(hObject, eventdata, handles)

h = get(gcf,'CurrentAxes');
figure(1);
copyobj(h,gcf);
set(gca,'FontSize',12);
c = copyobj(handles.Leg,gcf);
set(gcf, 'PaperPosition', [2 1 8 4]);
print( gcf, '-depsc2', 'plot.eps' );
close(1);


%--------------------------------------------------------------------------
function i_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function i_Callback(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function k_CreateFcn(hObject, eventdata, handles)

%--------------------------------------------------------------------------
function k_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function Gridmenu_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function grid_onoff_Callback(hObject, eventdata, handles)
if strcmp(get(handles.gridopt,'checked'),'on')
    set(handles.gridopt,'checked','off')           % To uncheck the grid option
    set(handles.display_plot,'XGrid','Off','YGrid','Off','ZGrid','Off') % Make the grid invisible
else 
    set(handles.gridopt,'checked','on')            % To check the grid option
    set(handles.display_plot,'XGrid','On','YGrid','On','ZGrid','On')   % Make the grid visible
end
% --------------------------------------------------------------------
function splinetype_CreateFcn(hObject, eventdata, handles)

% --------------------------------------------------------------------
function splinetype_Callback(hObject, eventdata, handles)
delete(handles.Leg);
handles.Leg = [];    
cla;
if get(handles.splinetype,'Value')==1
    set(handles.k,'Enable','On')
    set(handles.n,'String','10')
    set(handles.i,'String','2')
elseif get(handles.splinetype,'Value') == 2
    set(handles.k,'Enable','Off')
    set(handles.n,'String','6')
    set(handles.i,'String','5')
elseif get(handles.splinetype,'Value') == 3
    set(handles.k,'Enable','On')
    set(handles.n,'String','10')
    set(handles.i,'String','5')
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function n_CreateFcn(hObject, eventdata, handles)

% --------------------------------------------------------------------
function n_Callback(hObject, eventdata, handles)


% EOF
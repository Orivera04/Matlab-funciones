function varargout = gradient_gui(varargin)
%      This GUI demonstrates Gradient and Conjugate Gardient methods in 2 dimensions.
%      Please start with 'gradient_gui' at command window. 
%
%      Basically, it tries to find the solution to the following 
%      system of equations,
%
%               Ax = b,
%                    
%       where,  A is 2x2 symmetric and non-singular matrix
%               b is column vector
%               x is unknown solution vector
%
% Author : Mirza Faisal Baig
% Version: 1.0
% Date   : May 21, 2003
%
% Variable definitions within GUIDE:
%
% method      : PopupMenu. Method to be selected by the user
% a_matrix    : Text box. User defined matrix.
% vector_b    : Text box. User defined vector.
% tol         : Text box. User defined tolerence.
% x_init      : Text box. User defined initial guess (starting point).
% current_x   : Text box. To display the current point.
% exact_x     : Text box. To display the exact solution.
% iter        : Text box. To display number of iterations so far.
% x_1         : Text box. To display the first element of solution vector in the solution text box.
% x_2         : Text box. To display the second element of solution vector in the solution text box.
% next        : Push Button. To Start/Next iteration
% clear       : Push Button. To start over and clear the plot figure
% save plot   : Push Button. To save the plot figure to file
% info        : Push Button. To display help
% close       : Push Button. to close the application


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gradient_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gradient_gui_OutputFcn, ...
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes just before gradient_gui is made visible.
function gradient_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
movegui(hObject,'onscreen')% To display application onscreen
movegui(hObject,'center')  % To display application in the center of screen
A = str2num(get(handles.a_matrix,'String')); % To read matrix A
b = str2num((get(handles.vector_b,'String'))); % To read vector b
x_init = str2num((get(handles.x_init,'String'))); % To read value of initial guess for solution
% To find limits of curve, so the plot is in the center of figure
[xlim,ylim] = xy_lim(A,b,x_init);
set(handles.axes1,'XLim',xlim,'YLim',ylim);
axis equal;

plot_function(A,b,x_init)% To plot the curve
plot(x_init(1),x_init(2),'ro','LineWidth',2,'MarkerFaceColor','r') % To plot current point on the curve in red circle
x_string = ['[' num2str(x_init(1)) ';' num2str(x_init(2)) ']'];% To convert current_x variable to string form
set(handles.current_x,'String',x_string);   % Update the current_x display value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs from this function are returned to the command line.
function varargout = gradient_gui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function a_matrix_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a_matrix_Callback(hObject, eventdata, handles)

A = str2num(get(handles.a_matrix,'String'));   % To read matrix A
% To check whether matrix A is symetric and non-singular
if isequal(A,A')== 0 | det(A)==0
    errordlg('Matrix A is either singular or not symetric','Error','modal') % Display error message
else
    clear_Callback(hObject, eventdata, handles)% To reset and update figure, if A matrix is changed
end
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function vector_b_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function vector_b_Callback(hObject, eventdata, handles)
clear_Callback(hObject, eventdata, handles) % To reset and update figure, if b vector is changed 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function x_init_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x_init_Callback(hObject, eventdata, handles)
clear_Callback(hObject, eventdata, handles) % To reset and update figure, if initial guess vector is changed 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on button press in next_iter.
function next_iter_Callback(hObject, eventdata, handles)
format long % To change the format to long, for better solution

A = str2num(get(handles.a_matrix,'String'));   % To read matrix A
%To check whether matrix A is symetric and non-singular
if isequal(A,A')== 0 | det(A)==0
    errordlg('Matrix A is either singular or not symetric','Error','modal')% Display error message
    set(handles.continue_flag,'String',1)
else
    set(handles.continue_flag,'String',0)
end

% To check for the continue_flag value which indicates whether the solution
% have been found or not. 
if get(handles.continue_flag,'String') == '0' 
    b = str2num((get(handles.vector_b,'String'))); % To read vector b
    tol = str2num(get(handles.tol,'String'));      % To read tolerence value
    iter = str2num(get(handles.iter,'String'));    % Read iteration number from GUI
    if iter < 1    % To read and calculate initial values of variables
        current_x = str2num(get(handles.current_x,'String')); % To get current_x value if not first iteration
        r_init = A*current_x-b;
        p_init = r_init;
        rou_init = r_init'*r_init;
    else          % To read updated values of variables
        current_x = str2num(get(handles.next_x,'String'));  % To get current_x value if not first iteration
        r_init = str2num(get(handles.r_init,'String'));     % Get r_init from dummy variable
        p_init = str2num(get(handles.p_init,'String'));     % Get p_init from dummy variable
        rou_init = str2num(get(handles.rou_init,'String')); % Get rou_init from dummy variable
    end        
    iter = iter + 1; % Increment iteration number by 1
    set(handles.iter,'String',iter); % Update iteration number within GUI
    
    global old % Set old.x variable as global, so it could be used any where during program execution
    old(iter).x = current_x; % Assign current_x value to old.x variable
    if get(handles.method_menu,'Value') == 1
        [x,err] = hw_gradient(A,b,current_x,tol); % Function to calculate new x and error
    else
        [x,rou] = hw_conjgrad(A,b,current_x,tol,r_init,p_init,rou_init,handles); % Function to calculate new x and rou
    end
    current_x = x; % Update current_x value
    plot_function(A,b,current_x)    % Function to plot the curve
    plot(current_x(1),current_x(2),'ro','LineWidth',2,'MarkerFaceColor','r') % To plot current point on the curve in red circle
    
    % To plot the line between current and previous point
    plot([old(iter).x(1) current_x(1)],[old(iter).x(2) current_x(2)],'k','LineWidth',2) 
    plot([old(iter).x(1) current_x(1)],[old(iter).x(2) current_x(2)],'ro','LineWidth',2,'MarkerFaceColor','r')                                 
    
    next_x_string = ['[' num2str(current_x(1)) ';' num2str(current_x(2)) ']']; % To convert current_x variable to string form
    set(handles.next_x,'String',next_x_string);   % Update the current_x display value
    % To convert current_x variable to string form
    current_x_string = ['[' num2str(current_x(1),4) ';' num2str(current_x(2),4) ']']; 
    set(handles.current_x,'String',current_x_string) % Update the current_x display value
    % Stopping criterion and to determine which method is used
    if get(handles.method_menu,'Value') == 1
        if tol > err
            % To convert current_x variable to string form
            current_x_string = ['[' num2str(current_x(1),4) ';' num2str(current_x(2),4) ']'];
            set(handles.current_x,'String',current_x_string);   % Update the current_x display value
            % To display found solution
            set(handles.x_1,'String',num2str(current_x(1),4))   
            set(handles.x_2,'String',num2str(current_x(2),4))
            x_exact = A\b; %To find exact solution
            % To display exact solution
            set(handles.x1_exact,'String',num2str(x_exact(1),4))
            set(handles.x2_exact,'String',num2str(x_exact(2),4))
            set(handles.continue_flag,'String','1') % Update continue_flag
            set(handles.next_iter,'Enable','Off')   % Disable next button when solution is found
            warndlg('Press OK to continue','!!!Solution found','modal') % Display message when solution is found
        end % End of (if tol>err)
    else
        if rou <= tol*rou_init
            % To convert current_x variable to string form
            current_x_string = ['[' num2str(current_x(1),4) ';' num2str(current_x(2),4) ']'];
            set(handles.current_x,'String',current_x_string);   % Update the current_x display value
            % To display found solution
            set(handles.x_1,'String',num2str(current_x(1),4))
            set(handles.x_2,'String',num2str(current_x(2),4))
            x_exact = A\b;%To find exact solution
            % To display exact solution
            set(handles.x1_exact,'String',num2str(x_exact(1),4))
            set(handles.x2_exact,'String',num2str(x_exact(2),4))
            set(handles.continue_flag,'String','1') % Update continue_flag
            set(handles.next_iter,'Enable','Off')   % Disable next button when solution is found
            warndlg('Press OK to continue','!!!Solution found','modal') % Display message when solution is found
        end % End of (if rou <= tol*rou_init)
    end % End of (if get(handles.method_menu,'Value') == 1)
end %flag_continue




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function tol_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function tol_Callback(hObject, eventdata, handles)
clear_Callback(hObject, eventdata, handles)% To reset and update figure, if tolerance value is changed

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function current_x_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function current_x_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function next_x_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function next_x_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function iter_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function iter_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)

cla; % To clear figure
set(handles.current_x,'String','');
set(handles.iter,'String','0');
set(handles.continue_flag,'String','0')
set(handles.next_iter,'Enable','On')
set(handles.x_1,'String','')
set(handles.x_2,'String','')
set(handles.x1_exact,'String','')
set(handles.x2_exact,'String','')
A = str2num(get(handles.a_matrix,'String'));      % To read matrix A
b = str2num((get(handles.vector_b,'String')));    % To read vector b
x_init = str2num((get(handles.x_init,'String'))); % To read value of initial guess for solution

% To find limits of curve, so the plot is in the center of the figure
[xlim,ylim] = xy_lim(A,b,x_init);
set(handles.axes1,'XLim',xlim,'YLim',ylim)

plot_function(A,b,x_init)
plot(x_init(1),x_init(2),'ro','LineWidth',2,'MarkerFaceColor','r') % To plot current point on the curve in red circle
x_string = ['[' num2str(x_init(1)) ';' num2str(x_init(2)) ']'];    % To convert current_x variable to string form
set(handles.current_x,'String',x_string);   % Update the current_x display value

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function method_menu_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on selection change in method_menu.
function method_menu_Callback(hObject, eventdata, handles)
clear_Callback(hObject, eventdata, handles) % To reset and update figure, if method selected is changed


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes during object creation, after setting all properties.
function continue_flag_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function continue_flag_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
clear all
format short
close(gcbf)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on button press in info.
function info_Callback(hObject, eventdata, handles)

helpwin('gradient_gui.m')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Executes on button press in save_plot.
function save_plot_Callback(hObject, eventdata, handles)

h = get(gcf,'CurrentAxes');
figure(1);
copyobj(h,gcf);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperPosition', [2 1 12 12]);
set(gca,'FontSize',24);
print( gcf, '-depsc2', 'plot.eps' );
close(1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,err] = hw_gradient(A,b,x_init,tol)
% Function to solve system of linear equations using gradient method
% Input:
%        Matrix A, vectro b, x_init(initial guess), tolerance
%
% Ouput:
%        Next x value and error


r = b-A*x_init;
alpha = (r'*r)/(r'*A*r);
x = x_init + alpha * r;
r = b-A*x;
alpha = (r'*r)/(r'*A*r);
if (norm(b) < 1e-09)
	err = norm(r);
else
	err = norm(r)/norm(b);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x,rou] = hw_conjgrad(A,b,x_init,tol,r_init,p_init,rou_init,handles)
% Function to solve system of linear equations using conjugate gradient method
% Input:
%        Matrix A, vectro b, x_init(initial guess), tolerance,
%        initial r, initial p, initial rou and figure handles  
%
% Ouput:
%        Next x and next rou values
%
%   I also saves next calculated values of r, p and rou to predefined dummy
%   variables within GUI


s = A * p_init;
sigma = s'*p_init;
alpha = rou_init/sigma;
x = x_init - alpha * p_init;
r = r_init - alpha * s;
rou = r'*r;
beta = rou / rou_init;
p = r + beta*p_init;
set(handles.r_init,'String',num2str(r));     % save r_init in dummy variable
set(handles.p_init,'String',num2str(p));     % save p_init in dummy variable
set(handles.rou_init,'String',num2str(rou)); % save rou_init in dummy variable        


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x_lim,y_lim] = xy_lim(A,b,x_init)
% Function to set limits of x- and y-axes for better view
% Input:
%        Matrix A, vectro b, x_init
%
% Ouput:
%        Limits for x- and y-axes
%

[Q,D] = eig(A);     
bb = Q*b;   
r = sqrt(0.5*x_init'*A'*x_init-x_init'*b + 0.5*(bb(1)*bb(1)/D(1,1) + bb(2)*bb(2)/D(2,2)));
dd = 1.1 * max(r*[sqrt(2/D(1,1)) sqrt(2/D(2,2))]);
xx = A\b;
x_lim = [xx(1)-dd, xx(1)+dd];
y_lim = [xx(2)-dd, xx(2)+dd];



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_function(A,b,current_x)
%Function to plot the curve
% Input:
%        Matrix A, vectro b, x_init
%
% It plots the curve for the given matrix A and vectors b and x_init
%

C = (1/2)*current_x'*A*current_x-current_x'*b; 
% Breaking of matrix A and vector b into individual elements, to form
% equation (function)
a1 = num2str(A(1,1));
a2 = num2str(A(1,2));
a3 = num2str(A(2,1));
a2a3 = num2str(A(1,2)+A(2,1));
a4 = num2str(A(2,2));
b1 = num2str(b(1));
b2 = num2str(b(2));

% Equation or function formed from matrices A,b and x     
func=['0.5*(' '1*(' a1 ')' '*x^2+' '1*(' a2a3 ')' '*x*y+' '1*(' a4 ')' '*y^2)-' '1*(' b1 ')' '*x-' '1*(' b2 ')' '*y-' ...
                '1*(' num2str(C) ')'];

ezplot2(func); % To plot the function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Please do not edit, this is MathWorks Inc.'s "ezplot" function copied here with
% some modifications to meet requirements of this GUI
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [X,Y,u] = ezplot2(f,varargin)
%EZPLOT Easy to use function plotter.
%   EZPLOT(f) plots the expression f = f(x) over the default
%   domain -2*pi < x < 2*pi.
%
%   EZPLOT(f, [a,b]) plots f = f(x) over a < x < b
%
%   For implicitly defined functions, f = f(x,y)
%   EZPLOT(f) plots f(x,y) = 0 over the default domain
%   -2*pi < x < 2*pi and -2*pi < y < 2*pi
%   EZPLOT(f, [xmin,xmax,ymin,ymax]) plots f(x,y) = 0 over
%   xmin < x < xmax and  ymin < y < ymax.
%   EZPLOT(f, [a,b]) plots f(x,y) = 0 over a < x < b and a < y < b.
%   If f is a function of the variables u and v (rather than x and y), then
%   the domain endpoints a, b, c, and d are sorted alphabetically. Thus,
%   EZPLOT('u^2 - v^2 - 1',[-3,2,-2,3]) plots u^2 - v^2 - 1 = 0 over
%   -3 < u < 2, -2 < v < 3.
%
%   EZPLOT(x,y) plots the parametrically defined planar curve x = x(t)
%   and y = y(t) over the default domain 0 < t < 2*pi.
%   EZPLOT(x,y, [tmin,tmax]) plots x = x(t) and y = y(t) over
%   tmin < t < tmax.
%
%   EZPLOT(f, [a,b], FIG), EZPLOT(f, [xmin,xmax,ymin,ymax], FIG), or
%   EZPLOT(x,y, [tmin,tmax], FIG) plots the given function over the
%   specified domain in the figure window FIG.
%
%   Examples
%    f is typically an expression, but it can also be specified
%    using @ or an inline function:
%     ezplot('cos(x)')
%     ezplot('cos(x)', [0, pi])
%     ezplot('1/y-log(y)+log(-1+y)+x - 1')
%     ezplot('x^2 - y^2 - 1')
%     ezplot('x^2 + y^2 - 1',[-1.25,1.25]); axis equal
%     ezplot('x^3 + y^3 - 5*x*y + 1/5',[-3,3])
%     ezplot('x^3 + 2*x^2 - 3*x + 5 - y^2')
%     ezplot('sin(t)','cos(t)')
%     ezplot('sin(3*t)*cos(t)','sin(3*t)*sin(t)',[0,pi])
%     ezplot('t*cos(t)','t*sin(t)',[0,4*pi])
%
%     f = inline('cos(x)+2*sin(x)');
%     ezplot(f)
%     ezplot(@humps)
%
%   See also EZCONTOUR, EZCONTOURF, EZMESH, EZMESHC, EZPLOT3,
%            EZPOLAR, EZSURF, EZSURFC, PLOT.

%   Copyright 1984-2002 The MathWorks, Inc.  
%   $Revision: 1.43 $  $Date: 2002/06/05 20:05:14 $

if ~ischar(f) & ~isa(f,'inline') & ~isa(f,'function_handle')
   if all(size(f)==1) 
      f = num2str(f); 
   else
      error('Input must be a string expression, function name, or INLINE object.');
   end
end
twofuns = 0;
if (nargin > 1)
   twofuns = (ischar(varargin{1}) | isa(varargin{1},'inline') ...
                                  | isa(varargin{1}, 'function_handle'));
   if (length(varargin)>1 & length(varargin{2})<=1)
       twofuns = 0;
   end
end

% Place f into "function" form (inline).
if (twofuns)
   [f,fx0,varx] = ezfcnchk(f,0,'t');
else
   [f,fx0,varx] = ezfcnchk(f);
end

vars = varx;
nvars = length(vars);
labels = {fx0};
if ~iscell(f), f = {f}; end

if (twofuns)
   % Determine whether the two input functions have the same
   % independent variable.  That is, in the case of ezplot(x,y),
   % check that x = x(t) and y = y(t).  If not (x = x(p) and
   % y = y(q)), reject the plot.
   [fy,fy0,vary] = ezfcnchk(varargin{1},0,'t');
   nvars = max(nvars, length(vary));
   f{2} = fy;
   labels{2} = fy0;

   % This is the case of ezplot('2','f(q)') or ezplot('f(p)','3').
   if isempty(varx) | isempty(vary)
      vars = union(varx,vary);
   end
end

vars = vars(~cellfun('isempty',vars));
if isempty(vars)
   if (twofuns)
      vars = {'t'};
   else
      if (nvars == 2)
         vars = {'x' 'y'};
      else
         vars = {'x'};
      end
   end
end
nvars = max(nvars, length(vars));
ninputs = length(varargin);

if (ninputs==1 & ~twofuns)
   if length(varargin{1}) == 4 & nvars == 2
      V = varargin;
      varargin{1} = [V{1}(1),V{1}(2)];
      varargin{2} = [V{1}(3),V{1}(4)];
   end
   % ezplot(f,[xmin,ymin]) covered in the default setting.
end

if ~twofuns
   switch nvars
      case 1
         % Account for variables of [char] length > 1
         ezplot1(f{1},vars,labels,varargin{:});
         %title(texlabel(labels),'interpreter','tex');
         if ninputs>0 & isa(varargin{1},'double') & length(varargin{1}) == 4
            axis(varargin{1});
         elseif ninputs > 1 & isa(varargin{2},'double') & ...
                length(varargin{2}) == 4
            axis(varargin{2});
         end
      case 2
         [X,Y,u] = ezimplicit(f{1},vars,labels,varargin{:});
      otherwise
         if (isa(f,'function_handle'))
            fmsg = func2str(f);
         else
            fmsg = char(f);
         end
         error([fmsg ' cannot be plotted in the xy-plane.']);
      end
else
   ezparam(f{1},f{2},vars,labels,varargin{2:end});
end

%------------------------

function [X,Y,u] = ezimplicit(f,vars,labels,varargin)
% EZIMPLICIT Plot of an implicit function in 2-D.
%    EZIMPLICIT(f,vars) plots the string expression f that defines
%    an implicit function f(x,y) = 0 for x0 < x < x1
%    and y0 < y < y1, whose default values are x0 = -2*pi = y0
%    and x1 = 2*pi = y1.  The arguments of f are listed in vars and
%    a non-vector version of the function expression is in labels.
%
%   EZIMPLICIT(f,vars,labels,[x0,x1]) plots the implicit function
%   f(x,y) = 0 for x0 < x < x1, x0 < y < x1.
%
%   EZIMPLICIT(f,vars,labels,[x0,x1],[y0,y1]) plots the implicit
%   function f(x,y) = 0 for x0 < x < x1, y0 < y < y1.
%   In the case that f is not a function of x and y 
%   (rather, say u and v), then the domain endpoints [u0,u1] 
%   [v0,v1] are given alphabetically.

% If f is created from a string equation f(x,y) = g(x,y), change
% the equal sign '=' to a minus sign '-'
if (isa(f,'inline') & findstr(char(f), '='))
   symvars = argnames(f);
   f = char(f);
   f = strrep(f,'=','-');
   f = inline(f, symvars{:});
end

% Choose the number of points in the plot
npts = 250;

fig = [];
switch length(vars)
case 0
   x = 'x'; y = 'y';
case 1
   x = vars{1}; y = 'y';
case 2
   x = vars{1}; y = vars{2};
otherwise
   % If there are more than 2 variables, send an error message
   W = {vars{1},vars{2}};
   error(['ezplot requires numeric values for ' setdiff(vars,W)]);
end
% Define the computational space
switch (nargin-2)
case 1
   X = linspace(-2*pi,2*pi,npts);
   Y = X;
case 2
   if length(varargin{1}) == 1
      fig = varargin{1};
      X = linspace(-2*pi,2*pi,npts); Y = X;
   else 
      X = linspace(varargin{1}(1),varargin{1}(2),npts);
      Y = X;
   end
case 3
   if length(varargin{1}) == 1
      fig = varargin{1};
      X = linspace(varargin{2}(1),varargin{2}(2),npts);
      Y = X;
   elseif length(varargin{2}) == 1 & length(varargin{1}) == 2
      fig = varargin{2};
      X = linspace(varargin{1}(1),varargin{1}(2),npts);
      Y = X;
   elseif length(varargin{2}) == 1 & length(varargin{1}) == 4
      fig = varargin{2};
      X = linspace(varargin{1}(1),varargin{1}(2),npts);
      Y = linspace(varargin{1}(3),varargin{1}(4),npts);
   else
      X = linspace(varargin{1}(1),varargin{1}(2),npts);
      Y = linspace(varargin{2}(1),varargin{2}(2),npts);
   end
end

[X,Y] = meshgrid(X,Y);
u = feval(f,X,Y);

% Determine u scale so that "most" of the u values
% are in range, but singularities are off scale.

u = real(u);
uu = sort(u(isfinite(u)));
N = length(uu);
if N > 16
   del = uu(fix(15*N/16)) - uu(fix(N/16));
   umin = max(uu(1)-del/16,uu(fix(N/16))-del);
   umax = min(uu(N)+del/16,uu(fix(15*N/16))+del);
elseif N > 0
   umin = uu(1);
   umax = uu(N);
else
   umin = 0;
   umax = 0;
end
if umin == umax, umin = umin-1; umax = umax+1; end

% Eliminate vertical lines at discontinuities.

ud = (0.5)*(umax - umin); umean = (umax + umin)/2;
[nr,nc] = size(u);
% First, search along the rows . . .
for j = 1:nr
   k = 2:nc;
   kc = find( abs(u(j,k) - u(j,k-1)) > ud );
   ki = find( max( abs(u(j,k(kc)) - umean), abs(u(j,k(kc)-1) - umean) ) );
   if any(ki), u(j,k(kc(ki))) = NaN; end
end
% . . . then search along the columns.
for j = 1:nc
   k = 2:nr;
   kr = find( abs(u(k,j) - u(k-1,j)) > ud );
   kj = find( max( abs(u(k(kr),j) - umean), abs(u(k(kr)-1,j) - umean) ) );
   if any(kj), u(k(kr(kj)),j) = NaN; end
end

if isempty(fig), fig = gcf; end
figure(fig);
[c,h] = contour(X(1,:),Y(:,1),u,[0,0],'-b');%,'LineWidth',2)
set(h,'LineWidth',2)

if (isa(x,'function_handle'))
   xmsg = func2str(x);
else
   xmsg = char(x);
end
if (isa(y,'function_handle'))
   ymsg = func2str(y);
else
   ymsg = char(y);
end
%xlabel(texlabel(xmsg)); ylabel(texlabel(ymsg));
%title(texlabel([labels{1},' = 0']));

%----------------------------------

function ezparam(x,y,vars,labels,varargin)
% EZPARAM Easy to use 2-d parametric curve plotter.
%   EZPARAM(x,y,vars,labels) plots the planar curves r(t) = (x(t),y(t)).
%   The default domain in t [0,2*pi].  vars contains the common
%   argument of x and y, and labels contains non-vector versions of the
%   x and y expressions.
%
%   EZPARAM(x,y,vars,labels,[tmin,tmax]) plots r(t) = (x(t),y(t)) for
%   tmin < t < tmax.

fig = [];
N = length(vars);

Npts = 300;

% Determine the domains in t:
switch (nargin-2)
case 2
   T = linspace(0,2*pi,Npts);
case 3
   if length(varargin{1}) == 1
      fig = varargin{1};
      T = linspace(0,2*pi,Npts);
   else
      T = linspace(varargin{1}(1),varargin{1}(2),Npts);
   end
case 4
   if length(varargin{2}) == 1
      fig = varargin{2};
      T = linspace(varargin{1}(1),varargin{1}(2),Npts);
   elseif length(varargin{1}) == 1
      fig = varargin{1};
      T = linspace(varargin{2}(1),varargin{2}(2),Npts);
   else
      fig = gcf;
      T = linspace(varargin{1},varargin{2},Npts);
   end
end

switch N
   case 1 % planar curve
      X = feval(x,T);
      Y = feval(y,T);
      if isempty(fig), fig = gcf; end
      figure(fig);
      plot(X,Y,'LineWidth',2);
      %xlabel('x'); ylabel('y');
      axis equal;
      %title(['x = ' texlabel(labels{1}), ', y = ' texlabel(labels{2})]);
   otherwise
      error('Cannot plot parametrized surfaces.  Try ezsurf.')
end

%-------------------------

function ezplot1(f,vars,labels,xrange,fig)
%EZPLOT1 Easy to use function plotter.
%   EZPLOT1(f,vars,labels) plots a graph of f(x) where f is a
%   string or a symbolic expression representing a mathematical
%   expression involving a single symbolic variable, say 'x'.
%   vars is the name of the variable and labels is a non-vector
%   version of the function expression.
%   The range of the x-axis is approximately  [-2*pi, 2*pi]
%
%   EZPLOT1(f,vars,labels,xmin,xmax) or EZPLOT(f,[xmin,xmax]) uses
%   the specified x-range instead of the default [-2*pi, 2*pi].
%
%   EZPLOT1(f,vars,labels,[xmin xmax],fig) uses the specified
%   figure number instead of the current figure.

% Set defaults
if nargin < 3, error('Not enough input arguments.'); end
if nargin < 4, xrange = [-2*pi 2*pi]; end
if isstr(xrange), xrange = eval(xrange); end
if nargin < 5, fig = gcf; end
if nargin == 5
   if length(xrange) == 1
      xrange = [xrange fig]; fig = gcf;
   elseif isstr(fig)
      xrange = [xrange eval(fig)]; fig = gcf;
   end
end
warns = warning;
warning('off');

% Sample on initial interval.

units = get(gca,'units');
set(gca,'units','pixels');
% npts = # of pixels in the axis width.
npts = get(gca,'position')*[0;0;1;0];
set(gca,'units',units);
t = (0:npts-1)/(npts-1);
xmin = min(xrange);
xmax = max(xrange);
x = xmin + t*(xmax-xmin)
y = feval(f,x);
if length(y) == 1, % Check for a scalar function
  for i=1:length(x),
    y(i) = feval(f,x(i));
  end
  y = reshape(y,size(x)); 
end
k = find(abs(imag(y)) > 1.e-6*abs(real(y)));
if any(k), x(k) = []; y(k) = []; end
npts = length(y);
if isempty(y) & npts == 0
   warning on;
   warning(['Cannot plot ' labels{1} ':  This function has no real values.']);
   return
end
% Reduce to an "interesting" x interval.

if (npts > 1) & (nargin < 4)
   dx = x(2)-x(1);
   dy = diff(y)/dx;
   dy(npts) = dy(npts-1);
   k = find(abs(dy) > .01);
   if isempty(k), k = 1:npts; end
   xmin = x(min(k));
   xmax = x(max(k));
   if xmin < floor(4*xmin)/4 + dx, xmin = floor(4*xmin)/4; end
   if xmax > ceil(4*xmax)/4 - dx, xmax = ceil(4*xmax)/4; end
   x = xmin + t*(xmax-xmin);
   y = feval(f,x);
   if length(y) == 1, y = y(ones(size(x))); end
   k = find(abs(imag(y)) > 1.e-6*abs(real(y)));
   if any(k), y(k) = NaN; end
end

% Determine y scale so that "most" of the y values
% are in range, but singularities are off scale.

y = real(y);
u = sort(y(isfinite(y)));
npts = length(u);
if isempty(u)
   u = repmat(NaN,size(x));
   npts = prod(size(x));
end
ymin = u(1);
ymax = u(npts);
if npts > 4
   del = u(fix(7*npts/8)) - u(fix(npts/8));
   ymin = max(u(1)-del/8,u(fix(npts/8))-del);
   ymax = min(u(npts)+del/8,u(fix(7*npts/8))+del);
end
 
% Eliminate vertical lines at discontinuities.
 
k = 2:length(y);
k = find( ((y(k) > ymax/2) & (y(k-1) < ymin/2)) | ...
          ((y(k) < ymin/2) & (y(k-1) > ymax/2)) );
if any(k), y(k) = NaN; end

% Plot the function

figure(fig);
plot(x,y,'LineWidth',2)
if ymax > ymin
   axis([xmin xmax ymin ymax])
else
   axis([xmin xmax get(gca,'ylim')])
end

%xlabel(texlabel(vars{1}));
%title(texlabel(labels{1}),'Interpreter','none')
warning(warns)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [outx,xexpr,inargs,emsg] = ezfcnchk(inx,textnum,defarg)
%EZFCNCHK Version of FCNCHK for EZPLOT, EZPLOT3, etc.
%    [OUTX,XEXPR,INARGS,EMSG]=EZFCNCHK(INX) is similar to FCNCHK.  It
%    takes a single input that can be an expression, function name,
%    function handle, or inline.  It attempts to distinguish between
%    an input expression that is the identity function versus the name
%    of an M-file or builtin function.
%
%    OUTX is an inline function based on INX if INX is an expression,
%    or is the same as INX otherwise.  XEXPR is a version of INX
%    suitable for use as text on a graph.  INARGS is a cell array of
%    arguments in INX if they can be determined, or {}.  If there
%    is an error and there are four outputs, EMSG gets the error text.
%
%    [...]=EZFCNCHK(INX,TEXTNUM,DEFARG) for TEXTNUM=1 preserves things
%    like '2' as text.  TEXTNUM=0 (the default) creates an inline function
%    with a single argument.  If present, DEFARG is the name to use
%    as a default argument name if INX is a simple function name
%    as opposed to an expression that includes an argument name.

%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 1.4 $  $Date: 2002/06/05 20:06:16 $

if (nargout>2), inargs = {}; end
if (nargout>3), emsg = ''; end

% Remove array notation from inline functions
xexpr = inx;
if (nargout>1) & isa(inx, 'inline')
   xexpr = char(inx);
   if (length(xexpr) > 2)
      xexpr(findstr(xexpr, '.*')) = [];
      xexpr(findstr(xexpr, '.^')) = [];
      xexpr(findstr(xexpr, './')) = [];
   end
end

% Check for function vs. identity expression such as 't',
% and convert to a consistent form
outx = inx;
numonly = 0;             % indicates a numeric expression, no variables
e = 0;
if (ischar(inx))
   numonly = isempty(symvar(inx));
   if (numonly & nargin>1 & textnum==1), return; end

   e = exist(inx);
   dovector = (e~=2 & e~=5) | (e==5 & numonly);
   
   % Always vectorize an inline rather than a character string,
   % because we don't want to add 'ones(size(x))' to the expression.
   if (dovector), outx = inline(inx); end
else
   dovector = isa(inx,'inline');
end
if (dovector)
   [outx,emsg] = fcnchk(outx, 'vectorized');
else
   [outx,emsg] = fcnchk(outx);
end

% Display error unless caller is going to deal with it
if (nargout<4), error(emsg); end

% Get function expression for label, if not already done
if (isa(outx,'function_handle')), xexpr = func2str(outx); end

% Sometimes we can check the number of inputs expected
if (nargout>2)
   if (isa(outx, 'inline'))
      inargs = argnames(outx);
      
      % Some inputs such as 'sin' will become inline functions with
      % an argument 'x' that does not really appear in the input.
      % In that case, give the argument an "anonymous" name.
      if (ischar(inx) & isequal(inargs,{'x'}) & ...
          ~ismember({'x'},symvar(inx)))
         inargs = {''};
      end
   elseif (ischar(outx) & ((e==2) | (e==5 & ~isempty(symvar(outx)))))
      if (e==2)
         k = nargin(outx);
      else
         k = 1;  % assume one argument for builtin function
      end
      if (k>=1), inargs{1} = ''; end
      if (k>=2), inargs{2} = ''; end
      if (nargin>2)
         xexpr = [xexpr '(' defarg ')'];
      elseif (k==2)
         xexpr = [xexpr '(x,y)'];
      else
         xexpr = [xexpr '(x)'];
      end
   end
end


% --- Executes during object creation, after setting all properties.
function r_init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to r_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function r_init_Callback(hObject, eventdata, handles)
% hObject    handle to r_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of r_init as text
%        str2double(get(hObject,'String')) returns contents of r_init as a double


% --- Executes during object creation, after setting all properties.
function p_init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to p_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function p_init_Callback(hObject, eventdata, handles)
% hObject    handle to p_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of p_init as text
%        str2double(get(hObject,'String')) returns contents of p_init as a double


% --- Executes during object creation, after setting all properties.
function rou_init_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rou_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function rou_init_Callback(hObject, eventdata, handles)
% hObject    handle to rou_init (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rou_init as text
%        str2double(get(hObject,'String')) returns contents of rou_init as a double



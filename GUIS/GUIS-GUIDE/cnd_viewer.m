function varargout = cnd_viewer(varargin)
% CND_VIEWER Application M-file for cnd_viewer.fig
%   CND_VIEWER is a visualization of various continues but
%   somehow not differentiable functions (e.g. in dense
%   intervals, at rational points, nowhere ...) embedded
%   in a MATLAB GUIDE interface.
%
%   When you select a function's name from the combo box you'll
%   receive some information on it and you can start the plot
%   by pressing 'Start'. Note: only one plot is allowed to run.
%   To start a new one you'll have to wait until you're current
%   plot is finished or hit the 'Stop' button.
%
%   Depending on the function you can modify the appearance of the
%   plot. Everytime you select a function these values are set
%   to the defaults:
%     'depth'   As we approximate the function DEPTH is the number of
%               approximations you want to visualize starting at
%               the first one possible.
%     'points'  The number of points for the plot sometimes depends
%               on the current depth. In this case you can ignore
%               this edit (it's inactive then actually) else this
%               is the number of points used for your plot.
%     'parameters'  If your function requires additional parameters
%                   (thus this field is not inactive) you can list
%                   them here separated by space. The order of the
%                   parameters is explained in the function info.
%
%   Apart from these options there are some more which are the same
%   for all functions:
%     'previous plot'  While the current approximation is a blue 
%                      line you can keep the previous apprx as a 
%                      black line when enabling this option.
%     'hold plots'     If set this will ignore the 'previous plot'
%                      option and simply overall all apprx.
%     'animate'        If disabled you'll have to press a key to
%                      visualize the next apprx else the DEPTH
%                      approximations are shown as animation with
%                      a delay of 0.5 seconds between plots after
%                      you pressed a key to initiate the sequence.

% Author:  Michael Speck
% Version: 1.0.1
% Date:    2002/12/07

% Changelog:
% 1.0.1:
% - option checkboxes resized and refresh command added 
%   for use with Linux Matlab
% - added button 'Next' to proceed to next approximation
% - fixed warnings in Linux MATLAB

% Last Modified by GUIDE v2.0 09-Dec-2002 16:09:00

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
	guidata(fig, handles);

	if nargout > 0
		varargout{1} = fig;
	end

% --- SNIP ---
% info strings separated due to there length
info_bolzano = {
    'In 1834 decades before other mathematicians'
    'Bolzano constructed a geometric CND function:'
    ''
    'We start at the line between P=(0,0),Q=(1,1) adding' 
    'M=0.5(P+Q). Then we construct two new triangles on'
    'PM and MQ with doubled ascent of PQ and repeat'
    'this step for the newly retreived sides. If this'
    'is iterated to infinity we receive a CND function.';
};
info_hankel = {
    'H. Hankel´s CND example is not differentiable in all'
    'rational points.'
    ''
    'f(x) = sum_{n=1}^{inf} p(sin(n*pi*x))/n^S'
    'with S > 3'
};
info_riemann = {
    'In 1861 Riemann mentioned this function to his pupils'
    'claiming that it is nowhere differentiable which he did'
    'not prove. In 1971 it was finally shown by Gerver that'
    'this function is differentiable at certain rational'
    'multiples of PI with -0.5 but nowhere else.'
    ''
    'f(x) = sum_{n=1}^{inf} sin(n^2*x)/n^2'
};
info_schwarz = {
    'In 1873 H.A. Schwarz published this example of a'
    'continuous function that is not differentiable in any'
    'dense interval:'
    ''
    'f(x) = sum_{n=0}^{inf} p(2^n*x)/(2^(2n))'
    'with p(x) = floor(x)+sqrt(x-floor(x))'
};
info_takagi = {
    'In 1903 Teiji Takagi constructed this continuous,'
    'nowhere differentiable function aka Blancmange' 
    'as it is shaped like an english pudding by that name.'
    ''
    'T(x) = sum_{n=0}^{inf} d(2^n*x)/2^n'
    'with d(x) = distance of x to next integer'
};
info_weierstrass = {
    'With this example of a continuous but nowhere'
    'differentiable function Weierstrass initiated efforts'
    'to establish a solid base for the calculus in 1872. '
    ''
    'w(x) = sum_{n=0}^{inf} B^n*cos(A^n*pi*x)'
    'with 0 < B < 1 and A >= 1'
    '(order in the ´Parameters´ edit: B A)'
};
% initiate CND functions
global functions; 
functions = {
    'Bolzano'     'bolzano'     [0    1  0  2]  8    0 ''      info_bolzano;
    'Hankel'      'hankel'      [0    1 -1  1] 10 5000 '3.1'   info_hankel;
    'Riemann'     'riemann'     [0 6.28 -2  2] 12 5000 ''      info_riemann;  
    'Schwarz'     'schwarz'     [0   10  0 20] 12 1000 ''      info_schwarz;
    'Takagi'      'takagi'      [0    1  0  1] 12    0 ''      info_takagi;
    'Weierstrass' 'weierstrass' [0    2 -2  2] 12 5000 '0.5 3' info_weierstrass;
};
global function_count;
function_count = size(functions);
function_count = function_count(1);

% initiate selectable functions
for i = 1:function_count
    names(i) = functions(i,1);
end
set( handles.functions, 'String', names );

%initiate handles variables
handles.cnd_prev_plot=0;
handles.cnd_hold=0;
handles.cnd_animate=0;
handles.fig = fig;
guidata(fig,handles);
select_function( 'Weierstrass', fig,handles );

set(handles.next,'Enable','off');
set(handles.stop,'Enable','off');
global plot_stopped;
plot_stopped=0;
% --- SNAP ---

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
	catch
		disp(lasterr);
	end

end

% auxiliary functions for cnd_get_points
% intersect two functions mx+n and return point
function [x,y] = bolzano_intersect( m1,n1, m2,n2 )
x = (n2-n1)/(m1-m2); y = m1*x+n1;
% phi function of hankels example
function y = hankel_phi( x )
if x == 0 
    y = 0;
else
    y = x*sin(1/x);
end

% return plot data [X;Y] for approximiation N of function named
% with FNC. if used the INX and INY arguments contain the
% points of the N-1th approximation and for the first step they
% are either initialized to zero (cnd_points>0) or UNDEFINED.
% N starts at 1 but some functions (especially partial sums) may
% need to start at 0 thus they have to substract 1.
% PARAMS is the string from the 'Parameters' edit.
function [outX, outY] = cnd_get_points( fnc, n, params, inX, inY )
switch fnc;
case 'bolzano'
    % first step is not computed on previous ones
    if n == 1
        outX = [0 1];
        outY = [0 1];
    else
        % compute new vertices
        new_count = (length(inX)-1)*4+1;
        outX = zeros(1,new_count);
        outY = zeros(1,new_count);
        p = 1;
        for i = 1:(length(inX)-1)
            % between p(i) and p(i+1) we have to construct
            % two congruent triangles with doubled ascent
            x1 = inX(i); x2 = inX(i+1);
            y1 = inY(i); y2 = inY(i+1);
            mx = (x1+x2)/2; my = (y1+y2)/2;
            m = 2*(y2-y1)/(x2-x1);
            % store new points except x2,y2 as this is the
            % first point of next computation
            outX(p) = x1; outY(p) = y1; p=p+1;
            if m > 0
                [outX(p) outY(p)] = bolzano_intersect( m, y1-m*x1, -m, my+m*mx );
            else
                [outX(p) outY(p)] = bolzano_intersect( -m, y1+m*x1, m, my-m*mx );
            end
            p=p+1;
            outX(p) = mx; outY(p) = my; p=p+1;
            if m > 0
                [outX(p) outY(p)] = bolzano_intersect( m, my-m*mx, -m, y2+m*x2 );
            else
                [outX(p) outY(p)] = bolzano_intersect( -m, my+m*mx, m, y2-m*x2 );
            end
            p=p+1;
        end
        % last point
        outX(new_count) = inX(length(inX)); outY(new_count) = inY(length(inX));
    end
case 'hankel'
    params = str2num(params); S = params;
    outY = zeros(1,length(inX));
    for i = 1:length(inX)
        outY(i) = inY(i) + hankel_phi( sin( n * pi * inX(i) ) ) / (n^S);
    end
    outX = inX;
case 'riemann'
    outY = zeros(1,length(inX));
    for i = 1:length(inX)
        outY(i) = inY(i) + sin( n*n * inX(i) ) / (n*n);
    end
    outX = inX;
case 'schwarz'
    n = n-1; % start at 0
    outY = zeros(1,length(inX));
    for i = 1:length(inX)
        p = 2^n*inX(i);
        p = floor(p) + sqrt(p - floor(p));
        outY(i) = inY(i) + p/(2^(2*n));
    end
    outX = inX;
case 'takagi'
    N = 2^n;
    outX = linspace(0,1,N+1);
    outY = zeros(1,N+1);
    for k = n:-1:1
        for m = 1:2^k:N
            outY( m+2^(k-1) ) = 2^k + 0.5*( outY(m) + outY(m+2^k) );
        end
    end
    outY = outY./(2*N);
case 'weierstrass'
    n = n-1; % start at 0
    params = str2num(params); B = params(1); A = params(2);
    outY = zeros(1,length(inX));
    for i = 1:length(inX)
        outY(i) = inY(i) + (B^n)*cos((A^n)*pi*inX(i));
    end
    outX = inX;
end

% plot approximation by using handles.plotX/Y and handles.current_depth
function cnd_plot( hObject,handles )
global cnd_plotX;
global cnd_plotY;
% show old plot
if handles.cnd_prev_plot & ~handles.cnd_hold & handles.cnd_current_depth > 1
    plot(cnd_plotX,cnd_plotY,'k-'); 
    axis(handles.cnd_viewport); hold on;
end
% get new data
[newX,newY] = cnd_get_points( handles.cnd_function, handles.cnd_current_depth, handles.cnd_params, cnd_plotX, cnd_plotY );
cnd_plotX = newX; cnd_plotY = newY;
% plot data
plot(cnd_plotX,cnd_plotY,'b-'); axis(handles.cnd_viewport);
title(['CND Function: ' handles.cnd_function ' (Points: ' num2str(length(cnd_plotX)) ', Depth: ' num2str(handles.cnd_current_depth) ')']);
if ( handles.cnd_hold )
    hold on;
else
    hold off;
end
refresh;

% select function and update all variables and gui widgets
function select_function( name, hObject, handles )
global functions;
global function_count;
for i = 1:function_count
    if strcmp(functions(i,1),name)
        set( handles.functions, 'Value', i );
        % set values to function's defaults
        handles.cnd_function = functions{i,2};
        handles.cnd_viewport = functions{i,3};
        handles.cnd_depth = functions{i,4};
        set(handles.depth, 'String', num2str(handles.cnd_depth));
        handles.cnd_points = functions{i,5};
        set(handles.points, 'String', num2str(handles.cnd_points));
        if handles.cnd_points > 0
            set( handles.points, 'Enable', 'on' );
        else
            set( handles.points, 'Enable', 'off' );
        end
        handles.cnd_params = functions{i,6};
        set(handles.params, 'String', num2str(handles.cnd_params));
        if strcmp( handles.cnd_params, '' )
            set( handles.params, 'Enable', 'off' );
        else
            set( handles.params, 'Enable', 'on' );
        end
        guidata(hObject,handles);
        %display info
        set( handles.info, 'String', functions{i,7} );
        break;
    end
end

%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.

% --------------------------------------------------------------------
function varargout = functions_callback(hObject, eventdata, handles, varargin)
val = get( hObject, 'Value' );
str = get( hObject, 'String' );
select_function(str{val},hObject,handles);

% --------------------------------------------------------------------
% set plot options
%  PREV_PLOT: keep previous plot as black line
%  HOLD:      overlay all plots and ignore PREV_PLOT
%  ANIMATE:   either wait for key pressed or animate with 0.5 seconds 
%             delay
function varargout = prev_plot_callback(hObject, eventdata, handles, varargin)
handles.cnd_prev_plot = get( hObject, 'Value' );
guidata(hObject,handles);

function varargout = hold_callback(hObject, eventdata, handles, varargin)
handles.cnd_hold = get( hObject, 'Value' );
guidata(hObject,handles);

function varargout = animate_callback(hObject, eventdata, handles, varargin)
handles.cnd_animate = get( hObject, 'Value' );
guidata(hObject,handles);

% --------------------------------------------------------------------
% save the function settings:
%  depth:      this many approximations are shown (starting with 
%              the first one possible
%  points:     if function is not fractal user must specify the 
%              number of points to be evaluated for plot
%  parameters: if the function requires parameters (e.g. the 
%              weierstrass function they can be listed separated
%              by space
function varargout = depth_callback(hObject, eventdata, handles, varargin)
handles.cnd_depth = str2num(get( hObject, 'String' ));
guidata(hObject,handles);

function varargout = points_callback(hObject, eventdata, handles, varargin)
handles.cnd_points = str2num(get( hObject, 'String' ));
guidata(hObject,handles);

function varargout = params_callback(hObject, eventdata, handles, varargin)
handles.cnd_params = get( hObject, 'String' );
guidata(hObject,handles);

% --------------------------------------------------------------------
% start the plotting
function varargout = start_callback(hObject, eventdata, handles, varargin)
global cnd_plotX;
global cnd_plotY;
global plot_stopped;
set(handles.start,'Enable','off');
set(handles.functions,'Enable','off');
set(handles.next,'Enable','on');
set(handles.stop,'Enable','on');
% initiate points to zero
if handles.cnd_points > 0
    cnd_plotX = linspace(handles.cnd_viewport(1),handles.cnd_viewport(2),handles.cnd_points);
    cnd_plotY = zeros(1,handles.cnd_points);
else
    % if points aren't used we initiate anyway
    % as MATLAB will complain else
    cnd_plotX = zeros(1,1);
    cnd_plotY = zeros(1,1);
end
plot_stopped = 0;
handles.cnd_current_depth = 1;
guidata(hObject,handles);
% plot first approximation
clf;
cnd_plot(hObject,handles);
% check if this was maybe the only one
if handles.cnd_depth == 1
    stop_callback(handles.stop,eventdata,handles,varargin);
end

% --------------------------------------------------------------------
% update buttons and set plot_stopped flag
function varargout = stop_callback(hObject, eventdata, handles, varargin)
global plot_stopped;
plot_stopped = 1;
set(handles.start,'Enable','on');
set(handles.functions,'Enable','on');
set(handles.next,'Enable','off');
set(handles.stop,'Enable','off');

% --------------------------------------------------------------------
% either draw next approximation or animate all
function varargout = next_callback(hObject, eventdata, handles, varargin)
global plot_stopped;
if handles.cnd_animate
    set(handles.next,'Enable','off');
end
while handles.cnd_current_depth < handles.cnd_depth & ~plot_stopped
    handles.cnd_current_depth=handles.cnd_current_depth+1;
    guidata(hObject,handles);
    cnd_plot(hObject,handles);
    if handles.cnd_animate > 0
        pause(handles.cnd_animate);
    else
        break;
    end
end
if handles.cnd_animate
    set(handles.next,'Enable','on');
end
if handles.cnd_animate | plot_stopped
    stop_callback(handles.stop,eventdata,handles,varargin);
else
    if handles.cnd_current_depth >= handles.cnd_depth
        stop_callback(handles.stop,eventdata,handles,varargin);
    end
end

% --------------------------------------------------------------------
function varargout = about_callback(hObject, eventdata, handles, varargin)
credits = {
    'CND Viewer visualizes various continuous somehow'
    'not differentiable functions. (e.g. in dense intervals, at'
    'rational points, nowhere ...)'
    ''
    'Author:  Michael Speck'
    'Version: 1.0.1'
    'Date:    2002/12/07'
};
set(handles.info,'String',credits);

% --------------------------------------------------------------------
function varargout = quit_callback(hObject, eventdata, handles, varargin)
close(handles.fig);


function varargout = fractal_explorer(varargin)
% FRACTAL_EXPLORER - Chaos, Lindenmayer Systems, Strange Attractors and
% more...
%
% CSE Fractal Explorer is a GUI-based program for exploring and studying the
% most common form of fractals, chaotic systems and fractional dimension systems.
% An overview of the features with a small introductory text is available at
% http://ltcmail.ethz.ch/cavin/fractals.html
%
% The usage is strightforward. Type "fractal_explorer", and the main window
% will be opened and the Mandelbrot Set will be drawn. All features are available
% via menus and buttons. Information is given on the bottom-left corner of the
% figure, while tips and information will appear on the left side of the figure
% when user input is required/possible.
%
% The features include:
% - Logistic Equation [1]
% - Real 2D Attractors:
%     - Henon Attractor [1]
%     - Pickover System [1]
%     - Arbitrary Quadratic Map [1]
% - Real 3D Attractors:
%     - Lorenz Attractor [2]
%     - Roessler Attractor [2]
%     - Limited Quadratic Map [2]
% - Complex Maps:
%     - Mandelbrot Set [1,5]
%     - Julia Sets [1,3,5]
%     - Arbitrary Polynomial Newton-Raphson Attraction Basins [1,5]
%     - Barnsley's Tree [1,5]
%     - Arbitrary Mandelbrot and Julia-based Sets [1,5]
% - Quaterions:
%     - Mandelbrot and Julia Sets [2]
% - String Systems:
%     - Lindemayer Systems Single Rule
%     - Lindenmayer Systems Multiple-Rules
%     - Plant-like systems:
%         - Barbsley's Fern [4,6]
%         - Fractal Trees
%     - 3D Systems
%         - 3D-Multiple-Rules Lindenmayer Systems [2]
%         - Menger Sponge [2,4]
% - Folded Plans:
%     - Mesh grids [2]
%     - Fractals Clouds
%     - Fractal Landscapes [2]
% 
% Notes:
% [1] Interactive Zooming
% [2] Interactive 3-D View
% [3] Julia explorer with on-the-fly previews
% [4] Limited to built-in parameters
% [5] Include the function Make-It-3D!
% [6] Equations taken from Brian Mearns's "Fractal Fern"
%     http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=4372&objectType=file
% 
% For most functions, dialogs will allow introducing user-defined parameters or 
% equations for the calculation. Most dialog contains a button labeled "Cool Params" -
% this will propose a set of parameters leading to a chaotic behavior (as it is
% sometimes difficult to find a good parameter set); when only one "good" set of
% parameter is known, it will be given by default the first time the function is called.
%
% Written by L.Cavin, 30.07.2004, (c) CSE
% This code is free to use and modify for non-commercial purposes.
% Web address: http://ltcmail.ethz.ch/cavin/fractals.html#SOFT

% FOLLOWS THE STANDARD GUIDE COMMENTS:
%
% FRACTAL_EXPLORER M-file for fractal_explorer.fig
%      FRACTAL_EXPLORER, by itself, creates a new FRACTAL_EXPLORER or raises the existing
%      singleton*.
%
%      H = FRACTAL_EXPLORER returns the handle to a new FRACTAL_EXPLORER or the handle to
%      the existing singleton*.
%
%      FRACTAL_EXPLORER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRACTAL_EXPLORER.M with the given input arguments.
%
%      FRACTAL_EXPLORER('Property','Value',...) creates a new FRACTAL_EXPLORER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fractal_explorer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fractal_explorer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fractal_explorer

% Last Modified by GUIDE v2.5 28-Jul-2004 15:29:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fractal_explorer_OpeningFcn, ...
                   'gui_OutputFcn',  @fractal_explorer_OutputFcn, ...
                   'gui_LayoutFcn',  @fractal_explorer_LayoutFcn, ...
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


% --- Executes just before fractal_explorer is made visible.
function fractal_explorer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fractal_explorer (see VARARGIN)

% Choose default command line output for fractal_explorer
if nargin > 3
    disp('unknown input arguments:');
    varargin{:}
end

handles.output = hObject;

axes(handles.main_axis);
gridsize = get(handles.main_axis, 'position');
handles.gridsize = gridsize(3);
handles.space = get_mandelbrot_initial(handles.gridsize);
handles.main_image = image(handles.space);
axis(handles.main_axis, 'off');

% CANCELLING INACTIVE MENU ITEMS
set(handles.menu_rabinovich, 'Enable', 'off');

handles.xmin = -2;
handles.xmax = 1;
handles.ymin = -1.5;
handles.ymax = 1.5;
handles.itern = 70;
handles.mode = 1; % mandelbrot
handles.xjul = 0;
handles.yjul = 0;

handles = fillupdescription(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fractal_explorer wait for user response (see UIRESUME)
% uiwait(handles.fractal_explorer);


% --- Outputs from this function are returned to the command line.
function varargout = fractal_explorer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to button_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.button_3D, 'Enable', 'on');
delete(handles.preview_image);
set(handles.txt_zoom_1, 'Visible', 'off');
set(handles.txt_zoom_2, 'Visible', 'off');
set(handles.button_cancel, 'Visible', 'off');
set(handles.button_compute, 'Visible', 'off');
set(handles.preview_axis, 'Visible', 'off');
axes(handles.main_axis);


% --- Executes on button press in button_compute.
function button_compute_Callback(hObject, eventdata, handles)
% hObject    handle to button_compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.main_axis);
set(handles.button_3D, 'Enable', 'on');

scaling = sqrt((handles.xmax - handles.xmin)/(handles.txmax - handles.txmin));
if scaling > 0
    scaling = scaling /2;
end
handles.xmin = handles.txmin;
handles.xmax = handles.txmax;
handles.ymin = handles.tymin;
handles.ymax = handles.tymax;
if ~isfield(handles, 'grain')
    handles.grain = 1;
elseif isempty(handles.grain)
    handles.grain = 1;
end

switch handles.mode
    case -1 % logistic
        handles.space = compute_logistic(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize, 1);
    case 1 % mandelbrot
        handles.itern = handles.itern * scaling;
        handles.space = compute_mandelbrot_real(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize, 1);
    case 2 % julia
        handles.itern = handles.itern * scaling;
        handles.space = compute_julia(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
    case 3 % newton
        handles.space = compute_newton(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize/handles.grain, 1);
    case 4 % user newton
        handles.space = compute_newton_power(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize/handles.grain, handles.ctes, 1);
    case 5 % barnsley
        handles.space = compute_barnsley(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
    case 6 % circu poly
        if handles.arbitrary_mode == 1
            handles.space = compute_circumpoly(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize/handles.grain, 1);
        else
            handles.space = compute_arbitrary(handles.equation, handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize/handles.grain, 1);
        end
    otherwise
        warning('CSE:Fractals:Render', 'Unknown Mode');
end
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end
handles = fillupdescription(handles);
if handles.mode > 0
    handles.main_image = image(handles.space, 'EraseMode', 'none');
    axis(handles.main_axis, 'off');
else % we have an [x y] in handles.space, not a complete table with handles.space(x, y) = color
    handles.main_image = plot(handles.space(:,1), handles.space(:,2), 'b.', 'MarkerSize', 1);
    axis(handles.main_axis, [handles.xmin handles.xmax handles.ymin handles.ymax]);
end

try delete(handles.preview_image); end
set(handles.txt_zoom_1, 'Visible', 'off');
set(handles.txt_zoom_2, 'Visible', 'off');
set(handles.button_cancel, 'Visible', 'off');
set(handles.button_compute, 'Visible', 'off');
set(handles.preview_axis, 'Visible', 'off');
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_head_program_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_program (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_help_Callback(hObject, eventdata, handles)
% hObject    handle to menu_help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% UNTIL RELEASE, THIS FUNCTION IS USED FOR TESTING NEW ALGORITHMS %%

% return;
%% UNTIL RELEASE, THIS FUNCTION IS USED FOR TESTING NEW ALGORITHMS %%

helpmsg = sprintf(['CSE Fractals III\n\nA cross-platform matlab port from the Macintosh Software CSE Fractals II.\n\n' ...
        'Select in the menus the different types of fractals, according to which type of ' ...
        '"numbers" are used in the computation: Real, Imaginary, Quaternions, String Systems.\n\n' ...
        'More information of the different types of fractals is available on the internet. ' ...
        'Click on "More Info..." to go to a web-page with background infos avout chaos.']);
answr = questdlg(helpmsg, 'CSE Fractals III', 'More Info...', 'OK', 'OK');
if strcmp(answr, 'More Info...')
    % web('\\sust43\d$\cavin\Documents\web\fractals.html', '-browser');
    web('http://ltcmail.ethz.ch/cavin/fractals.html', '-browser');
end

% --------------------------------------------------------------------
function menu_quit_Callback(hObject, eventdata, handles)
% hObject    handle to menu_quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.fractal_explorer);


% --------------------------------------------------------------------
function menu_mandelbrot_whole_Callback(hObject, eventdata, handles)
% hObject    handle to menu_mandelbrot_whole (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.space = get_mandelbrot_initial(handles.gridsize);
handles.main_image = image(handles.space, 'EraseMode', 'none');
axis(handles.main_axis, 'off');

handles.xmin = -2;
handles.xmax = 1;
handles.ymin = -1.5;
handles.ymax = 1.5;
handles.itern = 70;
handles.mode = 1; % mandelbrot
handles = fillupdescription(handles);
set(handles.menu_julia_mouse, 'Enable', 'on'); % enables julia.
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_mandelbrot_user_Callback(hObject, eventdata, handles)
% hObject    handle to menu_mandelbrot_user (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msg = sprintf('Mandelbrot Set:\n\nDefine Region and iterations:\n\n');
tmp = {num2str(handles.xmin), num2str(handles.xmax), num2str(handles.ymin), num2str(handles.ymax), num2str(handles.itern)};
tmp = localdlg({[msg 'Real Minimum:'], 'Real Maximum:', 'Imaginary Minimum:', 'Imaginary Maximum:', 'Iterations:'}, 'Mandelbrot Set', [1 10], tmp);
if isempty(tmp)
    return;
end
handles.xmin = str2num(tmp{1});
handles.xmax = str2num(tmp{2});
handles.ymin = str2num(tmp{3});
handles.ymax = str2num(tmp{4});
handles.itern = str2num(tmp{5});
handles.mode = 1; % mandelbrot
handles = fillupdescription(handles);
set(handles.menu_julia_mouse, 'Enable', 'on'); % enables julia.
handles.space = compute_mandelbrot_real(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize, 1);
handles.main_image = image(handles.space, 'EraseMode', 'none');
axis(handles.main_axis, 'off');
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_mandlebrot_Callback(hObject, eventdata, handles)
% hObject    handle to menu_mandlebrot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_julia_mouse_Callback(hObject, eventdata, handles)
% hObject    handle to menu_julia_mouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fractal_explorer, 'KeyPressFcn', ';');
set(handles.button_zoom, 'Enable', 'off');
set(handles.txt_zoom_1, 'Visible', 'on');
ini_txt = get(handles.txt_zoom_1, 'String');
set(handles.txt_zoom_1, 'String', sprintf('Click mouse to compute current Julia\nSet; Press any key to cancel.'));
set(handles.preview_axis, 'Visible', 'on');
set(handles.txt_zoom_2, 'Visible', 'on');

axes(handles.preview_axis);
set(handles.preview_axis, 'DrawMode', 'fast');
xstep = (handles.xmax-handles.xmin)/handles.gridsize;
ystep = (handles.ymax-handles.ymin)/handles.gridsize;
xmin = handles.xmin;
ymin = handles.ymin;
dbt = 1;
pt = get(handles.fractal_explorer, 'CurrentPoint');
s_u = get(handles.fractal_explorer, 'Units');
set(handles.fractal_explorer, 'Units', 'Pixel');
pos = get(handles.fractal_explorer, 'Position');
pos(1) = pos(1)+20;
pos(2) = pos(2)+25;
set(handles.fractal_explorer, 'Units', s_u);
set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), 'ç') & (pt == get(handles.fractal_explorer, 'CurrentPoint')) 
    location = get(0, 'PointerLocation');
    location(1) = location(1) - pos(1);
    location(2) = location(2) - pos(2);
    x = xmin + location(1)*xstep;
    y = ymin + location(2)*ystep;
    %disp([num2str(x) ' - ' num2str(y)]);
    space2 = compute_julia_initial(-2, 2, -2, 2, x, y, 25, 150, 0);
    if ~dbt
        set(handles.preview_image, 'CData', space2);
    else
        handles.preview_image = image(space2);
        set(handles.preview_image, 'EraseMode', 'none');
        dbt = 0;
    end
	axis off;
    drawnow;
end

set(handles.txt_zoom_1, 'String', ini_txt);
set(handles.txt_zoom_1, 'Visible', 'off');
set(handles.txt_zoom_2, 'Visible', 'off');
set(handles.preview_axis, 'Visible', 'off');
if isfield(handles, 'preview_image')
    delete(handles.preview_image);
end
set(handles.button_zoom, 'Enable', 'on');
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.fractal_explorer, 'Name', 'CSE Fractals III');

if strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), 'ç')
	handles.xjul = x;
	handles.yjul = y;
	handles.xmin = -2;
	handles.xmax = 2;
	handles.ymin = -2;
	handles.ymax = 2;
    handles.itern = 70;
	axes(handles.main_axis);
	handles.space = compute_julia_initial(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
	delete(handles.main_image);
	handles.main_image = image(handles.space, 'EraseMode', 'none');
	axis(handles.main_axis, 'off');
    handles.mode = 2; % julia
    handles = fillupdescription(handles);
end
% Update handles structure
guidata(hObject, handles);



% --------------------------------------------------------------------
function menu_julia_user_Callback(hObject, eventdata, handles)
% hObject    handle to menu_julia_user (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msg = sprintf('Julia Set:\n\nDefine Constant and iterations:\n\n');
tmp = {num2str(handles.xjul), num2str(handles.yjul), num2str(handles.itern)};
tmp = localdlg({[msg 'Constant Real:'], 'Constant Imaginary:', 'Iterations:'}, 'Julia Set', [1 10], tmp);
if isempty(tmp)
    return;
end
handles.xmin = -2;
handles.xmax = 2;
handles.ymin = -2;
handles.ymax = 2;
handles.xjul = str2num(tmp{1});
handles.yjul = str2num(tmp{2});
handles.itern = str2num(tmp{3});
handles.mode = 2; % julia
handles = fillupdescription(handles);
handles.space = compute_julia_initial(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
handles.main_image = image(handles.space, 'EraseMode', 'none');
axis(handles.main_axis, 'off');
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_julia_Callback(hObject, eventdata, handles)
% hObject    handle to menu_julia (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_newton_head_Callback(hObject, eventdata, handles)
% hObject    handle to menu_newton_head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_newton_quad_Callback(hObject, eventdata, handles)
% hObject    handle to menu_newton_quad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.xmin = -2;
handles.xmax = 2;
handles.ymin = -2;
handles.ymax = 2;
handles.itern = 70;
handles.mode = 3; % newton
handles.newton_equation = 'z^3 = -1';
handles.space = compute_newton(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize, 1);
handles.main_image = image(handles.space);
axis(handles.main_axis, 'off');
set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia - makes no sense from newton.

handles = fillupdescription(handles);
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_head_complex_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_complex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in button_zoomout.
function button_zoomout_Callback(hObject, eventdata, handles)
% hObject    handle to button_zoomout (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.button_3D, 'Enable', 'off');
xsize = handles.xmax-handles.xmin;
ysize = handles.ymax-handles.ymin;
handles.txmin = handles.xmin-xsize/1.5;
handles.txmax = handles.xmax+xsize/1.5;
handles.tymin = handles.ymin-ysize/1.5;
handles.tymax = handles.ymax+ysize/1.5;
switch handles.mode
    case -1 % logistic
        space = compute_logistic(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.itern/3, 150, 0);
    case 1 % mandelbrot
        space = compute_mandelbrot_real(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.itern, 150, 0);
    case 2 % julia
        space = compute_julia(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.xjul, handles.yjul, handles.itern, 150, 0);
    case 3 % newton
        space = compute_newton(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.itern, 150, 0);
    case 4 % user-newton
        space = compute_newton_power(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.itern, 150/handles.grain, handles.ctes, 0);
    case 5 % barnsley
        space = compute_barnsley(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.xjul, handles.yjul, handles.itern, 15, 0);
    case 6 % circu poly
        if handles.arbitrary_mode == 1
            space = compute_circumpoly(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.xjul, handles.yjul, handles.itern/2, 150, 0);
        else
            space = compute_arbitrary(handles.equation, handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.xjul, handles.yjul, handles.itern, 30, 0);
        end
    otherwise
        warning('CSE:Fractals:Render', 'Unknown Mode');
end
set(handles.txt_zoom_2, 'Visible', 'on');
set(handles.button_cancel, 'Visible', 'on');
set(handles.button_compute, 'Visible', 'on');
set(handles.preview_axis, 'Visible', 'on');
axes(handles.preview_axis);
if handles.mode > 0
    handles.preview_image = image(space);
    axis(handles.preview_axis, 'off');
else % we have an [x y] in space, not a complete table with space(x, y) = color
    handles.preview_image = plot(space(:,1), space(:,2), 'b.', 'MarkerSize', 1);
    axis(handles.preview_axis, [handles.txmin handles.txmax handles.tymin handles.tymax]);
    set(handles.preview_axis, 'FontSize', 6);
end

guidata(hObject, handles);

% --- Executes on button press in button_zoom.
function button_zoom_Callback(hObject, eventdata, handles)
% hObject    handle to button_zoom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.txt_zoom_1, 'Visible', 'on');
set(handles.button_3D, 'Enable', 'off');

axes(handles.main_axis);
[x, y] = ginput(2);

xstep = (handles.xmax-handles.xmin)/handles.gridsize;
ystep = (handles.ymax-handles.ymin)/handles.gridsize;
if handles.mode == 4
    if isfield(handles, 'grain')
        if ~isempty(handles.grain)
            xstep = xstep * handles.grain;
            ystep = ystep * handles.grain;
        end
    end
end

if handles.mode > 0
	if x(2) < x(1)
        x1 = x(2);
        x2 = x(1);
	else
        x1 = x(1);
        x2 = x(2);
	end
	if y(2) < y(1)
        y1 = y(1) - (x2-x1);
        y2 = y(2);
	else
        y1 = y(1);
        y2 = y(1) + (x2-x1);
	end
	handles.txmin = handles.xmin + x1 * xstep;
	handles.txmax = handles.xmin + x2 * xstep;
	handles.tymin = handles.ymin + y1 * ystep;
	handles.tymax = handles.ymin + y2 * ystep;
    %disp(sprintf('%0.25g-%0.25g:%0.25g-%0.25g',handles.txmin, handles.txmax, handles.tymin, handles.tymax)); 
else
    handles.txmin = min(x);
    handles.txmax = max(x);
    handles.tymin = min(y);
    handles.tymax = max(y);
end

switch handles.mode
    case -1 % logistic
        space = compute_logistic(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.itern/3, 150, 0);
    case 1 % mandelbrot
        space = compute_mandelbrot_real(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.itern, 150, 0);
    case 2 % julia
        space = compute_julia(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.xjul, handles.yjul, handles.itern, 150, 0);
    case 3 % newton
        space = compute_newton(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.itern, 150, 0);
    case 4 % user newton
        if handles.grain > 1
            scl = 15;
        else
            scl = 150;
        end
        space = compute_newton_power(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.itern, round(scl), handles.ctes, 0);
    case 5 % barnsley
        space = compute_barnsley(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.xjul, handles.yjul, handles.itern, 150, 0);
    case 6 % circu poly
        if handles.arbitrary_mode == 1
            space = compute_circumpoly(handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.xjul, handles.yjul, handles.itern/2, 150, 0);
        else
            space = compute_arbitrary(handles.equation, handles.txmin, handles.txmax, handles.tymin, handles.tymax, handles.xjul, handles.yjul, handles.itern, 30, 0);
        end
    otherwise
        warning('CSE:Fractals:Render', 'Unknown Mode');
end
set(handles.txt_zoom_2, 'Visible', 'on');
set(handles.button_cancel, 'Visible', 'on');
set(handles.button_compute, 'Visible', 'on');
set(handles.preview_axis, 'Visible', 'on');
axes(handles.preview_axis);
if handles.mode > 0
    handles.preview_image = image(space);
    axis(handles.preview_axis, 'off');
else % we have an [x y] in space, not a complete table with space(x, y) = color
    handles.preview_image = plot(space(:,1), space(:,2), 'b.', 'MarkerSize', 1);
    axis(handles.preview_axis, [handles.txmin handles.txmax handles.tymin handles.tymax]);
    set(handles.preview_axis, 'FontSize', 6);
end

guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_head_real_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_real (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function menu_logistic_Callback(hObject, eventdata, handles)
% hObject    handle to menu_logistic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.xmin = 1;
handles.xmax = 4;
handles.ymin = 0;
handles.ymax = 1;
handles.itern = 20;
handles.mode = -1;
handles.space = compute_logistic(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize, 1);
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end
handles.main_image = plot(handles.space(:,1), handles.space(:,2), 'b.', 'MarkerSize', 1);
axis(handles.main_axis, [handles.xmin handles.xmax handles.ymin handles.ymax]);

set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia

handles = fillupdescription(handles);

guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_head_attractors_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_attractors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menu_rabinovich_Callback(hObject, eventdata, handles)
% hObject    handle to menu_rabinovich (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


msg = sprintf('Rabinovich-Fabrikant:\n\nIterations on the system:\ndx/dt = a*(y-x)\ndy/dt = x*(b-z)-y\ndz/dt = x*y-c*z\n\nSpecify the constants:\n\n');
if ~isfield(handles, 'rabinovich_params')
    handles.rabinovich_params = {'0.87', '1.1'};
elseif isempty(handles.rabinovich_params)
    handles.rabinovich_params = {'0.87', '1.1'};
end
handles.rabinovich_params = localdlg({[msg 'a:'], 'b:'}, 'Rabinovich-Fabrikant', [1 10], handles.rabinovich_params);
if isempty(handles.rabinovich_params)
    return;
end
for i = 1:length(handles.rabinovich_params)
    handles.ctes(i) = str2num(handles.rabinovich_params{i});
end
handles.mode = -7;
x = 0.0000001;
y = -0.0000001;
z = 0.0000001;
dt = 0.01;
set(handles.fractal_explorer, 'KeyPressFcn', ';');
handles = fillupdescription(handles);
set(handles.txt_help, 'String', sprintf('Press any key to stop.\nUse the mouse to modify the\nobservation angle in 3 dimensions.'));
set(handles.txt_help, 'Visible', 'on');
axes(handles.main_axis);
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end

set(handles.main_axis, 'Drawmode','normal');
plot3(0, 0, 0, 'k.', 'MarkerSize', 1);
set(handles.main_axis, ...
    'XLim',[-400 400],'YLim',[-400 400],'ZLim',[-100 500], ...
    'XTick',[],'YTick',[],'ZTick',[], ...
    'Drawmode','fast', ...
    'Visible','on', ...
    'NextPlot','add', ...
    'Color', [0 0 0], ...
    'View',[-49,16]);
xlabel('X');
ylabel('Y');
zlabel('Z');
serie = [x y z; zeros(3999, 3)];
lne_head = line( ...
    'color','r', ...
    'Marker','.', ...
    'markersize',25, ...
    'erase','xor', ...
    'xdata',serie(1),'ydata',serie(2),'zdata',serie(3));
lne_body = line( ...
    'color','y', ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_tail=line( ...
    'color',[0.3 0.3 1], ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_trace=line( ...
    'color','b', ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_dust=line( ...
    'color',[0 0 0.5], ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);

rotate3d on;
set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
cchr = get(handles.fractal_explorer, 'CurrentCharacter');
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), cchr)
    dx = y*(z-1-x^2)+handles.ctes(1)*x;
    dy = x*(3*z+1-x^2)+handles.ctes(1)*y;
    dz = -2*z*(handles.ctes(2)+x*y);
    x = x + dx*dt;
    y = y + dy*dt;
    z = z + dz*dt;
    serie = [x y z; serie(1:end-1,:)];
    set(lne_trace,'xdata',serie(500:end-2, 1),'ydata',serie(500:end-2, 2),'zdata',serie(500:end-2, 3));
    set(lne_dust,'xdata',serie(end-1:end, 1),'ydata',serie(end-1:end, 2),'zdata',serie(end-1:end, 3));
    set(lne_tail,'xdata',serie(41:499, 1),'ydata',serie(41:499, 2),'zdata',serie(41:499, 3));
    set(lne_head,'xdata',serie(1,1),'ydata',serie(1, 2),'zdata',serie(1, 3));
    set(lne_body,'xdata',serie(1:40,1),'ydata',serie(1:40,2),'zdata',serie(1:40,3));
    drawnow;
end
hold off;
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.txt_help, 'Visible', 'off');
guidata(hObject, handles);



% --------------------------------------------------------------------
function menu_lorenz_Callback(hObject, eventdata, handles)
% hObject    handle to menu_lorenz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msg = sprintf('Lorenz Attractor:\n\nIterations on the system:\ndx/dt = a*(y-x)\ndy/dt = x*(b-z)-y\ndz/dt = x*y-c*z\n\nSpecify the constants:\n\n');
if ~isfield(handles, 'lorenz_params')
    handles.lorenz_params = {'10', '28', '2.85'};
elseif isempty(handles.lorenz_params)
    handles.lorenz_params = {'10', '28', '2.85'};
end
handles.lorenz_params = localdlg({[msg 'a:'], 'b:', 'c:'}, 'Lorenz Attractor', [1 10], handles.lorenz_params);
if isempty(handles.lorenz_params)
    return;
end
for i = 1:length(handles.lorenz_params)
    handles.ctes(i) = str2num(handles.lorenz_params{i});
end
handles.mode = -2;
x = unifrnd(-10, 20); %0.1000001;
y = unifrnd(-10, 20); %-0.1000001;
z = unifrnd(10, 30); %1.0000001;
dt = 0.01;
set(handles.fractal_explorer, 'KeyPressFcn', ';');
handles = fillupdescription(handles);
set(handles.txt_help, 'String', sprintf('Press any key to stop.\nUse the mouse to modify the\nobservation angle in 3 dimensions.\n(inspired by Mathworks'' Lorenz Demo)'));
set(handles.txt_help, 'Visible', 'on');
axes(handles.main_axis);
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end

set(handles.main_axis, 'Drawmode','normal');
plot3(0, 0, 0, 'k.', 'MarkerSize', 1);
set(handles.main_axis, ...
    'XLim',[-40 40],'YLim',[-40 40],'ZLim',[-10 50], ...
    'XTick',[],'YTick',[],'ZTick',[], ...
    'Drawmode','fast', ...
    'Visible','on', ...
    'NextPlot','add', ...
    'Color', [0 0 0], ...
    'View',[-180, -4]); % [-49,16]
xlabel('X');
ylabel('Y');
zlabel('Z');
serie = [x y z; zeros(3999, 3)];
lne_head = line( ...
    'color','r', ...
    'Marker','.', ...
    'markersize',25, ...
    'erase','xor', ...
    'xdata',serie(1),'ydata',serie(2),'zdata',serie(3));
lne_body = line( ...
    'color','y', ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_tail=line( ...
    'color',[0.8 0.8 1], ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_trace=line( ...
    'color',[0.4 0.4 1], ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_dust=line( ...
    'color',[0.2 0.2 1], ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);

rotate3d on;
set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
cchr = get(handles.fractal_explorer, 'CurrentCharacter');
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), cchr)
    dx = dt*handles.ctes(1)*(y-x);
    dy = dt*((handles.ctes(2)-z)*x-y);
    dz = dt*(x*y-handles.ctes(3)*z);
    x = x + dx;
    y = y + dy;
    z = z + dz;
    serie = [x y z; serie(1:end-1,:)];
    set(lne_trace,'xdata',serie(500:end-2, 1),'ydata',serie(500:end-2, 2),'zdata',serie(500:end-2, 3));
    set(lne_dust,'xdata',serie(end-1:end, 1),'ydata',serie(end-1:end, 2),'zdata',serie(end-1:end, 3));
    set(lne_tail,'xdata',serie(41:499, 1),'ydata',serie(41:499, 2),'zdata',serie(41:499, 3));
    set(lne_head,'xdata',serie(1,1),'ydata',serie(1, 2),'zdata',serie(1, 3));
    set(lne_body,'xdata',serie(1:40,1),'ydata',serie(1:40,2),'zdata',serie(1:40,3));
    drawnow;
end
hold off;
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.txt_help, 'Visible', 'off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_henon_Callback(hObject, eventdata, handles)
% hObject    handle to menu_henon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msg = sprintf('Henon Attractor:\n\nIterations on the system:\nx = y-a-b*x^2\ny = c*x\n\nSpecify the constants:\n\n');
if ~isfield(handles, 'henon_params')
    handles.henon_params = {'1', '1.4', '0.3'};
elseif isempty(handles.henon_params)
    handles.henon_params = {'1', '1.4', '0.3'};
end
handles.henon_params = localdlg({[msg 'a:'], 'b:', 'c:'}, 'Henon Attractor', [1 10], handles.henon_params);
if isempty(handles.henon_params)
    return;
end
for i = 1:length(handles.henon_params)
    handles.ctes(i) = str2num(handles.henon_params{i});
end
handles.mode = -3;
x = unifrnd(-0.5, 0.5); %0.1000001;
y = unifrnd(-0.2, 0.2); %-0.1000001;
set(handles.fractal_explorer, 'KeyPressFcn', ';');
set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia
handles = fillupdescription(handles);
set(handles.txt_help, 'String', sprintf('Press any key to stop.\nTo zoom in during the calculation,\nselect a zone with the mouse.\nTo zoom out, right-click.'));
set(handles.txt_help, 'Visible', 'on');
axes(handles.main_axis);
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end

set(handles.main_axis, 'Drawmode','normal');
plot(0, 0, 'k.', 'MarkerSize', 1);
set(handles.main_axis, ...
    'XLim',[-1.5 1.5],'YLim',[-0.5 0.5], ...
    'XTick',[],'YTick',[], ...
    'Drawmode','fast', ...
    'Visible','on', ...
    'NextPlot','add', ...
    'Color', [0 0 0]);
xlabel('X');
ylabel('Y');
serie = [x y; zeros(9999, 2)];
lne_body = line( ...
    'color','y', ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'markersize',1, ...
    'erase','none', ...
    'xdata',[],'ydata',[]);
lne_tail=line( ...
    'color',[0.5 0.5 1], ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'markersize',1, ...
    'erase','none', ...
    'xdata',[],'ydata',[]);
lne_trace=line( ...
    'color',[0.2 0.2 1], ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'markersize',1, ...
    'erase','none', ...
    'xdata',[],'ydata',[]);

set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
cchr = get(handles.fractal_explorer, 'CurrentCharacter');
zoom on;
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), cchr)
    tmp = [];
    for i = 1:20
        xx = y+handles.ctes(1)-handles.ctes(2)*x^2;
        y = handles.ctes(3)*x;
        x = xx;
        tmp = [tmp; x y];
    end
    serie = [tmp; serie(1:end-20,:)];
    set(lne_trace,'xdata',serie(500:end-2, 1),'ydata',serie(500:end-2, 2));
    set(lne_tail,'xdata',serie(41:499, 1),'ydata',serie(41:499, 2));
    set(lne_body,'xdata',serie(1:40,1),'ydata',serie(1:40,2));
    drawnow;
end
hold off;
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.txt_help, 'Visible', 'off');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_pickover_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


ctes = {'2.723456789' '2.123456789' '1.12345' '1.54321';
    '-2.01' '-1.01' '0.51' '1.49'; '2.05' '1.728' '2.08' '0.45';
    '2.723' '2.123' '2' '1.54321'; '3' '1.86' '2.06' '0.45';
    '2.723' '2.123' '2.9' '1.54321'; '2.15' '1.75' '0.89' '1.4';
    '2.05' '1.728' '0.89' '0.29'; '3' '2.84' '1' '0.8';
    '2.723' '2.123' '2.9' '2.6'; '-2.99' '1.43' '0.51' '1.49'};
msg = sprintf('Pickover Dynamic System:\n\nIterations on the system:\nx = sin(b*y)+c*sin/b*x)\ny = sin(a*x)+d*sin(a*y)\n\nSpecify the constants:\n\n');
if ~isfield(handles, 'pickover_params')
    handles.pickover_params = {ctes{unidrnd(length(ctes)), :}};
elseif isempty(handles.pickover_params)
    handles.pickover_params = {ctes(unidrnd(length(ctes)), :)};
end
handles.pickover_params = localdlg({[msg 'a:'], 'b:', 'c:', 'd:'}, 'Pickover System', [1 10], handles.pickover_params, ...
    ['usrdta = get(gcbf, ''UserData''); z = unidrnd(length(usrdta.Data)); for i=1:length(usrdta.EditHandles), '...
        'set(usrdta.EditHandles(i), ''String'', str2num(usrdta.Data{z,i})); end;'], 'Cool Params', ctes);
if isempty(handles.pickover_params)
    return;
end
for i = 1:length(handles.pickover_params)
    handles.ctes(i) = str2num(handles.pickover_params{i});
end
handles.mode = -4;
x = 0.1;
y = 0.1;
set(handles.fractal_explorer, 'KeyPressFcn', ';');
set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia
handles = fillupdescription(handles);
set(handles.txt_help, 'String', sprintf('Press any key to stop.\nTo zoom in during the calculation,\nselect a zone with the mouse.\nTo zoom out, right-click.'));
set(handles.txt_help, 'Visible', 'on');
axes(handles.main_axis);
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end

set(handles.main_axis, 'Drawmode','normal');
plot(0, 0, 'k.', 'MarkerSize', 1);
set(handles.main_axis, ...
    'XLim',[-4 4],'YLim',[-4 4], ...
    'XTick',[],'YTick',[], ...
    'Drawmode','fast', ...
    'Visible','on', ...
    'NextPlot','add', ...
    'Color', [0 0 0]);
xlabel('X');
ylabel('Y');
serie = [x y; zeros(9999, 2)];
lne_body = line( ...
    'color','y', ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'MarkerSize',1, ...
    'erase','none', ...
    'xdata',[],'ydata',[]);
lne_tail=line( ...
    'color',[0.5 0.5 1], ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'MarkerSize',1, ...
    'erase','none', ...
    'xdata',[],'ydata',[]);
lne_trace=line( ...
    'color',[0.3 0.3 1], ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'MarkerSize',1, ...
    'erase','none', ...
    'xdata',[],'ydata',[]);

set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
cchr = get(handles.fractal_explorer, 'CurrentCharacter');
zoom on;
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), cchr)
    tmp = [];
    for i = 1:20
        xx = sin(handles.ctes(2)*y)+handles.ctes(3)*sin(handles.ctes(2)*x);
        y = sin(handles.ctes(1)*x)+handles.ctes(4)*sin(handles.ctes(1)*y);
        x = xx;
        tmp = [tmp; x y];
    end
    serie = [tmp; serie(1:end-20,:)];
    set(lne_trace,'xdata',serie(5000:end-2, 1),'ydata',serie(5000:end-2, 2));
    set(lne_tail,'xdata',serie(41:4999, 1),'ydata',serie(41:4999, 2));
    set(lne_body,'xdata',serie(1:40,1),'ydata',serie(1:40,2));
    drawnow;
end
hold off;
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.txt_help, 'Visible', 'off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_head_image_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_head_colors_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_colors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_color_standard_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_standard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap(handles.main_axis, 'default');
colormap(handles.preview_axis, 'default');
handles = managecolorticks(handles);
set(hObject, 'Checked', 'on');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_color_copper_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_copper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap(handles.main_axis, 'copper');
colormap(handles.preview_axis, 'copper');
handles = managecolorticks(handles);
set(hObject, 'Checked', 'on');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_color_psy_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_psy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap(handles.main_axis, 'flag');
colormap(handles.preview_axis, 'flag');
handles = managecolorticks(handles);
set(hObject, 'Checked', 'on');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_color_hot_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_hot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap(handles.main_axis, 'hot');
colormap(handles.preview_axis, 'hot');
handles = managecolorticks(handles);
set(hObject, 'Checked', 'on');
guidata(hObject, handles);



% --------------------------------------------------------------------
function menu_color_cool_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_cool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap(handles.main_axis, 'cool');
colormap(handles.preview_axis, 'cool');
handles = managecolorticks(handles);
set(hObject, 'Checked', 'on');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_color_spring_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_spring (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


colormap(handles.main_axis, 'spring');
colormap(handles.preview_axis, 'spring');
handles = managecolorticks(handles);
set(hObject, 'Checked', 'on');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_color_summer_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_summer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap(handles.main_axis, 'summer');
colormap(handles.preview_axis, 'summer');
handles = managecolorticks(handles);
set(hObject, 'Checked', 'on');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_color_autumn_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_autumn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap(handles.main_axis, 'autumn');
colormap(handles.preview_axis, 'autumn');
handles = managecolorticks(handles);
set(hObject, 'Checked', 'on');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_color_winter_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_winter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

colormap(handles.main_axis, 'winter');
colormap(handles.preview_axis, 'winter');
handles = managecolorticks(handles);
set(hObject, 'Checked', 'on');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_head_colorshift_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_colorshift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_color_shift_one_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_shift_one (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mapp = colormap(gca);
mapp = [mapp(2:end, :); mapp(1, :)];
colormap(handles.main_axis, mapp);
colormap(handles.preview_axis, mapp);


% --------------------------------------------------------------------
function menu_color_shift_conti_Callback(hObject, eventdata, handles)
% hObject    handle to menu_color_shift_conti (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fractal_explorer, 'KeyPressFcn', ';');
set(handles.txt_help, 'String', sprintf('Press any key to stop.'));
set(handles.txt_help, 'Visible', 'on');
axes(handles.main_axis);
s_space = get(handles.main_image, 'CData');
handles.space = s_space;
set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
cchr = get(handles.fractal_explorer, 'CurrentCharacter');
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), cchr)
    handles.space = mod(handles.space + 1, 127);
    set(handles.main_image, 'EraseMode', 'none');
    set(handles.main_image, 'CData', handles.space);
    drawnow;
end
set(handles.main_image, 'CData', s_space);
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.txt_help, 'Visible', 'off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_head_2d_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_2d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_head_3d_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_3d (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_quadratic_Callback(hObject, eventdata, handles)
% hObject    handle to menu_quadratic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ctes:
tmp = ['amtmnqqxuyga';'cvqkghqtphte';'fircderrpvld';'giietpiqrrul';'glxoesfttpsv';'gxqsnskeectx';'hguhdphnsgoh';'ilibvpkjwgrr';...
        'lufbbfisgjys';'mcrbipophtbn';'mdvaidoyhyea';'odgqcnxodnya';'qffvslmjjgcr';'uwacxdqigkhf';'vbwnbdelyhul';'wncslflgihgl'];
for i = 1:size(tmp, 1)
    for j = 1:size(tmp,2)
        n_val = -1.2+0.1*(double(tmp(i, j))-97);
        if abs(n_val) < 1e-3
            n_val = 0;
        end
        ctes{i, j} = num2str(n_val);
    end
end
msg = sprintf(['Complete Quadratic Map:\n\nx = a+ bx+ cx^2+ dxy+ ey+ fy^2\ny = g + hx+ ix^2+ jxy+ ky+ ly^2\n\n']);
if ~isfield(handles, 'quadmap_params')
    handles.quadmap_params = {ctes{unidrnd(length(ctes)), :}};
elseif isempty(handles.quadmap_params)
    handles.quadmap_params = {ctes(unidrnd(length(ctes)), :)};
end
handles.quadmap_params = localdlg({[msg 'a:'], 'b:', 'c:', 'd:', 'e:', 'f:', 'g:', 'h:', 'i:', 'j:', 'k:', 'l:'}, 'Quadratic Map', [1 10], ...
    handles.quadmap_params, ['usrdta = get(gcbf, ''UserData''); z = unidrnd(length(usrdta.Data)); for i=1:length(usrdta.EditHandles), '...
        'set(usrdta.EditHandles(i), ''String'', str2num(usrdta.Data{z,i})); end;'], 'Cool Params', ctes);
if isempty(handles.quadmap_params)
    return;
end
for i = 1:length(handles.quadmap_params)
    handles.ctes(i) = str2num(handles.quadmap_params{i});
end
handles.mode = -5;
x = 0.1;
y = 0.1;
set(handles.fractal_explorer, 'KeyPressFcn', ';');
set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia
handles = fillupdescription(handles);
set(handles.txt_help, 'String', sprintf('Press any key to stop.\nTo zoom in during the calculation,\nselect a zone with the mouse.\nTo zoom out, right-click.'));
set(handles.txt_help, 'Visible', 'on');
axes(handles.main_axis);
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end

set(handles.main_axis, 'Drawmode','normal');
plot(0, 0, 'k.', 'MarkerSize', 1);
set(handles.main_axis, ...
    'XLim',[-4 4],'YLim',[-4 4], ...
    'XTick',[],'YTick',[], ...
    'Drawmode','fast', ...
    'Visible','on', ...
    'NextPlot','add', ...
    'Color', [0 0 0]);
xlabel('X');
ylabel('Y');
serie = [x y; zeros(9999, 2)];
lne_body = line( ...
    'color','y', ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'markersize',1, ...
    'erase','none', ...
    'xdata',[],'ydata',[]);
lne_tail=line( ...
    'color',[0.6 0.6 1], ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'markersize',1, ...
    'erase','none', ...
    'xdata',[],'ydata',[]);
lne_trace=line( ...
    'color',[0.3 0.3 1], ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'markersize',1, ...
    'erase','none', ...
    'xdata',[],'ydata',[]);

set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
cchr = get(handles.fractal_explorer, 'CurrentCharacter');
zoom on;
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), cchr)
    tmp = [];
    for i = 1:20
        xx = handles.ctes(1)+handles.ctes(2)*x+handles.ctes(3)*x^2+handles.ctes(4)*x*y+handles.ctes(5)*y+handles.ctes(6)*y^2;
        y = handles.ctes(7)+handles.ctes(8)*x+handles.ctes(9)*x^2+handles.ctes(10)*x*y+handles.ctes(11)*y+handles.ctes(12)*y^2;
        x = xx;
        tmp = [tmp; x y];
    end
    serie = [tmp; serie(1:end-20,:)];
    set(lne_trace,'xdata',serie(500:end-2, 1),'ydata',serie(500:end-2, 2));
    set(lne_tail,'xdata',serie(41:499, 1),'ydata',serie(41:499, 2));
    set(lne_body,'xdata',serie(1:40,1),'ydata',serie(1:40,2));
    drawnow;
end
hold off;
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.txt_help, 'Visible', 'off');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_3d_quadratic_Callback(hObject, eventdata, handles)
% hObject    handle to menu_3d_quadratic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ctes = {'-0.9265', '-0.3559', '1.1407', '0.7124', '0.6284', '2.3291';
    '-0.5979', '2.1002', '1.9831', '-0.4003', '-0.9395', '-0.7943';
    '-0.9442', '-0.2482', '1.3302', '2.2930', '0.0177', '1.6679';
    '1.6619', '-0.5615', '-0.7754', '-0.3045', '-0.1223', '0.0075';
    '-0.2470', '0.7607', '-0.8069', '2.4585', '1.0668', '2.7723';
    '-0.6662', '0.1314', '1.3999', '-0.7810', '0.9384', '2.9119';
    '1.4158', '0.5323', '0.1181', '0.2789', '-0.8468', '-0.3616';
    '-0.1649', '-0.0193', '-0.8416', '2.5414', '-0.8609', '1.4893';
    '-0.9246', '1.5296', '0.9030', '1.4218', '1.5015', '0.7241'
    '-0.8783', '0.7726', '-0.1282', '1.0554', '0.5411', '0.9502'};
%uiwait(msgbox('Sorry, this feature is not working properly yet.', 'CSE Warning', 'modal'));
msg = sprintf('3D Quadratic Map:\n\nIterations on the system:\nx = a+ bx+ cx^2+ dxy+ ey+ fy^2\ny = x\nz = y\n\nSpecify the constants:\n\n');
if ~isfield(handles, 'quad3d_params')
    handles.quad3d_params = {ctes{unidrnd(length(ctes)), :}};
elseif isempty(handles.quad3d_params)
    handles.quad3d_params = {ctes{unidrnd(length(ctes)), :}};
end
handles.quad3d_params = localdlg({[msg 'a:'], 'b:', 'c:', 'd:', 'e:', 'f:'}, '3D Quadratic Map', [1 10], handles.quad3d_params, ...
    ['usrdta = get(gcbf, ''UserData''); z = unidrnd(length(usrdta.Data)); for i=1:length(usrdta.EditHandles), '...
        'set(usrdta.EditHandles(i), ''String'', str2num(usrdta.Data{z,i})); end;'], 'Cool Params', ctes);
if isempty(handles.quad3d_params)
    return;
end
for i = 1:length(handles.quad3d_params)
    handles.ctes(i) = str2num(handles.quad3d_params{i});
end
handles.mode = -6;
x = 0.1000001;
y = -0.1000001;
z = 1.0000001;
set(handles.fractal_explorer, 'KeyPressFcn', ';');
handles = fillupdescription(handles);
set(handles.txt_help, 'String', sprintf('Press any key to stop.\nUse the mouse to modify the\nobservation angle in 3 dimensions.\nPress ''n'' to randomize the parameters.'));
set(handles.txt_help, 'Visible', 'on');
axes(handles.main_axis);
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end

set(handles.main_axis, 'Drawmode','normal');
plot3(0, 0, 0, 'k.', 'MarkerSize', 1);
set(handles.main_axis, ...
    'XLim',[-2 2],'YLim',[-2 2],'ZLim',[-2 2], ...
    'XTick',[],'YTick',[],'ZTick',[], ...
    'Drawmode','fast', ...
    'Visible','on', ...
    'NextPlot','add', ...
    'Color', [0 0 0], ...
    'View',[145, -14]); % [-49,16]
xlabel('X');
ylabel('Y');
zlabel('Z');
serie = [x y z; zeros(3999, 3)];
lne_head = line( ...
    'color','r', ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'markersize',25, ...
    'erase','xor', ...
    'xdata',serie(1),'ydata',serie(2),'zdata',serie(3));
lne_body = line( ...
    'color','y', ...
    'Marker','.', ...
    'markersize',1, ...
    'LineStyle', 'none', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_tail=line( ...
    'color',[0.3 0.3 1], ...
    'Marker','.', ...
    'markersize',1, ...
    'LineStyle', 'none', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_trace=line( ...
    'color','b', ...
    'Marker','.', ...
    'markersize',1, ...
    'LineStyle', 'none', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_dust=line( ...
    'color',[0 0 0.5], ...
    'Marker','.', ...
    'markersize',1, ...
    'LineStyle', 'none', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);

rotate3d on;
x_old = 0; y_old = 0; z_old = 0;
set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
cchr = get(handles.fractal_explorer, 'CurrentCharacter');
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), cchr)
    x_ld = x_old; y_ld = y_old; z_ld = z_old;
    x_old = x; y_old = y; z_old = z;
    xx = handles.ctes(1)+handles.ctes(2)*x+handles.ctes(3)*x^2+handles.ctes(4)*x*y+handles.ctes(5)*y+handles.ctes(6)*y^2;
    z = y;
    y = x;
    x = xx;
    serie = [x y z; serie(1:end-1,:)];
    set(lne_trace,'xdata',serie(500:end-2, 1),'ydata',serie(500:end-2, 2),'zdata',serie(500:end-2, 3));
    set(lne_dust,'xdata',serie(end-1:end, 1),'ydata',serie(end-1:end, 2),'zdata',serie(end-1:end, 3));
    set(lne_tail,'xdata',serie(41:499, 1),'ydata',serie(41:499, 2),'zdata',serie(41:499, 3));
    set(lne_head,'xdata',serie(1,1),'ydata',serie(1, 2),'zdata',serie(1, 3));
    set(lne_body,'xdata',serie(1:40,1),'ydata',serie(1:40,2),'zdata',serie(1:40,3));
    drawnow;
    if abs(x) > 10 | abs(y) > 10 | abs(z) > 10 | strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), 'n') | ...
            (abs(x-x_old)<1e-5 & abs(y-y_old)<1e-5 & abs(z-z_old)<1e-5) | (abs(x-x_ld)<1e-5 & abs(y-y_ld)<1e-5 & abs(z-z_ld)<1e-5)
%         uiwait(msgbox(sprintf('This map is not chaotic but divergent.\nStopping calculation.'), 'CSE Info', 'modal'));
%         set(handles.fractal_explorer, 'CurrentCharacter', 'ö');
		for i = 1:length(handles.quad3d_params)
            handles.ctes(i) = unifrnd(-1, 3);
		end
		x = 0.1000001;
		y = -0.1000001;
		z = 1.0000001;
		handles = fillupdescription(handles);
        hold off;
		set(handles.main_axis, 'Drawmode','normal');
		plot3(0, 0, 0, 'k.', 'MarkerSize', 1);
		set(handles.main_axis, ...
            'XLim',[-2 2],'YLim',[-2 2],'ZLim',[-2 2], ...
            'XTick',[],'YTick',[],'ZTick',[], ...
            'Drawmode','fast', ...
            'Visible','on', ...
            'NextPlot','add', ...
            'Color', [0 0 0], ...
            'View',[145, -14]); % [-49,16]
		xlabel('X');
		ylabel('Y');
		zlabel('Z');
		serie = [x y z; zeros(3999, 3)];
		lne_head = line( ...
            'color','r', ...
            'Marker','.', ...
            'markersize',25, ...
            'LineStyle', 'none', ...
            'erase','xor', ...
            'xdata',serie(1),'ydata',serie(2),'zdata',serie(3));
		lne_body = line( ...
            'color','y', ...
            'Marker','.', ...
            'markersize',1, ...
            'LineStyle', 'none', ...
            'erase','none', ...
            'xdata',[],'ydata',[],'zdata',[]);
		lne_tail=line( ...
            'color',[0.3 0.3 1], ...
            'Marker','.', ...
            'markersize',1, ...
            'LineStyle', 'none', ...
            'erase','none', ...
            'xdata',[],'ydata',[],'zdata',[]);
		lne_trace=line( ...
            'color','b', ...
            'Marker','.', ...
            'markersize',1, ...
            'LineStyle', 'none', ...
            'erase','none', ...
            'xdata',[],'ydata',[],'zdata',[]);
		lne_dust=line( ...
            'color',[0 0 0.5], ...
            'Marker','.', ...
            'markersize',1, ...
            'LineStyle', 'none', ...
            'erase','none', ...
            'xdata',[],'ydata',[],'zdata',[]);
		rotate3d on;
        set(handles.fractal_explorer, 'CurrentCharacter', cchr);
    end
end
hold off;
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.txt_help, 'Visible', 'off');
guidata(hObject, handles);

% --------------------------------------------------------------------
function manu_head_string_Callback(hObject, eventdata, handles)
% hObject    handle to manu_head_string (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_lindenmayer_head_Callback(hObject, eventdata, handles)
% hObject    handle to menu_lindenmayer_head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_patterns_Callback(hObject, eventdata, handles)
% hObject    handle to menu_patterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ctes = {'F' 'f' 'YF+XF+Y' 'XF-YF-X' '1.0472' 'YF' '8';
    'F' 'f' 'XF+F+XF-F-F-XF-F+F+F-F+F+F-X' 'XF+F+XF+F+XF+F' '1.0472' 'Y' '5';
    'F' 'f' 'X+YF+' '-FX-Y' '1.5708' 'FX' '10';
    'F' 'f' 'XF-F+F-XF+F+XF-F+F-X' 'Y' '1.5708' 'F+XF+F+XF' '5';};
msg = sprintf('Multiple Rules Lindenmayer Systems:\n\nGrammar:\nF: Draw Line;f: Forward (no draw)\nX,Y: Do nothing\n+,-: change x-angle;\n\n');
if ~isfield(handles, 'multi_lin_params')
    handles.multi_lin_params = {ctes{unidrnd(size(ctes, 1)), :}};
elseif isempty(handles.multi_lin_params)
    handles.multi_lin_params = {ctes(unidrnd(size(ctes, 1)), :)};
end
handles.multi_lin_params = localdlg({[msg 'F->'], 'f->', 'X->', 'Y->', 'Angle:', 'Intial String:', 'Iterations:'}, 'Lindenmayer Systems', [1 20], handles.multi_lin_params, ...
    ['usrdta = get(gcbf, ''UserData''); z = unidrnd(size(usrdta.Data, 1)); for i=1:length(usrdta.EditHandles), '...
        'set(usrdta.EditHandles(i), ''String'', usrdta.Data{z,i}); end;'], 'Cool Params', ctes);
if isempty(handles.multi_lin_params)
    return;
end
unit = 1;
unit_factor = 1/4;
rules(1).code = 'F';
rules(1).replace = handles.multi_lin_params{1};
rules(2).code = 'f';
rules(2).replace = handles.multi_lin_params{2};
rules(3).code = 'X';
rules(3).replace = handles.multi_lin_params{3};
rules(4).code = 'Y';
rules(4).replace = handles.multi_lin_params{4};
alpha = str2num(handles.multi_lin_params{5});
lin_string = handles.multi_lin_params{6};
m_iter = round(str2num(handles.multi_lin_params{7}));
handles.mode = -10;

handles.lindenrules = '';
for i = 1:length(rules)
    handles.lindenrules = [handles.lindenrules rules(i).code '->' rules(i).replace '\n'];
end
graphic_rules(1).code = 'F';
graphic_rules(1).type = 0;
graphic_rules(1).style = 'y-';
graphic_rules(2).code = '+';
graphic_rules(2).type = 2;
graphic_rules(2).value = -alpha;
graphic_rules(3).code = '-';
graphic_rules(3).type = 2;
graphic_rules(3).value = alpha;
graphic_rules(4).code = 'f';
graphic_rules(4).type = 1;
graphic_rules(5).code = 'X';
graphic_rules(5).type = -1;
graphic_rules(6).code = 'Y';
graphic_rules(6).type = -1;
handles = fillupdescription(handles);
set(gcf,'Pointer','watch');
axes(handles.main_axis);
for i = 1:m_iter
   [lin_string, overflow] = expand_string(lin_string, rules);
   if overflow
       i = m_iter + 1;
       uiwait(msgbox('Overflow: String too long.', 'CSE Error'));
   else
       unit = unit * unit_factor;
       handles = interpret_string(handles, lin_string, graphic_rules, unit);
   end
   drawnow;
end
set(gcf,'Pointer','arrow');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_flakes_Callback(hObject, eventdata, handles)
% hObject    handle to menu_flakes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ctes = {'F+F--F+F' '0.5236' 'F-F-F-F-F-F' '4';
    'F-F+F' '2.0944' 'F+F+F' '6'; 'F+F-F+F+F' '1.5708' 'F+F+F+F' '5';
    'F+f+F-FF+f+F-F' '1.5708' 'F+F+F+F' '5'; 'F-f++F-f' '1.5708' 'F++F++F' '8';
    'FF+F+F+F+F+F-F' '1.5708' 'F+F+F+F' '4'; 'F-FF+FF+F+F-F-FF' '1.5708' 'F++F++F' '3';
    'FF+F+F+F+FF' '1.5708' 'F+F+F+F' '4'; 'F-FF+FF+F+F-F-FF' '1.5708' 'F++F++F' '3';
    'FF+F++F+F' '1.5708' 'F+F+F+F' '4'; 'F-F+F+F-F' '1.5708' 'F++F++F' '3';};
msg = sprintf('Single Rule Lindenmayer Systems:\n\nGrammar:\nF: Draw Line;f: Forward (no draw)\n+,-: change x-angle;\n\n');
if ~isfield(handles, 'single_lin_params')
    handles.single_lin_params = {ctes{unidrnd(length(ctes)), :}};
elseif isempty(handles.single_lin_params)
    handles.single_lin_params = {ctes(unidrnd(length(ctes)), :)};
end
handles.single_lin_params = localdlg({[msg 'F->'], 'Angle:', 'Intial String:', 'Iterations:'}, 'Lindenmayer Systems', [1 20], handles.single_lin_params, ...
    ['usrdta = get(gcbf, ''UserData''); z = unidrnd(length(usrdta.Data)); for i=1:length(usrdta.EditHandles), '...
        'set(usrdta.EditHandles(i), ''String'', usrdta.Data{z,i}); end;'], 'Cool Params', ctes);
if isempty(handles.single_lin_params)
    return;
end
unit = 1;
unit_factor = 1/4;
rules(1).code = 'F';
rules(1).replace = handles.single_lin_params{1};
alpha = str2num(handles.single_lin_params{2});
lin_string = handles.single_lin_params{3};
m_iter = round(str2num(handles.single_lin_params{4}));
handles.mode = -10;

handles.lindenrules = '';
for i = 1:length(rules)
    handles.lindenrules = [handles.lindenrules rules(i).code '->' rules(i).replace '\n'];
end
graphic_rules(1).code = 'F';
graphic_rules(1).type = 0;
graphic_rules(1).style = 'y-';
graphic_rules(2).code = '+';
graphic_rules(2).type = 2;
graphic_rules(2).value = -alpha;
graphic_rules(3).code = '-';
graphic_rules(3).type = 2;
graphic_rules(3).value = alpha;
graphic_rules(4).code = 'f';
graphic_rules(4).type = 1;
handles = fillupdescription(handles);
set(gcf,'Pointer','watch');
axes(handles.main_axis);
for i = 1:m_iter
   [lin_string, overflow] = expand_string(lin_string, rules);
   if overflow
       i = m_iter + 1;
       uiwait(msgbox('Overflow: String too long.', 'CSE Error'));
   else
       unit = unit * unit_factor;
       handles = interpret_string(handles, lin_string, graphic_rules, unit);
   end
   drawnow;
end
set(gcf,'Pointer','arrow');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_plants_head_Callback(hObject, eventdata, handles)
% hObject    handle to menu_plants_head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_fern_Callback(hObject, eventdata, handles)
% hObject    handle to menu_fern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.mode = -9;
set(handles.fractal_explorer, 'KeyPressFcn', ';');
set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia
handles = fillupdescription(handles);
set(handles.txt_help, 'String', sprintf('Press any key to stop.\nTo zoom in during the calculation,\nselect a zone with the mouse.\nTo zoom out, right-click.'));
set(handles.txt_help, 'Visible', 'on');
axes(handles.main_axis);
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end
set(handles.main_axis, 'Drawmode','normal');
plot(0, 0, 'k.', 'MarkerSize', 1);
set(handles.main_axis, ...
    'XLim',[-5 5],'YLim',[0 11], ...
    'XTick',[],'YTick',[], ...
    'Drawmode','fast', ...
    'Visible','on', ...
    'NextPlot','add', ...
    'Color', [0 0 0]);
serie = [zeros(2000, 2)];
lne_head = line( ...
    'color','g', ...
    'Marker','.', ...
    'LineStyle', 'none', ...
    'markersize',2, ...
    'erase','none', ...
    'xdata',serie(:, 1),'ydata',serie(:, 2));
zoom on;
set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
cchr = get(handles.fractal_explorer, 'CurrentCharacter');
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), cchr)
    x = rand(1);
    y = rand(1);
    locser = zeros(10, 2);
    for k = 1:10
        for j = 1:20
            p = rand(1);
            if p > 0.15
                newx = 0.85*x+0.04*y;
                y = -0.04*x + 0.85*y + 1.6;
                x = newx;
            elseif p > 0.08
                newx = -0.15*x+0.28*y;
                y = 0.26*x+0.24*y+0.44;
                x = newx;
            elseif p > 0.01
                newx = 0.2*x-0.26*y;
                y = 0.23*x+0.22*y+1.6;
                x = newx;
            else
                newx = 0;
                y = 0.16*y;
                x = newx;
            end
        end
        locser(11-k, :) = [x y];
    end
    serie = [locser ;serie(1:end-11, :)];
    set(lne_head, 'xdata', serie(:,1), 'ydata', serie(:,2));
    drawnow;
end
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.txt_help, 'Visible', 'off');
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_tree_Callback(hObject, eventdata, handles)
% hObject    handle to menu_tree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ctes = {'FF+T[+Fl-Fl-FL]-[-FL+FP+Fl]' 'f' 'X' 'Y' '0.3491' 'BB++++F' '4';
    'F[+TTTFL]F[-TTTTFl]F' 'f' 'X' 'Y' '0.3491' 'B++++F' '4';
    'FF' 'f' 'F[+TXP]F[-TXL]+TX' 'Y' '0.3491' 'B++++X' '6';
    'F' 'f' 'X[-TFFF][+TFFF]FTX' 'YFX[+TY][-TY]' '0.4485' 'B++++Y' '5';
    'FF' 'f' 'F-[[TXL]+X]+F[+TFXL]-X' 'Y' '0.3927' 'B++++X' '5';};
msg = sprintf(['Multiple Rules Lindenmayer Systems:\n\nGrammar:\nF: Draw Line;f: Forward (no draw)\nX,Y: Do nothing\n+,-: change x-angle;\n[,]:' ...
    'Push and pull stack (memory)\nB: Broad trunc; T: Slim trunc\nL,l: Big/small leaf; P: Fruit.\n\n']);
if ~isfield(handles, 'tree_lin_params')
    handles.tree_lin_params = {ctes{unidrnd(size(ctes, 1)), :}};
elseif isempty(handles.tree_lin_params)
    handles.tree_lin_params = {ctes(unidrnd(size(ctes, 1)), :)};
end
handles.tree_lin_params = localdlg({[msg 'F->'], 'f->', 'X->', 'Y->', 'Angle:', 'Intial String:', 'Iterations:'}, 'Lindenmayer Systems', [1 20], handles.tree_lin_params, ...
    ['usrdta = get(gcbf, ''UserData''); z = unidrnd(size(usrdta.Data, 1)); for i=1:length(usrdta.EditHandles), '...
        'set(usrdta.EditHandles(i), ''String'', usrdta.Data{z,i}); end;'], 'Cool Params', ctes);
if isempty(handles.tree_lin_params)
    return;
end
unit = 1;
unit_factor = 1/4;
rules(1).code = 'F';
rules(1).replace = handles.tree_lin_params{1};
rules(2).code = 'f';
rules(2).replace = handles.tree_lin_params{2};
rules(3).code = 'X';
rules(3).replace = handles.tree_lin_params{3};
rules(4).code = 'Y';
rules(4).replace = handles.tree_lin_params{4};
alpha = str2num(handles.tree_lin_params{5});
lin_string = handles.tree_lin_params{6};
m_iter = round(str2num(handles.tree_lin_params{7}));
handles.mode = -10;

handles.lindenrules = '';
for i = 1:length(rules)
    handles.lindenrules = [handles.lindenrules rules(i).code '->' rules(i).replace '\n'];
end
graphic_rules(1).code = 'F';
graphic_rules(1).type = 0;
graphic_rules(1).style = 'y-';
graphic_rules(2).code = '+';
graphic_rules(2).type = 2;
graphic_rules(2).value = -alpha;
graphic_rules(3).code = '-';
graphic_rules(3).type = 2;
graphic_rules(3).value = alpha;
graphic_rules(4).code = 'f';
graphic_rules(4).type = 1;
graphic_rules(5).code = 'X';
graphic_rules(5).type = -1;
graphic_rules(6).code = 'Y';
graphic_rules(6).type = -1;
graphic_rules(7).code = 'L';
graphic_rules(7).type = 3;
graphic_rules(7).style = 'gd';
graphic_rules(7).value = 10;
graphic_rules(8).code = 'P';
graphic_rules(8).type = 3;
graphic_rules(8).style = 'ro';
graphic_rules(8).value = 6;
graphic_rules(9).code = '[';
graphic_rules(9).type = 4;
graphic_rules(10).code = ']';
graphic_rules(10).type = 5;
graphic_rules(11).code = 'B';
graphic_rules(11).type = 6;
graphic_rules(11).value = 3;
graphic_rules(12).code = 'T';
graphic_rules(12).type = 7;
graphic_rules(12).value = 0.9;
graphic_rules(13).code = 'l';
graphic_rules(13).type = 3;
graphic_rules(13).style = 'gd';
graphic_rules(13).value = 6;
handles = fillupdescription(handles);
set(gcf,'Pointer','watch');
axes(handles.main_axis);
for i = 1:m_iter
   [lin_string, overflow] = expand_string(lin_string, rules);
   if overflow
       set(gcf,'Pointer','arrow');
       uiwait(msgbox('Overflow: String too long.', 'CSE Error'));
       break;
   else
       unit = unit * unit_factor;
       handles = interpret_string(handles, lin_string, graphic_rules, unit);
   end
   drawnow;
end
set(gcf,'Pointer','arrow');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_linden3D_head_Callback(hObject, eventdata, handles)
% hObject    handle to menu_linden3D_head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_sponge_Callback(hObject, eventdata, handles)
% hObject    handle to menu_sponge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% x = [0 1 1 0 0 0;1 1 0 0 1 1;1 1 0 0 1 1;0 1 1 0 0 0];
% y = [0 0 1 1 0 0; 0 1 1 0 0 0; 0 1 1 0 1 1; 0 0 1 1 1 1];
% z = [0 0 0 0 0 1; 0 0 0 0 0 1; 1 1 1 1 0 1; 1 1 1 1 0 1];
handles.mode = -11;
handles = fillupdescription(handles);

set(gcf,'Pointer','watch');
axes(handles.main_axis);
try 
    delete(handles.main_image); 
end
hold off;
plot3(0, 0, 0, 'k.');
faces = [1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8];
vertices.coordinates = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1];
vertices.coordinates = vertices.coordinates * 0.99999;
hdls = patch('Vertices',vertices(1).coordinates,'Faces',faces,'FaceVertexCData',i,'FaceColor','flat');
drawnow;
nb_iter = 3;
for i_i = 1:nb_iter
    hold off;
    clear new_vertices;
    idx = 1;
    for j = 1:length(vertices)
        % we need 3*3*3 cubes;
        % dimensions are reducted by a factor 1/3
        cube_vertices = vertices(j).coordinates * 1/3;
        z = -1;
        while z < 2
            % now we move the cube along the x axis, of a distance of 1/3
            for k = 1:2
                cube_vertices = cube_vertices + repmat([1/3 0 0],8,1); 
                if abs(z) > 0 | k == 2
                    new_vertices(idx).coordinates = cube_vertices;
                    idx = idx + 1;
                end
            end
            % now we move along the y axis
            for k = 1:2
                cube_vertices = cube_vertices + repmat([0 1/3 0],8,1); 
                if abs(z) > 0 | k == 2
                    new_vertices(idx).coordinates = cube_vertices;
                    idx = idx + 1;
                end
            end
            % now we move backward along the x axis
            for k = 1:2
                cube_vertices = cube_vertices + repmat([-1/3 0 0],8,1);
                if abs(z) > 0 | k == 2
                    new_vertices(idx).coordinates = cube_vertices;
                    idx = idx + 1;
                end
            end
            % now we move backward along the y axis
            for k = 1:2
                cube_vertices = cube_vertices + repmat([0 -1/3 0],8,1);
                if abs(z) > 0 | k == 2
                    new_vertices(idx).coordinates = cube_vertices;
                    idx = idx + 1;
                end
            end
            % we are at the starting point, let's increase the z axis
            z = z + 1;
            cube_vertices = cube_vertices + repmat([0 0 1/3],8,1);
        end
    end
    for j = 1:length(vertices)
        delete(hdls(j));
    end
    hdls = [];
    vertices = new_vertices;
    for j = 1:length(vertices)
        hdls = [hdls patch('Vertices',vertices(j).coordinates,'Faces',faces,'FaceVertexCData',[1 2 3 4 5 6]','FaceColor','flat', 'LineStyle', 'none')];
        hold on;
    end
	axis equal;
	view([-4, -4]);
	set(gca,'Visible','off');
    rotate3d on;
    drawnow;
end
set(gcf,'Pointer','arrow');

% --------------------------------------------------------------------
function menu_save_Callback(hObject, eventdata, handles)
% hObject    handle to menu_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[imgname, pathnme] = uiputfile({'*.jpg;*.jpeg', 'JPEG Images'; '*.*', 'All Files (*.*)'}, 'Save image as');
if imgname ~= 0
    answr = inputdlg({'Enter Quality (1-100):'}, 'Save Image...', 1, {num2str(100)});
    if ~isempty(answr)
        if length(imgname) < 4 || ~strcmp(imgname(end-3:end), '.jpg')
            imgname = [imgname '.jpg'];
        end
        imgname = fullfile(pathnme, imgname);
        qual = str2num(answr{1});
        if qual < 10 | qual > 100
            uiwait(errordlg('Quality must be between 1 and 100.', 'JPEG Save', 'modal'));
        else
            if handles.mode > 0 | handles.mode == -13
                mpp = colormap(handles.main_axis);
                %blop = round(handles.space ./ max(max(handles.space)) * (length(mpp)-1) + 1);
                imwrite(round(handles.space ./ max(max(handles.space)) * (length(mpp)-1) + 1), mpp, imgname, 'Quality', qual, ...
                    'Comment', 'Generated by CSE Fractals III');
            else
                set(handles.fractal_explorer,'InvertHardcopy','off')
                set(handles.fractal_explorer,'PaperPositionMode','auto')
                print(handles.fractal_explorer, ['-djpeg' int2str(qual)], imgname, '-opengl');
            end
        end
    end
end

% --------------------------------------------------------------------
function menu_newton_user_Callback(hObject, eventdata, handles)
% hObject    handle to menu_newton_user (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


msg = sprintf('Newton''s Method:\n\nSolutions of the system:\na*z^m+ b*z^n +c*z^o + d*z^p = 1\n\nSpecify POSITIVE INTEGER powers:\n\n');
msg2 = sprintf('\nSpecify the constants:\n\n');
msg3 = sprintf('\nThe calculation is extremely long.\nSpecify the grain size:\n1-high precision (>1 hour)\n2-fine (around 15 min)\n5-reasonable (<3 min)\n10-preview (<1 min)\n\n');
if ~isfield(handles, 'newton_param')
    handles.newton_param = {'5', '0', '0', '0', '1', '0', '0', '0', '5'};
elseif isempty(handles.newton_param)
    handles.newton_param = {'5', '0', '0', '0', '1', '0', '0', '0', '5'};
end
handles.newton_param = localdlg({[msg 'm:'], 'n:', 'o:', 'p:', [msg2 'a:'], 'b:', 'c:', 'd:', [msg3 'grains:']}, 'Newton''s Method', [1 10], handles.newton_param);
if isempty(handles.newton_param)
    return;
end
for i = 1:length(handles.newton_param)-1
    handles.ctes(i) = str2num(handles.newton_param{i});
    if i < 5
        handles.ctes(i) = round(handles.ctes(i));
    end
end
handles.grain = round(str2num(handles.newton_param{end}));
handles.xmin = -1;
handles.xmax = 1;
handles.ymin = -1;
handles.ymax = 1;
handles.itern = 70;
handles.mode = 4; % newton
handles.newton_equation = '';
for i = 1:4
    if handles.ctes(i+4) ~= 0
        if handles.ctes(i+4) > 0
            handles.newton_equation = [handles.newton_equation '+'];
        end
        handles.newton_equation = [handles.newton_equation num2str(handles.ctes(i+4))];
        if round(handles.ctes(i)) > 1
            handles.newton_equation = [handles.newton_equation '*z^' int2str(handles.ctes(i))];
        elseif round(handles.ctes(i)) == 1
            handles.newton_equation = [handles.newton_equation '*z'];
        end
    end
end
handles.newton_equation = [handles.newton_equation ' = 1'];
% now write the constants in a correct form:
m_pow = max(handles.ctes(1:4));
ktes = zeros(1, m_pow+1);
for i = 1:4
    if handles.ctes(i) > 0
        ktes(m_pow+1-handles.ctes(i)) = handles.ctes(i+4);
    end
    ktes(end) = -1;
end
handles.ctes = ktes;
set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia - makes no sense from newton.
handles = fillupdescription(handles);
handles.space = compute_newton_power(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize/handles.grain, handles.ctes, 1);
handles.main_image = image(handles.space);
axis(handles.main_axis, 'off');
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_others_head_Callback(hObject, eventdata, handles)
% hObject    handle to menu_others_head (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_barnsley_Callback(hObject, eventdata, handles)
% hObject    handle to menu_barnsley (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msg = sprintf('Barnsley''s Tree:\n\nDefine Constant and iterations:\n(p.ex. 0.6+1.1i)\n\n');
tmp = {num2str(handles.xjul), num2str(handles.yjul), num2str(handles.itern)};
tmp = localdlg({[msg 'Constant Real:'], 'Constant Imaginary:', 'Iterations:'}, 'Julia Set', [1 10], tmp);
if isempty(tmp)
    return;
end
handles.xmin = -3;
handles.xmax = 3;
handles.ymin = -2;
handles.ymax = 2;
handles.xjul = str2num(tmp{1});
handles.yjul = str2num(tmp{2});
handles.itern = str2num(tmp{3});
handles.mode = 5; % Barnsley
handles = fillupdescription(handles);
handles.space = compute_barnsley(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
handles.main_image = image(handles.space, 'EraseMode', 'none');
axis(handles.main_axis, 'off');
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_rossler_Callback(hObject, eventdata, handles)
% hObject    handle to menu_rossler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


msg = sprintf('Rossler Attractor:\n\nIterations on the system:\ndx/dt = -(y+z)\ndy/dt = x + ay\ndz/dt = b + xz - cz\n\nSpecify the constants:\n\n');
if ~isfield(handles, 'rossler_params')
    handles.rossler_params = {'0.2', '0.2', '8.0'};
elseif isempty(handles.rossler_params)
    handles.rossler_params = {'0.2', '0.2', '8.0'};
end
handles.rossler_params = localdlg({[msg 'a:'], 'b:', 'c:'}, 'Rossler Attractor', [1 10], handles.rossler_params);
if isempty(handles.rossler_params)
    return;
end
for i = 1:length(handles.rossler_params)
    handles.ctes(i) = str2num(handles.rossler_params{i});
end
handles.mode = -8;
x = 0.1000001;
y = -0.1000001;
z = 1.0000001;
dt = 0.002;
set(handles.fractal_explorer, 'KeyPressFcn', ';');
handles = fillupdescription(handles);
set(handles.txt_help, 'String', sprintf('Press any key to stop.\nUse the mouse to modify the\nobservation angle in 3 dimensions.'));
set(handles.txt_help, 'Visible', 'on');
axes(handles.main_axis);
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end

set(handles.main_axis, 'Drawmode','normal');
plot3(0, 0, 0, 'k.', 'MarkerSize', 1);
set(handles.main_axis, ...
    'XLim',[-20 20],'YLim',[-20 20],'ZLim',[0 40], ...
    'XTick',[],'YTick',[],'ZTick',[], ...
    'Drawmode','fast', ...
    'Visible','on', ...
    'NextPlot','add', ...
    'Color', [0 0 0], ...
    'View',[-80,38]);
xlabel('X');
ylabel('Y');
zlabel('Z');
serie = [x y z; zeros(5999, 3)];
lne_head = line( ...
    'color','r', ...
    'Marker','.', ...
    'markersize',25, ...
    'erase','xor', ...
    'xdata',serie(1),'ydata',serie(2),'zdata',serie(3));
lne_body = line( ...
    'color','y', ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_tail=line( ...
    'color',[0.6 0.6 1], ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_trace=line( ...
    'color',[0.3 0.3 1], ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);
lne_dust=line( ...
    'color',[0 0 0.8], ...
    'LineStyle','-', ...
    'erase','none', ...
    'xdata',[],'ydata',[],'zdata',[]);

rotate3d on;
set(handles.fractal_explorer, 'CurrentCharacter', 'ç');
cchr = get(handles.fractal_explorer, 'CurrentCharacter');
while strcmp(get(handles.fractal_explorer, 'CurrentCharacter'), cchr)
    sx = [];
    sy = [];
    sz = [];
    for i = 1:30
        dx = -(y+z);
        dy = x+handles.ctes(1)*y;
        dz = handles.ctes(2)+x*z-handles.ctes(3)*z;
        x = x + dx*dt;
        y = y + dy*dt;
        z = z + dz*dt;
        if i == 10 | i == 20 | i == 30
            sx = [x sx];
            sy = [y sy];
            sz = [z sz];
        end
    end
    serie = [sx' sy' sz'; serie(1:end-size(sx, 2),:)];
    set(lne_trace,'xdata',serie(500:end-3, 1),'ydata',serie(500:end-3, 2),'zdata',serie(500:end-3, 3));
    set(lne_dust,'xdata',serie(end-3:end, 1),'ydata',serie(end-3:end, 2),'zdata',serie(end-3:end, 3));
    set(lne_tail,'xdata',serie(41:499, 1),'ydata',serie(41:499, 2),'zdata',serie(41:499, 3));
    set(lne_head,'xdata',serie(1,1),'ydata',serie(1, 2),'zdata',serie(1, 3));
    set(lne_body,'xdata',serie(1:40,1),'ydata',serie(1:40,2),'zdata',serie(1:40,3));
    drawnow;
end
hold off;
set(handles.fractal_explorer, 'KeyPressFcn', '');
set(handles.txt_help, 'Visible', 'off');
guidata(hObject, handles);

% --- Executes on button press in button_3D.
function button_3D_Callback(hObject, eventdata, handles)
% hObject    handle to button_3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.button_3D, 'String'), 'Return to 2D')
    % we are in 3D
	set(handles.button_3D, 'String', 'Make It 3D!');
    set(handles.button_zoom, 'Enable', 'on');
    set(handles.button_zoomout, 'Enable', 'on');
% 	switch handles.mode
%         case 1 % mandelbrot
%             handles.space = compute_mandelbrot_real(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize, 1);
%         case 2 % julia
%             handles.space = compute_julia(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
%         case 3 % newton
%             handles.space = compute_newton(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize, 1);
%         case 4 % user newton
%             handles.space = compute_newton_power(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize/handles.grain, handles.ctes, 1);
%         case 5 % barnsley
%             handles.space = compute_barnsley(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
%         case 6 % circu poly
%             if handles.arbitrary_mode == 1
%                 handles.space = compute_circumpoly(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
%             else
%                 handles.space = compute_arbitrary(handles.equation, handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
%             end
%         otherwise
%             warning('CSE:Fractals:Render', 'Unknown Mode');
% 	end
	if isfield(handles, 'main_image')
        try delete(handles.main_image); end
	end
	handles = fillupdescription(handles);
	if handles.mode > 0
        handles.main_image = image(handles.space, 'EraseMode', 'none');
        axis(handles.main_axis, 'off');
	end
else
	set(handles.button_3D, 'String', 'Return to 2D');
    set(handles.button_zoom, 'Enable', 'off');
    set(handles.button_zoomout, 'Enable', 'off');
	scaling = 0.5;
    space = handles.space(2:2:end, 2:2:end);
    space(space == handles.itern*scaling) = 0;
% %     xlin = linspace(1,800,33);
% %     [X,Y] = meshgrid(xlin,xlin);
% %     space = griddata(1:800,1:800,space,X,Y,'cubic');
% 	switch handles.mode
%         case 1 % mandelbrot
%             space = compute_mandelbrot_real(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern*scaling, 302, 1);
%         case 2 % julia
%             space = compute_julia(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern*scaling, 302, 1);
%         case 3 % newton
%             space = compute_newton(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern*scaling, 302, 1);
%         case 4 % user newton
%             space = compute_newton_power(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern*scaling, 80, handles.ctes, 1);
%         case 5 % barnsley
%             space = compute_barnsley(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern*scaling, 302, 1);
%         case 6 % circu poly
%             if handles.arbitrary_mode == 1
%                 space = compute_circumpoly(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern*scaling, 302, 1);
%             else
%                 space = compute_arbitrary(handles.equation, handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern*scaling, 302, 1);
%             end
%         otherwise
%             warning('CSE:Fractals:Render', 'Unknown Mode');
% 	end
	space = space/max(max(space));
	space(find(space==0))=1;
	space = space*.3;
	space = log2(space);
	% let's smooth the surface a bit...
	for i = 2:size(space, 1)-1
        for j = 2:size(space, 1)-1
            space(i, j) = 0.8*space(i, j) + 0.1*space(i-1, j) + 0.1*space(i+1, j) + 0.1*space(i, j+1) + 0.1*space(i, j-1);
        end
	end
	axes(handles.main_axis);
	surf(space(2:end-1, 2:end-1));
	view([-16 76]); 
	axis vis3d auto;
	set(gcf, 'Renderer', 'OpenGL');
	%set(handles.main_axis, 'ZLim', [0 1]);
	camlight;
	shading interp;
	lighting phong;
	rotate3d on;
	%handles.main_image = image(handles.space, 'EraseMode', 'none');
	axis(handles.main_axis, 'off');
end
    
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_circu_poly_Callback(hObject, eventdata, handles)
% hObject    handle to menu_circu_poly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.txtdescr = {'Circumscribed Polygon', 'z = 2*z*z0*tan(pi/z)'};
handles.arbitrary_mode = 1;
msg = sprintf('Circumscribed Polygon:\n\nDefine Constant and iterations:\n(leave julia set to 0+0i to compute\nthe Mandelbrot Set.)\n\n');
if ~isfield(handles, 'params_circum')
    handles.params_circum = {num2str(0), num2str(0), num2str(20)};
end
if isempty(handles.params_circum)
    handles.params_circum = {num2str(0), num2str(0), num2str(20)};
end
handles.params_circum = localdlg({[msg 'Constant Real:'], 'Constant Imaginary:', 'Iterations:'}, 'Circumscribed Polygon', [1 10], handles.params_circum);
if isempty(handles.params_circum)
    return;
end
handles.grain = 1;
handles.xmin = -1.5;
handles.xmax = 1.5;
handles.ymin = -1.5;
handles.ymax = 1.5;
handles.xjul = str2num(handles.params_circum{1});
handles.yjul = str2num(handles.params_circum{2});
handles.itern = str2num(handles.params_circum{3});
handles.mode = 6; % Circumscribed Polygon
handles = fillupdescription(handles);
warning off MATLAB:divideByZero
handles.space = compute_circumpoly(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
warning on MATLAB:divideByZero
handles.main_image = image(handles.space, 'EraseMode', 'none');
axis(handles.main_axis, 'off');
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_arbitrary_Callback(hObject, eventdata, handles)
% hObject    handle to menu_arbitrary (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


msg = sprintf(['Arbitrary Complex Map:\n\nEnter the equation in the form:\n"z*z+z0", or "sin(z/z0)+3*z".\nThe current complex number z MUST\n' ...'
        'appear first. A second input (e.g. z0)\nmust appear LATER.\n\n']);
msg2 = sprintf('\nSpecify the julia constant:\nSet to 0+0i for Mandelbrot Set.\n\n');
msg3 = sprintf('\nSpecify the boundaries and\nmaximum iterations:\n\n');
msg4 = sprintf('\nThe calculation can be extremely long.\nSpecify the grain size:\n1-high precision\n5-reasonable\n10-preview\n\n');
if ~isfield(handles, 'arb_mandel_param')
    handles.arb_mandel_param = {'tanh(z*z)-z0', '0', '0', '-1.5', '1.5', '-1.5', '1.5', '20', '5'};
elseif isempty(handles.arb_mandel_param)
    handles.arb_mandel_param = {'tanh(z*z)-z0', '0', '0', '-1.5', '1.5', '-1.5', '1.5', '20', '5'};
end
handles.arb_mandel_param = localdlg({[msg 'Equation:'], [msg2 'Xjul:'], 'Yjul:', [msg3 'Xmin:'], 'Xmax:', 'Ymin:', 'Ymax:', 'Iterations:', ...
            [msg4 'Grain:']}, 'Arbitrary Complex Map', [1 20], handles.arb_mandel_param);
if isempty(handles.arb_mandel_param)
    return;
end
handles.equation = handles.arb_mandel_param{1};
handles.xjul = str2num(handles.arb_mandel_param{2});
handles.yjul = str2num(handles.arb_mandel_param{3});
handles.xmin = str2num(handles.arb_mandel_param{4});
handles.xmax = str2num(handles.arb_mandel_param{5});
handles.ymin = str2num(handles.arb_mandel_param{6});
handles.ymax = str2num(handles.arb_mandel_param{7});
handles.itern = round(str2num(handles.arb_mandel_param{8}));
handles.grain = round(str2num(handles.arb_mandel_param{9}));
handles.arbitrary_mode = 0;
handles.txtdescr = {'Arbitrary Complex Map' handles.equation};
handles.xmin = -1.5;
handles.xmax = 1.5;
handles.ymin = -1.5;
handles.ymax = 1.5;
handles.mode = 6; % Arbitrary Mandelbrot
handles = fillupdescription(handles);
handles.space = compute_arbitrary(handles.equation, handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, 10, handles.gridsize/5, 1);
handles.main_image = image(handles.space, 'EraseMode', 'none');
axis(handles.main_axis, 'off');
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_head_comput_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_comput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_change_iterations_Callback(hObject, eventdata, handles)
% hObject    handle to menu_change_iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%disp(sprintf('%20.10f%20.10fi:%20.10f%20.10fi', handles.xmin, handles.xmax, handles.ymin, handles.ymax));
msg = sprintf('Define Maximum Iterations:\n\n');
tmp = {num2str(handles.itern)};
tmp = localdlg({[msg 'Iterations:']}, 'Maximum Iterations', [1 10], tmp);
if isempty(tmp)
    return;
end
handles.itern = str2num(tmp{1});
switch handles.mode
    case 1 % mandelbrot
        handles.space = compute_mandelbrot_real(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize, 1);
    case 2 % julia
        handles.space = compute_julia(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
    case 3 % newton
        handles.space = compute_newton(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize/handles.grain, 1);
    case 4 % user newton
        handles.space = compute_newton_power(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize/handles.grain, handles.ctes, 1);
    case 5 % barnsley
        handles.space = compute_barnsley(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize, 1);
    case 6 % circu poly
        if handles.arbitrary_mode == 1
            handles.space = compute_circumpoly(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize/handles.grain, 1);
        else
            handles.space = compute_arbitrary(handles.equation, handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize/handles.grain, 1);
        end
    otherwise
        warning('CSE:Fractals:Render', 'Unknown Mode');
end
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end
handles = fillupdescription(handles);
if handles.mode > 0
    handles.main_image = image(handles.space, 'EraseMode', 'none');
    axis(handles.main_axis, 'off');
end
% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_change_grain_Callback(hObject, eventdata, handles)
% hObject    handle to menu_change_grain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


msg = sprintf('Define Grain Size:\n1-high precision\n5-reasonable\n10-preview\n\n');
tmp = {num2str(handles.grain)};
tmp = localdlg({[msg 'Grain:']}, 'Precision', [1 10], tmp);
if isempty(tmp)
    return;
end
handles.grain = str2num(tmp{1});
switch handles.mode
    case 4 % user newton
        handles.space = compute_newton_power(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.itern, handles.gridsize/handles.grain, handles.ctes, 1);
    case 6 % circu poly
        if handles.arbitrary_mode == 1
            handles.space = compute_circumpoly(handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize/handles.grain, 1);
        else
            handles.space = compute_arbitrary(handles.equation, handles.xmin, handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern, handles.gridsize/handles.grain, 1);
        end
    otherwise
        ;
end
if isfield(handles, 'main_image')
    try delete(handles.main_image); end
end
handles = fillupdescription(handles);
if handles.mode > 0
    handles.main_image = image(handles.space, 'EraseMode', 'none');
    axis(handles.main_axis, 'off');
end
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_head_quaternion_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_quaternion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_quaternion_Callback(hObject, eventdata, handles)
% hObject    handle to menu_quaternion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


msg = sprintf('Quaternion Definition:\n\nDefine the Julia constant;\nset to 0+0i+0j+0k to draw the\nMandelbrot Set.\n\n');
if ~isfield(handles, 'quaternion_params')
    handles.quaternion_params = {'0.5', '0.4', '1', '0.05', '0.5', '6', '100'};
elseif isempty(handles.quaternion_params)
    handles.quaternion_params = {'0.5', '0.4', '1', '0.05', '0.5', '6', '100'};
end
handles.quaternion_params = localdlg({[msg 'Xjul:'], 'Yjul:', 'Zjul:', 'Tjul:', sprintf('Set constant time:\n\nTime:'), ...
        sprintf('Number of Iterations:\n\nMax Iter:'), sprintf('Definition (number of points)\n200 is the limit for a reasonable\ncomputation time:\n\nDefinition:')}, ...
        'Quaternion Definition', [1 10], handles.quaternion_params);
if isempty(handles.quaternion_params)
    return;
end
handles.mode = -12; % mandelbrot
handles = fillupdescription(handles);
set(gcf, 'Renderer', 'OpenGL');
set(handles.main_axis, 'Drawmode','normal');
plot3(0, 0, 0, 'k.', 'MarkerSize', 1);
set(handles.main_axis, ...
    'XLim',[-1.33 1.33],'YLim',[-1.33 1.33],'ZLim',[-1.7 1.7], ...
    'XTick',[],'YTick',[],'ZTick',[], ...
    'Visible','on', ...
    'Color', [0 0 0], ...
    'View',[-50 30]); % [-49,16]

waithdl = waitbar(0, 'Quaternion Generation...');
jul_cte = [str2num(handles.quaternion_params{1}) str2num(handles.quaternion_params{2}) str2num(handles.quaternion_params{3}) str2num(handles.quaternion_params{4})];
space = compute_quaternion(-1.33, 1.33, -1.33, 1.33, -1.33, 1.33, str2num(handles.quaternion_params{5}), str2num(handles.quaternion_params{6}), ...
    jul_cte, str2num(handles.quaternion_params{7}), waithdl);
waitbar(1/4, waithdl, 'Smoothing...');
space = smooth3(space.*10,'box',3);
waitbar(3/4, waithdl, 'Patching...');
axes(handles.main_axis);
p1 = patch(isosurface(space,.8), ...
'FaceColor','blue','EdgeColor','none');
% isonormals(space,p1);
waitbar(3.5/4, waithdl, 'Rendering...');
view([-50 30]); axis vis3d tight
camlight headlight; lighting phong;
axis off;
rotate3d on;
close(waithdl);
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_copy_Callback(hObject, eventdata, handles)
% hObject    handle to menu_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.fractal_explorer,'InvertHardcopy','off')
set(handles.fractal_explorer,'PaperPositionMode','auto')
print(handles.fractal_explorer, '-dbitmap', '-opengl');


% --------------------------------------------------------------------
function menu_3D_linden_Callback(hObject, eventdata, handles)
% hObject    handle to menu_3D_linden (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ctes = {'TF' 'f' 'FF---[*Xl]---[*FYL]---[*Xl]' 'FF--[**FYL]--[**XL]--[**FYl]--[**YL]' '0.1745' '0.2618' 'BX' '5';
    'FTF' 'f' '+[*FXl]+[**Y]+[*FXl]' 'F+[/FL]+[/FP]+[/FL]' '2.0944' '0.2' 'BFX' '7';
    'FFTX' 'f' '+[*YLF]+[*XlF]+[*F*YX]' 'T-[/FPX]--[/XFl]' '0' '0' 'BBFTF' '5';
    'FFX' 'f' '+[*F]+++*FFY' '**F' '1.5708' '1.5708' 'F' '7';
    'FTYFTX' 'f' '+[*FXFl]+[**Y]+[*FXl]' 'F+[/F]+[/FP]+[/FFL]' '2.0944' '0.35' 'BBFX' '5';
    'FYFX' 'f' '+[**FXTFl]+T[*Y]+[**FXl]' 'F+[/F]+[*Fl]+[FFL]' '2.0944' '0.41' 'BBFX' '5';
    'TFTFX' 'f' '----[**FL][/XP]----[/FL][**X]----[**FP][**Fl]' 'FX' '0.1745' '0.2618' 'BY' '6'};
msg = sprintf(['Multiple Rules 3D Lindenmayer Systems:\n\nGrammar:\nF: Draw Line;f: Forward (no draw)\n+,-: change x-angle; *,/: change z-angle\n[,]:' ...
    'Push and pull stack (memory)\nX,Y: Do nothing\n\nTree Goodies:\nB: Broad trunc; T: Slim trunc\nL,l: Big/small leaf; P: Fruit.\n\n']);
if ~isfield(handles, 'tree_3D_params')
    handles.tree_3D_params = {ctes{unidrnd(size(ctes, 1)), :}};
elseif isempty(handles.tree_3D_params)
    handles.tree_3D_params = {ctes(unidrnd(size(ctes, 1)), :)};
end
handles.tree_3D_params = localdlg({[msg 'F->'], 'f->', 'X->', 'Y->', 'Alpha:', 'Beta:', 'Intial String:', 'Iterations:'}, 'Lindenmayer Systems', ...
    [1 25], handles.tree_3D_params, ...
    ['usrdta = get(gcbf, ''UserData''); z = unidrnd(size(usrdta.Data, 1)); for i=1:length(usrdta.EditHandles), '...
        'set(usrdta.EditHandles(i), ''String'', usrdta.Data{z,i}); end;'], 'Examples', ctes);
if isempty(handles.tree_3D_params)
    return;
end
unit = 1;
unit_factor = 1/4;
rules(1).code = 'F';
rules(1).replace = handles.tree_3D_params{1};
rules(2).code = 'f';
rules(2).replace = handles.tree_3D_params{2};
rules(3).code = 'X';
rules(3).replace = handles.tree_3D_params{3};
rules(4).code = 'Y';
rules(4).replace = handles.tree_3D_params{4};
alpha = str2num(handles.tree_3D_params{5});
beta = str2num(handles.tree_3D_params{6});
lin_string = handles.tree_3D_params{7};
m_iter = round(str2num(handles.tree_3D_params{8}));
handles.mode = -10;

handles.lindenrules = '';
for i = 1:length(rules)
    handles.lindenrules = [handles.lindenrules rules(i).code '->' rules(i).replace '\n'];
end
graphic_rules(1).code = 'F';
graphic_rules(1).type = 0;
graphic_rules(1).style = 'y-';
graphic_rules(2).code = '+';
graphic_rules(2).type = 2;
graphic_rules(2).value = -alpha;
graphic_rules(3).code = '-';
graphic_rules(3).type = 2;
graphic_rules(3).value = alpha;
graphic_rules(4).code = 'f';
graphic_rules(4).type = 1;
graphic_rules(5).code = 'X';
graphic_rules(5).type = -1;
graphic_rules(6).code = 'Y';
graphic_rules(6).type = -1;
graphic_rules(7).code = 'L';
graphic_rules(7).type = 3;
graphic_rules(7).style = 'gd';
graphic_rules(7).value = 10;
graphic_rules(8).code = 'P';
graphic_rules(8).type = 3;
graphic_rules(8).style = 'ro';
graphic_rules(8).value = 6;
graphic_rules(9).code = '[';
graphic_rules(9).type = 4;
graphic_rules(10).code = ']';
graphic_rules(10).type = 5;
graphic_rules(11).code = 'B';
graphic_rules(11).type = 6;
graphic_rules(11).value = 3;
graphic_rules(12).code = 'T';
graphic_rules(12).type = 7;
graphic_rules(12).value = 0.9;
graphic_rules(13).code = 'l';
graphic_rules(13).type = 3;
graphic_rules(13).style = 'gd';
graphic_rules(13).value = 6;
graphic_rules(14).code = '*';
graphic_rules(14).type = 8;
graphic_rules(14).value = beta;
graphic_rules(15).code = '/';
graphic_rules(15).type = 8;
graphic_rules(15).value = -beta;
handles = fillupdescription(handles);
set(gcf,'Pointer','watch');
axes(handles.main_axis);
for i = 1:m_iter
   [lin_string, overflow] = expand_string(lin_string, rules);
   if overflow
       set(gcf,'Pointer','arrow');
       uiwait(msgbox('Overflow: String too long.', 'CSE Error'));
       break;
   else
       unit = unit * unit_factor;
       handles = interpret_3D_string(handles, lin_string, graphic_rules, unit);
       rotate3d on;
   end
   drawnow;
end
set(gcf,'Pointer','arrow');
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_head_others_Callback(hObject, eventdata, handles)
% hObject    handle to menu_head_others (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_clouds_Callback(hObject, eventdata, handles)
% hObject    handle to menu_clouds (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msg = sprintf('Fractal Clouds:\n\n');
if ~isfield(handles, 'clouds_params')
    handles.clouds_params = {'8', '100', '100'};
elseif isempty(handles.clouds_params)
    handles.clouds_params = {'8', '100', '100'};
end
handles.clouds_params = localdlg({[msg 'Max Iterations:'], 'Perturbation:', 'Initial Amplitude:'}, 'Fractal Clouds', [1 10], handles.clouds_params);
if isempty(handles.clouds_params)
    return;
end
handles.mode = -13;
if  round(str2num(handles.clouds_params{1})) > 10
    uiwait(errordlg(sprintf(['The maximum number of iteration is 10. It is advised to remain below 10 for reasonable computation times.' ...
            '\n\nIterations have been set to 9.\n']), 'Error', 'modal'));
    handles.clouds_params{1} = '9';
end
handles = fillupdescription(handles);
iter = round(str2num(handles.clouds_params{1}));
perturbation = str2num(handles.clouds_params{2});
space =unifrnd(-1*str2num(handles.clouds_params{3}),str2num(handles.clouds_params{3}),2,2);
wb = waitbar(0, 'Computing...');
cnt = 0;
tot_cnt = 2^iter-1;
for i = 1:iter
    for j = 1:length(space)-1
        waitbar(cnt/tot_cnt, wb);
        cnt = cnt + 1;
        for k = 1:length(space)-1
            space2(2*j-1, 2*k-1)= space(j, k);
            space2(2*j-1, 2*(k+1)-1) = space(j, k+1);
            space2(2*(j+1)-1, 2*k-1) = space(j+1, k);
            space2(2*(j+1)-1, 2*(k+1)-1) = space(j+1, k+1);
            % center
            space2(2*j, 2*k) = sum(sum(space(j:j+1, k:k+1)))/4+normrnd(0, 1)*perturbation;
            % sides
            space2(2*j, 2*k-1) = sum(space(j:j+1, k))/2+normrnd(0, 1)*perturbation;
            space2(2*j, 2*(k+1)-1) = sum(space(j:j+1, k+1))/2+normrnd(0, 1)*perturbation;
            space2(2*j-1, 2*k) = sum(space(j, k:k+1))/2+normrnd(0, 1)*perturbation;
            space2(2*(j+1)-1, 2*k) = sum(space(j+1, k:k+1))/2+normrnd(0, 1)*perturbation;
        end
    end
    space = space2;
    perturbation = perturbation / 2;
    %disp(sprintf('Iter: %d, evals %d', i, cnt));
end
close(wb);
space(find(space<0))=0;
axes(handles.main_axis);
handles.main_image = image(space, 'EraseMode', 'none');
%surf(space);
mapp = [0.2039    0.6353    0.9882
    0.2735    0.6603    0.9706
    0.3431    0.6853    0.9529
    0.4127    0.7103    0.9353
    0.4824    0.7353    0.9176
    0.5520    0.7603    0.9000
    0.6216    0.7853    0.8824
    0.6912    0.8103    0.8647
    0.7608    0.8353    0.8471
    0.7694    0.8402    0.8514
    0.7780    0.8451    0.8557
    0.7867    0.8500    0.8600
    0.7953    0.8549    0.8643
    0.8039    0.8598    0.8686
    0.8125    0.8647    0.8729
    0.8212    0.8696    0.8773
    0.8298    0.8745    0.8816
    0.8384    0.8794    0.8859
    0.8471    0.8843    0.8902
    0.8557    0.8892    0.8945
    0.8643    0.8941    0.8988
    0.8729    0.8990    0.9031
    0.8816    0.9039    0.9075
    0.8902    0.9088    0.9118
    0.8988    0.9137    0.9161
    0.9075    0.9186    0.9204
    0.9161    0.9235    0.9247
    0.9247    0.9284    0.9290
    0.9333    0.9333    0.9333
    0.9352    0.9352    0.9352
    0.9371    0.9371    0.9371
    0.9390    0.9390    0.9390
    0.9410    0.9410    0.9410
    0.9429    0.9429    0.9429
    0.9448    0.9448    0.9448
    0.9467    0.9467    0.9467
    0.9486    0.9486    0.9486
    0.9505    0.9505    0.9505
    0.9524    0.9524    0.9524
    0.9543    0.9543    0.9543
    0.9562    0.9562    0.9562
    0.9581    0.9581    0.9581
    0.9600    0.9600    0.9600
    0.9619    0.9619    0.9619
    0.9638    0.9638    0.9638
    0.9657    0.9657    0.9657
    0.9676    0.9676    0.9676
    0.9695    0.9695    0.9695
    0.9714    0.9714    0.9714
    0.9733    0.9733    0.9733
    0.9752    0.9752    0.9752
    0.9771    0.9771    0.9771
    0.9790    0.9790    0.9790
    0.9810    0.9810    0.9810
    0.9829    0.9829    0.9829
    0.9848    0.9848    0.9848
    0.9867    0.9867    0.9867
    0.9886    0.9886    0.9886
    0.9905    0.9905    0.9905
    0.9924    0.9924    0.9924
    0.9943    0.9943    0.9943
    0.9962    0.9962    0.9962
    0.9981    0.9981    0.9981
    1.0000    1.0000    1.0000];
set(handles.fractal_explorer, 'Colormap', mapp);
axis off;
guidata(hObject, handles);

% --------------------------------------------------------------------
function menu_landscape_Callback(hObject, eventdata, handles)
% hObject    handle to menu_landscape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


msg = sprintf('Fractal Landscapes:\n\n');
if ~isfield(handles, 'lanscapes_params')
    handles.lanscapes_params = {'7', '100', '100'};
elseif isempty(handles.lanscapes_params)
    handles.lanscapes_params = {'7', '100', '100'};
end
handles.lanscapes_params = localdlg({[msg 'Max Iterations:'], 'Perturbation:', 'Initial Amplitude:'}, 'Fractal Lanscapes', [1 10], handles.lanscapes_params);
if isempty(handles.lanscapes_params)
    return;
end
handles.mode = -14;
if  round(str2num(handles.lanscapes_params{1})) > 10
    uiwait(errordlg(sprintf(['The maximum number of iteration is 10. It is advised to remain below 10 for reasonable computation times.' ...
            '\n\nIterations have been set to 9.\n']), 'Error', 'modal'));
    handles.lanscapes_params{1} = '9';
end
handles = fillupdescription(handles);
iter = round(str2num(handles.lanscapes_params{1}));
perturbation = str2num(handles.lanscapes_params{2});
space =unifrnd(-1*str2num(handles.lanscapes_params{3}),str2num(handles.lanscapes_params{3}),2,2);
wb = waitbar(0, 'Computing...');
cnt = 0;
tot_cnt = 2^iter-1;
for i = 1:iter
    for j = 1:length(space)-1
        waitbar(cnt/tot_cnt, wb);
        cnt = cnt + 1;
        for k = 1:length(space)-1
            space2(2*j-1, 2*k-1)= space(j, k);
            space2(2*j-1, 2*(k+1)-1) = space(j, k+1);
            space2(2*(j+1)-1, 2*k-1) = space(j+1, k);
            space2(2*(j+1)-1, 2*(k+1)-1) = space(j+1, k+1);
            % center
            space2(2*j, 2*k) = sum(sum(space(j:j+1, k:k+1)))/4+normrnd(0, 1)*perturbation;
            % sides
            space2(2*j, 2*k-1) = sum(space(j:j+1, k))/2+normrnd(0, 1)*perturbation;
            space2(2*j, 2*(k+1)-1) = sum(space(j:j+1, k+1))/2+normrnd(0, 1)*perturbation;
            space2(2*j-1, 2*k) = sum(space(j, k:k+1))/2+normrnd(0, 1)*perturbation;
            space2(2*(j+1)-1, 2*k) = sum(space(j+1, k:k+1))/2+normrnd(0, 1)*perturbation;
        end
    end
    space = space2;
    perturbation = perturbation / 2;
    %disp(sprintf('Iter: %d, evals %d', i, cnt));
end
close(wb);
space(find(space<0))=0;
axes(handles.main_axis);
set(handles.fractal_explorer, 'Renderer', 'OpenGL');
surf(space);
mapp = [0         0    0.5
    1.0000    1.0000    0.5020
    0.9289    1.0000    0.5020
    0.8577    1.0000    0.5020
    0.7866    1.0000    0.5020
    0.7154    1.0000    0.5020
    0.6443    1.0000    0.5020
    0.5731    1.0000    0.5020
    0.5020    1.0000    0.5020
    0.4724    0.9707    0.4724
    0.4429    0.9414    0.4429
    0.4134    0.9121    0.4134
    0.3839    0.8828    0.3839
    0.3543    0.8535    0.3543
    0.3248    0.8242    0.3248
    0.2953    0.7949    0.2953
    0.2657    0.7656    0.2657
    0.2362    0.7363    0.2362
    0.2067    0.7070    0.2067
    0.1772    0.6777    0.1772
    0.1476    0.6484    0.1476
    0.1181    0.6191    0.1181
    0.0886    0.5899    0.0886
    0.0591    0.5606    0.0591
    0.0295    0.5313    0.0295
         0    0.5020         0
    0.0251    0.5020    0.0251
    0.0502    0.5020    0.0502
    0.0753    0.5020    0.0753
    0.1004    0.5020    0.1004
    0.1255    0.5020    0.1255
    0.1506    0.5020    0.1506
    0.1757    0.5020    0.1757
    0.2008    0.5020    0.2008
    0.2259    0.5020    0.2259
    0.2510    0.5020    0.2510
    0.2761    0.5020    0.2761
    0.3012    0.5020    0.3012
    0.3263    0.5020    0.3263
    0.3514    0.5020    0.3514
    0.3765    0.5020    0.3765
    0.4016    0.5020    0.4016
    0.4267    0.5020    0.4267
    0.4518    0.5020    0.4518
    0.4769    0.5020    0.4769
    0.5020    0.5020    0.5020
    0.5296    0.5296    0.5296
    0.5573    0.5573    0.5573
    0.5850    0.5850    0.5850
    0.6126    0.6126    0.6126
    0.6403    0.6403    0.6403
    0.6680    0.6680    0.6680
    0.6956    0.6956    0.6956
    0.7233    0.7233    0.7233
    0.7510    0.7510    0.7510
    0.7786    0.7786    0.7786
    0.8063    0.8063    0.8063
    0.8340    0.8340    0.8340
    0.8617    0.8617    0.8617
    0.8893    0.8893    0.8893
    0.9170    0.9170    0.9170
    0.9447    0.9447    0.9447
    0.9723    0.9723    0.9723
    1.0000    1.0000    1.0000];
set(handles.fractal_explorer, 'Colormap', mapp);
axis off;
view([-24 58]);
shading interp;
lighting phong;
camlight right;
material dull;
rotate3d on;
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_plane_Callback(hObject, eventdata, handles)
% hObject    handle to menu_plane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msg = sprintf('Fractal Landscapes:\n\n');
if ~isfield(handles, 'plane_params')
    handles.plane_params = {'7', '100', '100'};
elseif isempty(handles.plane_params)
    handles.plane_params = {'7', '100', '100'};
end
handles.plane_params = localdlg({[msg 'Max Iterations:'], 'Perturbation:', 'Initial Amplitude:'}, 'Fractal Lanscapes', [1 10], handles.plane_params);
if isempty(handles.plane_params)
    return;
end
handles.mode = -15;
if  round(str2num(handles.plane_params{1})) > 10
    uiwait(errordlg(sprintf(['The maximum number of iteration is 10. It is advised to remain below 10 for reasonable computation times.' ...
            '\n\nIterations have been set to 9.\n']), 'Error', 'modal'));
    handles.plane_params{1} = '9';
end
handles = fillupdescription(handles);
iter = round(str2num(handles.plane_params{1}));
perturbation = str2num(handles.plane_params{2});
space =unifrnd(-1*str2num(handles.plane_params{3}),str2num(handles.plane_params{3}),2,2);
wb = waitbar(0, 'Computing...');
cnt = 0;
tot_cnt = 2^iter-1;
for i = 1:iter
    for j = 1:length(space)-1
        waitbar(cnt/tot_cnt, wb);
        cnt = cnt + 1;
        for k = 1:length(space)-1
            space2(2*j-1, 2*k-1)= space(j, k);
            space2(2*j-1, 2*(k+1)-1) = space(j, k+1);
            space2(2*(j+1)-1, 2*k-1) = space(j+1, k);
            space2(2*(j+1)-1, 2*(k+1)-1) = space(j+1, k+1);
            % center
            space2(2*j, 2*k) = sum(sum(space(j:j+1, k:k+1)))/4+normrnd(0, 1)*perturbation;
            % sides
            space2(2*j, 2*k-1) = sum(space(j:j+1, k))/2+normrnd(0, 1)*perturbation;
            space2(2*j, 2*(k+1)-1) = sum(space(j:j+1, k+1))/2+normrnd(0, 1)*perturbation;
            space2(2*j-1, 2*k) = sum(space(j, k:k+1))/2+normrnd(0, 1)*perturbation;
            space2(2*(j+1)-1, 2*k) = sum(space(j+1, k:k+1))/2+normrnd(0, 1)*perturbation;
        end
    end
    space = space2;
    perturbation = perturbation / 2;
    %disp(sprintf('Iter: %d, evals %d', i, cnt));
end
close(wb);
%space(find(space<0))=0;
axes(handles.main_axis);
h = mesh(space); %surf
mapp = colormap('bone');
set(handles.fractal_explorer, 'ColorMap', mapp);
set(h, 'CData', repmat(0, size(space)));
axis off;
view([-24 58]);
% shading interp;
% lighting flat;
% camlight right;
% material dull;
rotate3d on;
guidata(hObject, handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = managecolorticks(handles);

chldr = get(handles.menu_head_colors, 'Children');
for i = 1:length(chldr)
    set(chldr, 'Checked', 'off');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = fillupdescription(handles)

try 
    hdls = get(handles.main_axis, 'Children');
    for i = 1:length(hdls)
        if strcmp(get(hdls(i), 'Type'), 'patch')
            delete(hdls(i));
        end
    end
end
set(handles.menu_change_grain, 'Enable', 'off');
set(gcf, 'Renderer', 'painters');
if handles.mode < -1
    set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia
    set(handles.menu_head_colors, 'Enable', 'off'); % disable color selection
    set(handles.menu_head_colorshift, 'Enable', 'off'); % disable colorshift
    set(handles.button_zoom, 'Enable', 'off');
    set(handles.button_zoomout, 'Enable', 'off');
    set(handles.menu_head_image, 'Enable', 'off');
    set(handles.button_3D, 'Visible', 'off');
    set(handles.menu_change_iterations, 'Enable', 'off');
else
    set(handles.menu_head_colors, 'Enable', 'on'); % enable color selection
    set(handles.menu_head_colorshift, 'Enable', 'on'); % enable colorshift
	set(handles.button_zoom, 'Enable', 'on');
	set(handles.button_zoomout, 'Enable', 'on');
    set(handles.menu_head_image, 'Enable', 'on');
	set(handles.button_3D, 'String', 'Make It 3D!');
    if handles.mode > 0
        set(handles.button_3D, 'Visible', 'on');
        set(handles.menu_julia_mouse, 'Enable', 'on'); % enable julia
        set(handles.menu_change_iterations, 'Enable', 'on');
    else
        set(handles.button_3D, 'Visible', 'off');
        set(handles.menu_julia_mouse, 'Enable', 'off'); % enable julia
        set(handles.menu_change_iterations, 'Enable', 'off');
    end
end
handles.itern = round(handles.itern);
switch handles.mode
    case -15 % folded plane
        set(handles.txt_descr_1, 'String', 'Folded Plan');
        txt2 = sprintf('Iterations: %d.\nPerturbation: %1.5f.\nAmplitude: %1.5f.', str2num(handles.plane_params{1}), ...
            str2num(handles.plane_params{2}), str2num(handles.plane_params{3}));
        txt3 = '';
    case -14 % fractal landscape
        set(handles.txt_descr_1, 'String', 'Fractal Landscape');
        txt2 = sprintf('Iterations: %d.\nPerturbation: %1.5f.\nAmplitude: %1.5f.', str2num(handles.lanscapes_params{1}), ...
            str2num(handles.lanscapes_params{2}), str2num(handles.lanscapes_params{3}));
        txt3 = '';
    case -13 % fractal clouds
        set(handles.txt_descr_1, 'String', 'Fractal Clouds');
        txt2 = sprintf('Iterations: %d.\nPerturbation: %1.5f.\nAmplitude: %1.5f.', str2num(handles.clouds_params{1}), ...
            str2num(handles.clouds_params{2}), str2num(handles.clouds_params{3}));
        txt3 = '';
    case -12 % Quatrenion
        set(handles.txt_descr_1, 'String', 'Quaternion');
        txt2 = sprintf('Julia Constant:\nx: %1.5f; y: %1.5f;\nz: %1.5f; t: %1.5f;', str2num(handles.quaternion_params{1}), ...
            str2num(handles.quaternion_params{2}), str2num(handles.quaternion_params{3}), str2num(handles.quaternion_params{4}));
        txt3 = sprintf('Constant Time: %1.5f.', str2num(handles.quaternion_params{5}));
    case -11 % Menger Sponge
        set(handles.txt_descr_1, 'String', 'Menger Sponge');
        txt2 = '';
        txt3 = '';
    case -10 % Lindenmayer string system
        set(handles.txt_descr_1, 'String', 'Lindenmayer System');
        txt2 = sprintf(handles.lindenrules);
        txt3 = sprintf('F: draw line; f: forward (no draw)\n+/-: change angle; X,Y: do nothing\n[: push stack; ]: pull stack\nB,T,L,l,P: Tree goodies...');
    case -9 % fern
        set(handles.txt_descr_1, 'String', 'Barbsley''s Fern');
        txt2 = sprintf('f1(x)= 0.85x+0.04y\nf1(y)= -0.04x+0.85y+1.6\nf2(x)= -0.15x+0.28y\nf2(y)= 0.26x+0.24y+0.44');
        txt3 = sprintf('f3(x)= 0.2x-0.26y\nf3(y)= 0.23x+0.22y+1.6\nf4(x)= 0\nf4(y)= 0.16y');
    case -8 % Rossler
        set(handles.txt_descr_1, 'String', 'Rossler Attractor');
        txt2 = sprintf('Iterations on the equation:\ndx/dt = -(y+z)\ndy/dt = x + ay\ndz/dt = b + xz - cz');
        txt3 = sprintf('a: %1.5f;\nb: %1.5f;\nc: %1.5f;', handles.ctes(1), handles.ctes(2), handles.ctes(3));
    case -7 % Rabinovich
        set(handles.txt_descr_1, 'String', 'Rabinovich');
        txt2 = sprintf('Iterations on the equation:\nx = y-a-b*x^2\ny = c*x');
        txt3 = sprintf('a: %1.5f;\nb: %1.5f;', handles.ctes(1), handles.ctes(2));
    case -6 % 3D limited map
        set(handles.txt_descr_1, 'String', 'Iterated 3D Map');
        txt2 = sprintf('Iterations on the equation:\nx = a + b*x+c*x^2+d*x*y+e*y+f*y^2\ny = x\nz = y');
        txt3 = sprintf('a: %1.4f; b: %1.4f; c: %1.4f;\nd: %1.4f; e: %1.4f; f: %1.4f;', ...
            handles.ctes(1), handles.ctes(2), handles.ctes(3), handles.ctes(4), handles.ctes(5), handles.ctes(6));
    case -5 % generic quadratic map
        set(handles.txt_descr_1, 'String', 'Quadratic Map');
        txt2 = sprintf('Iterations on the equation:\nx = a + b*x+c*x^2+d*x*y+e*y+f*y^2\ny = g + h*x+i*x^2+j*x*y+k*y+l*y^2');
        txt3 = sprintf('a: %1.4f; b: %1.4f; c: %1.4f;\nd: %1.4f; e: %1.4f; f: %1.4f;\ng: %1.4f; h: %1.4f; i: %1.4f;\nj: %1.4f; k: %1.4f; l: %1.4f;', ...
            handles.ctes(1), handles.ctes(2), handles.ctes(3), handles.ctes(4), handles.ctes(5), handles.ctes(6), handles.ctes(7), handles.ctes(8), ...
            handles.ctes(9), handles.ctes(10), handles.ctes(11), handles.ctes(12));
    case -4 % pickover
        set(handles.txt_descr_1, 'String', 'Pickover Dynamic System');
        txt2 = sprintf('Iterations on the equation:\nx = sin(b*y)+c*sin/b*x)\ny = sin(a*x)+d*sin(a*y)');
        txt3 = sprintf('a: %1.5f; b: %1.5f;\nc: %1.5f; d: %1.5f', handles.ctes(1), handles.ctes(2), handles.ctes(3), handles.ctes(4));
    case -3 % henon
        set(handles.txt_descr_1, 'String', 'Henon Attractor');
        txt2 = sprintf('Iterations on the equation:\nx = y-a-b*x^2\ny = c*x');
        txt3 = sprintf('a: %1.5f;\nb: %1.5f;\nc: %1.5f', handles.ctes(1), handles.ctes(2), handles.ctes(3));
    case -2 % lorenz
        set(handles.txt_descr_1, 'String', 'Lorenz Attractor');
        txt2 = sprintf('Iterations on the equation:\ndx/dt = a*(y-x)\ndy/dt = x*(b-z)-y\ndz/dt = x*y-c*z');
        txt3 = sprintf('a: %1.5f;\nb: %1.5f;\nc: %1.5f', handles.ctes(1), handles.ctes(2), handles.ctes(3));
    case -1 % logistic
        set(handles.txt_descr_1, 'String', 'Logistic Equation');
        txt2 = sprintf('Iterations on the equation:\nx = c*x*(1-x)\nBased on biological population\nmodels.');
        txt3 = sprintf('Cmin: %1.5f; Cmax: %1.5f\nXmin: %1.5f; Xmax: %1.5f\nIterations: %d', handles.xmin, handles.xmax, handles.ymin, ...
            handles.ymax, handles.itern);
    case 1 % mandebrot
        set(handles.txt_descr_1, 'String', 'Mandelbrot Set');
		txt2 = sprintf('Xmin: %1.5f; Xmax: %1.5f\nYmin: %1.5f; Ymax: %1.5f\nIterations: %d', handles.xmin, handles.xmax, handles.ymin, ...
            handles.ymax, handles.itern);
        txt3 = '';
    case 2 % julia
        set(handles.txt_descr_1, 'String', 'Julia Set');
		txt2 = sprintf('Xmin: %1.5f; Xmax: %1.5f\nYmin: %1.5f; Ymax: %1.5f\nYJul: %1.5f; YJul: %1.5f\nIterations: %d', handles.xmin, ...
            handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern);
        txt3 = '';
    case 3 % newton
        set(handles.txt_descr_1, 'String', 'Newton-Raphson Method');
		txt3 = sprintf('Xmin: %1.5f; Xmax: %1.5f\nYmin: %1.5f; Ymax: %1.5f\nIterations: %d', handles.xmin, handles.xmax, handles.ymin, ...
            handles.ymax, handles.itern);
        txt2 = sprintf('Solutions to the equation\n%s', handles.newton_equation);
        set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia
    case 4 % user-defined newton
        set(handles.menu_change_grain, 'Enable', 'on');
        set(handles.txt_descr_1, 'String', 'Newton-Raphson Method');
		txt3 = sprintf('Xmin: %1.5f; Xmax: %1.5f\nYmin: %1.5f; Ymax: %1.5f\nIterations: %d', handles.xmin, handles.xmax, handles.ymin, ...
            handles.ymax, handles.itern);
        txt2 = sprintf('Solutions to the equation\n%s', handles.newton_equation);
        set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia
    case 5 % barnsley
        set(handles.txt_descr_1, 'String', 'Barnsley''s Tree');
		txt3 = sprintf('Xmin: %1.5f; Xmax: %1.5f\nYmin: %1.5f; Ymax: %1.5f\nYJul: %1.5f; YJul: %1.5f\nIterations: %d', handles.xmin, ...
            handles.xmax, handles.ymin, handles.ymax, handles.xjul, handles.yjul, handles.itern);
        txt2 = sprintf('Iteration on the equation\nz_new = c(z-sign(re(z)))');
        set(handles.menu_julia_mouse, 'Enable', 'off'); % disable julia
    case 6 % other mandebrot or julia
        set(handles.menu_change_grain, 'Enable', 'on');
        set(handles.txt_descr_1, 'String', handles.txtdescr{1});
        txt2 = handles.txtdescr{2};
		txt3 = sprintf('Xmin: %1.5f; Xmax: %1.5f\nYmin: %1.5f; Ymax: %1.5f\nIterations: %d', handles.xmin, handles.xmax, handles.ymin, ...
            handles.ymax, handles.itern);
        if handles.xjul ~= 0 | handles.yjul ~= 0
            txt3 = [txt3 sprintf('\nXjul: %1.5f; Yjul: %1.5f', handles.xjul, handles.yjul)];
        end
    otherwise
        set(handles.txt_descr_1, 'String', 'Unknown...');
        txt2 = '';
        txt3 = '';
end
set(handles.txt_descr_2, 'String', txt2);
set(handles.txt_descr_3, 'String', txt3);
        



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_mandelbrot_real(xmin, xmax, ymin, ymax, itern, gridsize, wb);
% Compute Mandelbrot Set

xstep = (xmax-xmin)/gridsize;
ystep = (ymax-ymin)/gridsize;
space = zeros(gridsize, gridsize);
%w_s = 100;

% compute each point
if wb, h = waitbar(0,'Computing...'); end
for ix = 0:gridsize-1
    x0 = xmin + ix*xstep;
    for iy = 0:gridsize-1
        y0 = ymin + iy*ystep;
        x = x0;
        y = y0;
        if ((x+0.25)^2+y^2 < 0.25) | ((x+1)^2+y^2 < 0.0625) | ((x-0.17)^2+(abs(y)-0.2)^2 < 0.04) | ((x+0.06)^2+(abs(y)-0.25)^2 < 0.15) | ...
                ((x+0.28)^2+(abs(y)-0.2)^2 < 0.15) | ((x+0.124)^2+(abs(y)-0.745)^2 < 0.0081) | ((x+1.31)^2+y^2 < 0.0035)
            i = 2*itern;
        else
            for i = 1:itern
                new_x = x^2-y^2+x0;
                y = 2*x*y+y0;
                x = new_x;
                if x^2+y^2 > 4
                    break;
                end
            end
        end
        space(iy+1, ix+1) = i;
    end
    if wb, waitbar(ix/gridsize,h); end
end
% normalize altitude:
space(space >= itern-1) = 0;
space = space ./ (max(max(space))/127);
if wb, close(h); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_julia_initial(xmin, xmax, ymin, ymax, xjul, yjul, itern, gridsize, wt);
% Compute Julia Set

xstep = (xmax-xmin)/gridsize;
ystep = (ymax-ymin)/gridsize;
space = zeros(gridsize, gridsize);
%w_s = 100;

% compute each point
if wt
    h = waitbar(0,'Computing...');
end
for ix = 0:gridsize/2-1
    x0 = xmin + ix*xstep;
    for iy = 0:gridsize-1
        y0 = ymin + iy*ystep;
        x = x0;
        y = y0;
        for i = 1:itern
            new_x = x^2-y^2+xjul;
            y = 2*x*y+yjul;
            x = new_x;
            if x^2+y^2 > 4
                break;
            end
        end
        space(iy+1, ix+1) = i;
        space(gridsize-iy, gridsize-ix) = i;
    end
    if wt
        waitbar(ix/gridsize*2,h);
    end
end
% normalize altitude:
space = space ./ (max(max(space))/127);
space(space == max(max(space))) = 0;
if wt
    close(h);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_julia(xmin, xmax, ymin, ymax, xjul, yjul, itern, gridsize, wb);
% Compute Julia Set

xstep = (xmax-xmin)/gridsize;
ystep = (ymax-ymin)/gridsize;
space = zeros(gridsize, gridsize);
%w_s = 100;

% compute each point
if wb, h = waitbar(0,'Computing...'); end
for ix = 0:gridsize-1
    x0 = xmin + ix*xstep;
    for iy = 0:gridsize-1
        y0 = ymin + iy*ystep;
        x = x0;
        y = y0;
        for i = 1:itern
            new_x = x^2-y^2+xjul;
            y = 2*x*y+yjul;
            x = new_x;
            if x^2+y^2 > 4
                break;
            end
        end
        space(iy+1, ix+1) = i;
    end
    if wb, waitbar(ix/gridsize,h); end
end
% normalize altitude:
space = space ./ (max(max(space))/127);
space(space == max(max(space))) = 0;
if wb, close(h); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_quaternion(xmin, xmax, ymin, ymax, zmin, zmax, time, itern, julia_cte, gridsize, waithdl);


xstep = (xmax-xmin)/gridsize;
ystep = (ymax-ymin)/gridsize;
zstep = (zmax-zmin)/gridsize;
kx = julia_cte(1); ky = julia_cte(2); kz = julia_cte(3); kt = julia_cte(4);
cx = kx; cy = ky; cz = kz; ct = kt;

space = ones(gridsize, gridsize, gridsize);
waitbar(0, waithdl, 'Computing...');
for ix = 0:gridsize-1
    x0 = xmin + ix*xstep;
    for iy = 0:gridsize-1
        y0 = ymin + iy*ystep;
        for iz = 0:gridsize-1
            z0 = zmin + iz*zstep;
            % now we have a quaternion defined by x0, y0, z0, time. Does it
            % belong to Mandelbrot?
            % so let's see (x+iy+jz+kt)^2 = 
            %                   (x^2-y^2-z^2-t^2-2yz-2yt-2zt)+2xyi+2xzj+2xtk
            % and add the constant cx+i cy+j cz+k ct...
            x = x0;
            y = y0;
            z = z0;
            t = time;
            if kx == 0 & ky == 0 & kz == 0 & kt == 0
                cx = x0; cy = y0; cz = z0; ct = time;
            end
%             q0 = [time, z0, y0, x0];
%             q = q0;
            for i = 1:itern
                xprime = x+x;
                x = x*x-y*y-z*z-t*t+cx;%-2*y*z-2*y*t-2*z*t;
                y = xprime*y+cy;
                z = xprime*z+cz;
                t = xprime*t+ct;
                if (x^2+y^2+z^2+t^2) > 2
                    space(ix+1, iy+1, iz+1) = 0;
                    break
                end
                % Quaternion multiplication is messy:
                %   q1*q2 = q1*[ q2(4) -q2(3)  q2(2) -q2(1)
				%                q2(3)  q2(4) -q2(1) -q2(2)
				%               -q2(2)  q2(1)  q2(4) -q2(3)
				%                q2(1)  q2(2)  q2(3)  q2(4) ]
%                 q = q*[ q(4) -q(3)  q(2) -q(1); ...
% 			            q(3)  q(4) -q(1) -q(2); ...
% 			           -q(2)  q(1)  q(4) -q(3); ...
% 			            q(1)  q(2)  q(3)  q(4) ];
                
%                 q = q + q0;
%                 if sum(q.^2) > 4
%                     space(ix+1, iy+1, iz+1) = 0;
%                     break;
%                 end
            end
        end
    end            
    waitbar(ix/gridsize/4,waithdl);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_circumpoly(xmin, xmax, ymin, ymax, xjul, yjul, itern, gridsize, wb);
% Compute Julia Set

xstep = (xmax-xmin)/gridsize;
ystep = (ymax-ymin)/gridsize;
space = zeros(gridsize, gridsize);
zjul = complex(xjul, yjul);
jul_set = 0;
if abs(zjul) ~= 0
    jul_set = 1;
end

% compute each point
if wb, h = waitbar(0,'Computing...'); end
for ix = 0:gridsize-1
    x0 = xmin + ix*xstep;
    for iy = 0:gridsize-1
        y0 = ymin + iy*ystep;
        z = complex(x0, y0);
        if jul_set
            z0 = zjul;
        else
            z0 = z;
        end
        for i = 1:itern
            z = 2*z*z0*tan(pi/z);
            if real(z)^2+imag(z)^2 > 4
                break;
            end
        end
        space(iy+1, ix+1) = i;
    end
    if wb, waitbar(ix/gridsize,h); end
end
% normalize altitude:
space = space ./ (max(max(space))/127);
space(space == max(max(space))) = 0;
if wb, close(h); end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_arbitrary(equation, xmin, xmax, ymin, ymax, xjul, yjul, itern, gridsize, wb);
% Compute Julia Set

f = inline(equation)

xstep = (xmax-xmin)/gridsize;
ystep = (ymax-ymin)/gridsize;
space = zeros(gridsize, gridsize);
zjul = complex(xjul, yjul);
jul_set = 0;
if abs(zjul) ~= 0
    jul_set = 1;
end

% compute each point
if wb, h = waitbar(0,'Computing...'); end
for ix = 0:gridsize-1
    x0 = xmin + ix*xstep;
    for iy = 0:gridsize-1
        y0 = ymin + iy*ystep;
        z = complex(x0, y0);
        if jul_set
            z0 = zjul;
        else
            z0 = z;
        end
        for i = 1:itern
            z = f(z, z0);
            if real(z)^2+imag(z)^2 > 4
                break;
            end
        end
        space(iy+1, ix+1) = i;
    end
    if wb, waitbar(ix/gridsize,h); end
end
% normalize altitude:
space = space ./ (max(max(space))/127);
space(space == max(max(space))) = 0;
if wb, close(h); end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_barnsley(xmin, xmax, ymin, ymax, xjul, yjul, itern, gridsize, wb);
% Compute Julia Set

xstep = (xmax-xmin)/gridsize;
ystep = (ymax-ymin)/gridsize;
space = zeros(gridsize, gridsize);
% zjul = complex(xjul, yjul);

% compute each point
if wb, h = waitbar(0,'Computing...'); end
for ix = 0:gridsize-1
    x0 = xmin + ix*xstep;
    for iy = 0:gridsize-1
        y0 = ymin + iy*ystep;
        x = x0;
        y = y0;
%         z = complex(x0, y0);
        for i = 1:itern
            xnew = x*xjul-sign(x)*xjul-y*yjul;
            y = xjul*y+x*yjul-sign(x)*yjul;
            x = xnew;
%             z = zjul*(z-sign(real(z)));
%            if real(z)^2+imag(z)^2 > 4
            if x^2 + y^2 > 4
                break;
            end
        end
        space(iy+1, ix+1) = i;
    end
    if wb, waitbar(ix/gridsize,h); end
end
% normalize altitude:
space = space ./ (max(max(space))/127);
space(space == max(max(space))) = 0;
if wb, close(h); end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_newton(xmin, xmax, ymin, ymax, itern, gridsize, wb);
% Compute Newton method:
% x^3 = -1
% Obviously, x = -1. But... we deal with complex numbers:
% 
% (a+bi)^3 = -1
% ((a^2-b^2)+2abi)*(a+bi) = -1
% a^3-ab^2+2a^2bi+a^2bi-b^3i-2ab^2 = -1
% a^3-3ab^2+(3a^2b-b^3)i = -1
% 3a^2b-b^3 = 0; assume b ~= 0, i.e. imaginary part
% 3a^2-b^2 = 0
% 3a^2=b^2
% a^3-3ab^2 = -1
% a^3-3a*3a^2+1 = 0
% a^3 -9a^3+1 = 0
% -8a^3=-1
% a^3=1/8
% --> a = 0.5
% --> b = +/- sqrt(3) / 2

xstep = (xmax-xmin)/gridsize;
ystep = (ymax-ymin)/gridsize;
space = zeros(gridsize, gridsize);
sol = zeros(gridsize, gridsize);
%w_s = 100;
tol = 0.001;

warning off MATLAB:divideByZero
% compute each point
if wb, h = waitbar(0,'Computing...'); end
for ix = 0:gridsize-1
    x0 = xmin + ix*xstep;
    for iy = 0:gridsize-1
        y0 = ymin + iy*ystep;
        x = x0;
        y = y0;
        for i = 1:itern
            bre = x^2-y^2;
            bim = 2*x*y;
            are = x*bre-y*bim-1;
            aim = x*bim+y*bre;
            bre = 3*bre;
            bim = 3*bim;
            k = bre*bre+bim*bim;
            x = x-(are*bre+aim*bim)/k;
            y = y-(bre*aim-are*bim)/k;
            if (abs(x-1) < tol)
                if (abs(y) < tol)
                    sol(iy+1,ix+1) = 0;
                    break;
                end
            elseif (abs(x+0.5) < tol)
                if (abs(abs(y)-0.866) < tol)
                    if y > 0
                        sol(iy+1,ix+1) = 1;
                    else
                        sol(iy+1,ix+1) = 2;
                    end
                    break;
                end
            end    
        end
        space(iy+1, ix+1) = i;
    end
    if wb, waitbar(ix/gridsize,h); end
end
% normalize altitude:
space = space * 2;
space = space + 40*sol;
if wb, close(h); end
warning on MATLAB:divideByZero


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_newton_power(xmin, xmax, ymin, ymax, itern, gridsize, ctes, wb);
% Compute Newton method.

gridsize = round(gridsize);
xstep = (xmax-xmin)/gridsize;
ystep = (ymax-ymin)/gridsize;
space = zeros(gridsize, gridsize);
sol = zeros(gridsize, gridsize);
%w_s = 100;
tol = 0.01;
solutions = roots(ctes);
ctes_derivate = [];
for i = 1:length(ctes)-1
    ctes_derivative(i)=(length(ctes)-i)*ctes(i);
end
% until now, unsuccessful with using polynomial division...
% 	[fdivfp, rem] = deconv(ctes, ctes_derivative);
% 	while rem(1) == 0
%         rem = rem(2:end);
% 	end

warning off MATLAB:divideByZero
% compute each point
if wb, h = waitbar(0,'Computing...'); end
for ix = 0:gridsize-1
    x0 = xmin + ix*xstep;
    for iy = 0:gridsize-1
        y0 = ymin + iy*ystep;
        z0 = complex(x0, y0);
        for i = 1:itern
            z = polyval(ctes, z0);
            zp = polyval(ctes_derivative, z0);
            z0 = z0 - z/zp;
            % with polynomial division (unsuccessful):
            %   z0 = z0 - (polyval(fdivfp, z0)+polyval(rem, z0));
            tmp = abs(repmat(z0, size(solutions))-solutions);
            idx = find(tmp<tol);
            if ~isempty(idx)
                sol(iy+1, ix+1) = idx(1);
                break;
            end
        end
        space(iy+1, ix+1) = i;
    end
    if wb, waitbar(ix/gridsize,h); end
end
% normalize altitude:
space = space ./ max(max(space));
space = space + 1*(sol-1);
space = space ./ max(max(space)) * 64;
if wb, close(h); end
warning on MATLAB:divideByZero

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = get_mandelbrot_initial(gridsize);
% Compute Julia Set
if exist('mandelbrot_set.mat', 'file')
    sp = load('mandelbrot_set');
    space = sp.space;
    if length(space) ~= gridsize
        space = compute_mandelbrot_real(-2, 1, -1.5, 1.5, gridsize/15, gridsize, 1);
        save('mandelbrot_set.mat', 'space');
	end
else
    space = compute_mandelbrot_real(-2, 1, -1.5, 1.5, gridsize/15, gridsize, 1);
    save('mandelbrot_set.mat', 'space');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function space = compute_logistic(xmin, xmax, ymin, ymax, itern, gridsize, wb);
% Compute Logistic equation

xstep = (xmax-xmin)/gridsize;

% compute each point
if wb, h = waitbar(0,'Computing...'); end
logequ = [];
iternfactor = 1;
for ix = 0:gridsize-1
    c = xmin + ix*xstep;
    x = 0.5;
    ooodx = 0;
    ooldx = 0;
    olx = 0;
    if c > 2.5
        iternfactor = 4;
    end
    if c > 3.6
        iternfactor = 0.5;
    end
    for i = 1:itern*iternfactor
        ooodx = ooldx;
        ooldx = olx;
        olx = x;
        x = x*(1-x)*c;
        if abs(ooldx - x) < xstep/2 & abs(olx - ooldx) < xstep/2
            break;
        end
    end
    for i = 1:itern*2
        ooldx = olx;
        olx = x;
        x = x*(1-x)*c;
        if x >= ymin & x <= ymax
            logequ = [logequ; c x];
        end
        if ooldx == olx & olx == x
            break;
        end
        if c < 2.5
            break;
        elseif c < 3.5 & i > 5
            break;
        end
    end
    if wb, waitbar(ix/gridsize,h); end
    logequ = unique(logequ, 'rows');
end

space = logequ;
if wb, close(h); end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [lin_str_exp, overflow] = expand_string(lin_str, rules);
rlz = '';
for i = 1:length(rules)
    rlz = [rlz rules.code];
end
overflow = 0;
lin_str_exp = [];
for i = 1:length(lin_str)
    if sum(lin_str(i)==rlz)
        % this must be modified
        idx = find(lin_str(i)==rlz);
        lin_str_exp = [lin_str_exp rules(idx(1)).replace];
    else
        lin_str_exp = [lin_str_exp lin_str(i)];
    end
    if length(lin_str_exp) > 32000
        overflow = 1;
        i = length(lin_str)+1;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = interpret_3D_string(handles, lin_str, graphic_rules, unit);

hold off;
lnw = 2;
x = 0;
y = 0;
z = 0;
alpha = 0;
beta = pi/2;
rlz = '';
for i = 1:length(graphic_rules)
    rlz = [rlz graphic_rules(i).code];
end
sx = x;
lx = x;
sy = y;
ly = y;
sz = z;
lz = z;
for i_i = 1:length(lin_str)
    idx = find(lin_str(i_i)==rlz);
    switch graphic_rules(idx(1)).type
        case -1
            % do nothing
            ;
        case 0
            % draw a unit line
            oldx = x(end);
            oldy = y(end);
            oldz = z(end);
            x(end) = x(end) + sin(alpha(end))*cos(beta(end))*unit;
            y(end) = y(end) + cos(alpha(end))*cos(beta(end))*unit;
            z(end) = z(end) + sin(beta(end))*unit;
            plot3([oldx x(end)], [oldy y(end)], [oldz z(end)], graphic_rules(idx(1)).style, 'LineWidth', round(lnw(end)));
            hold on;
        case 1
            % go forward, but do not draw
            x(end) = x(end) + sin(alpha(end))*cos(beta(end))*unit;
            y(end) = y(end) + cos(alpha(end))*cos(beta(end))*unit;
            z(end) = z(end) + sin(beta(end))*unit;
        case 2
            % change angle
            if graphic_rules(idx(1)).value ~= 0
                alpha(end) = alpha(end) + graphic_rules(idx(1)).value;
            else
                alpha(end) = alpha(end) + unifrnd(pi/6, pi);
            end
        case 3
            % draw point
            pt_sz = unidrnd(graphic_rules(idx(1)).value/2)+graphic_rules(idx(1)).value/2;
            plot3([x(end) x(end)], [y(end) y(end)], [z(end) z(end)], graphic_rules(idx(1)).style, 'MarkerSize', pt_sz, 'MarkerFaceColor', ...
                graphic_rules(idx(1)).style(1));
            hold on;
        case 4
            % push stack
            x = [x x(end)];
            y = [y y(end)];
            z = [z z(end)];
            alpha = [alpha alpha(end)];
            beta = [beta beta(end)];
            lnw = [lnw lnw(end)];
        case 5
            % pull stack
            x = x(1:end-1);
            y = y(1:end-1);
            z = z(1:end-1);
            alpha = alpha(1:end-1);
            beta = beta(1:end-1);
            lnw = lnw(1:end-1);
        case 6
            % bold
            lnw(end) = lnw(end)+graphic_rules(idx(1)).value;
        case 7
            % thinner
            lnw(end) = lnw(end) * graphic_rules(idx(1)).value;
            if lnw(end) < 1
                lnw(end) = 1;
            end
        case 8
            % change 3D angle
            if graphic_rules(idx(1)).value ~= 0
                beta(end) = beta(end) + graphic_rules(idx(1)).value;;
            else
                beta(end) = beta(end) + unifrnd(pi/6, pi);
            end
        otherwise
            % do nothing
            ;
    end
    if x(end) < sx
        sx = x(end);
    end
    if y(end) < sy
        sy = y(end);
    end
    if z(end) < sz
        sz = z(end);
    end
    if x(end) > lx
        lx = x(end);
    end
    if y(end) > ly
        ly = y(end);
    end
    if z(end) > lz
        lz = z(end);
    end
end
if lx-sx > ly - sy
    if lz-sz > lx-sx
        range = lz-sz;
        sy = sy+(ly-sy)/2-range/2;
        ly = sy + range;
        sx = sx+(lx-sx)/2-range/2;
        lx = sx + range;
    else
        range = lx-sx;
        sy = sy+(ly-sy)/2-range/2;
        ly = sy + range;
        sz = sz+(lz-sz)/2-range/2;
        lz = sz + range;
    end
else
    if lz-sz > ly-sy
        range = lz-sz;
        sy = sy+(ly-sy)/2-range/2;
        ly = sy + range;
        sx = sx+(lx-sx)/2-range/2;
        lx = sx + range;
    else
        range = ly-sy;
        sx = sx+(lx-sx)/2-range/2;
        lx = sx + range;
        sz = sz+(lz-sz)/2-range/2;
        lz = sz + range;
    end
end
border = range/20;
set(handles.main_axis, 'XLim',[sx-border lx+border],'YLim',[sy-border ly+border],'ZLim',[sz-border lz+border], 'XTick', [], 'YTick', [], 'ZTick', []);
set(handles.main_axis, 'Color',[0 0 0]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function handles = interpret_string(handles, lin_str, graphic_rules, unit);

hold off;
lnw = 2;
x = 0;
y = 0;
alpha = pi/2;
rlz = '';
for i = 1:length(graphic_rules)
    rlz = [rlz graphic_rules(i).code];
end
sx = x;
lx = x;
sy = y;
ly = y;
for i_i = 1:length(lin_str)
    idx = find(lin_str(i_i)==rlz);
    switch graphic_rules(idx(1)).type
        case -1
            % do nothing
            ;
        case 0
            % draw a unit line
            oldx = x(end);
            oldy = y(end);
            x(end) = x(end) + sin(alpha(end))*unit;
            y(end) = y(end) + cos(alpha(end))*unit;
            plot([oldx x(end)], [oldy y(end)], graphic_rules(idx(1)).style, 'LineWidth', round(lnw(end)));
            hold on;
        case 1
            % go forward, but do not draw
            x(end) = x(end) + sin(alpha(end))*unit;
            y(end) = y(end) + cos(alpha(end))*unit;
        case 2
            % change angle
            alpha(end) = alpha(end) + graphic_rules(idx(1)).value;
        case 3
            % draw point
            pt_sz = unidrnd(graphic_rules(idx(1)).value/2)+graphic_rules(idx(1)).value/2;
            plot([x(end) x(end)], [y(end) y(end)], graphic_rules(idx(1)).style, 'MarkerSize', pt_sz, 'MarkerFaceColor', ...
                graphic_rules(idx(1)).style(1));
            hold on;
        case 4
            % push stack
            x = [x x(end)];
            y = [y y(end)];
            alpha = [alpha alpha(end)];
            lnw = [lnw lnw(end)];
        case 5
            % pull stack
            x = x(1:end-1);
            y = y(1:end-1);
            alpha = alpha(1:end-1);
            lnw = lnw(1:end-1);
        case 6
            % bold
            lnw(end) = lnw(end)+graphic_rules(idx(1)).value;
        case 7
            % thinner
            lnw(end) = lnw(end) * graphic_rules(idx(1)).value;
            if lnw(end) < 1
                lnw(end) = 1;
            end
        otherwise
            % do nothing
            ;
    end
    if x(end) < sx
        sx = x(end);
    end
    if y(end) < sy
        sy = y(end);
    end
    if x(end) > lx
        lx = x(end);
    end
    if y(end) > ly
        ly = y(end);
    end
end
if lx-sx > ly - sy
    range = lx-sx;
    sy = sy+(ly-sy)/2-range/2;
    ly = sy + range;
else
    range = ly-sy;
    sx = sx+(lx-sx)/2-range/2;
    lx = sx + range;
end
border = range/20;
set(handles.main_axis, 'XLim',[sx-border lx+border],'YLim',[sy-border ly+border], 'XTick', [], 'YTick', []);
set(handles.main_axis, 'Color',[0 0 0]);

%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=
%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=
%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=%=
function Answer=localdlg(Prompt, Title, NumLines, DefAns, varargin)
% based on inputdlg; modifications:
% 1) less options (i.e. no "option" struct), MUST be called with at least four
%       parameters: answer = localdlg(prompt, title, numlines,defaultanswers)
% 2) up to three optional input to define a custom button:
%       1: Callback function [if not present, only 2 buttons, OK and
%                             Cancel]
%       2: Button name [default: 'Custom']
%       3: data to store in the figure's UserData.Data [default: none]
%       note that UserData contains fields with handles to the different
%       dialog elements, such as UserData.EditHandles...
% Example:
% chosen_params = localdlg({[sprintf('Params:\n\n') 'a:'], 'b:'}, 'Kool Title', [1 10], default_params, ...
%     ['usrdta = get(gcbf, ''UserData'');z = unidrnd(length(usrdta.Data));for i=1:length(usrdta.EditHandles),'...
%      'set(usrdta.EditHandles(i), ''String'', str2num(usrdta.Data{z,i})); end;'], 'Cool Set', cool_params);
%
% Note: the main use of this function is for programs (e.g. GUIDE dialogs)
% that should contain a sub-dialog for asking some parameters - if it is
% not wished to have multiple files. i.e. this function can just be pasted
% at the end of the main .m file and will work, which would not be the case
% of functions requiring multiple function calls. Therefore it is intended
% for the optional callback to be inline, and not a function call...
Black      =[0       0        0      ]/255;
LightGray  =[192     192      192    ]/255;
LightGray2 =[160     160      164    ]/255;
MediumGray =[128     128      128    ]/255;
White      =[255     255      255    ]/255;
NumQuest=prod(size(Prompt));   
WindowStyle='normal'; % modal
Interpreter='none';
Resize = 'off';
[rw,cl]=size(NumLines);
OneVect = ones(NumQuest,1);
if (rw == 1 & cl == 2)
  NumLines=NumLines(OneVect,:);
elseif (rw == 1 & cl == 1)
  NumLines=NumLines(OneVect);
elseif (rw == 1 & cl == NumQuest)
  NumLines = NumLines';
elseif rw ~= NumQuest | cl > 2,
  error('NumLines size is incorrect.')
end
FigWidth=300;FigHeight=100;
FigPos(3:4)=[FigWidth FigHeight];
FigColor=get(0,'Defaultuicontrolbackgroundcolor');
TextForeground = Black;
if sum(abs(TextForeground - FigColor)) < 1
    TextForeground = White;
end
InputFig=dialog(                               ...
               'Visible'         ,'off'      , ...
               'Name'            ,Title      , ...
               'Pointer'         ,'arrow'    , ...
               'Units'           ,'points'   , ...
               'UserData'        ,''         , ...
               'Tag'             ,Title      , ...
               'HandleVisibility','on'       , ...
               'Color'           ,FigColor   , ...
               'NextPlot'        ,'add'      , ...
               'WindowStyle'     ,WindowStyle, ...
               'Resize'          ,Resize       ...
               );
DefOffset=5;
SmallOffset=2;
DefBtnWidth=70;
BtnHeight=20;
BtnYOffset=DefOffset;
BtnFontSize=get(0,'FactoryUIControlFontSize');
BtnWidth=DefBtnWidth;
TextInfo.Units              ='points'   ;   
TextInfo.FontSize           =BtnFontSize;
TextInfo.HorizontalAlignment='left'     ;
TextInfo.HandleVisibility   ='callback' ;
StInfo=TextInfo;
StInfo.Style              ='text'     ;
StInfo.BackgroundColor    =FigColor;
StInfo.ForegroundColor    =TextForeground ;
TextInfo.VerticalAlignment='bottom';
EdInfo=StInfo;
EdInfo.Style='edit';
EdInfo.BackgroundColor=White;
BtnInfo=StInfo;
BtnInfo.Style='pushbutton';
BtnInfo.HorizontalAlignment='center';
% Determine # of lines for all Prompts
ExtControl=uicontrol(StInfo, ...
                     'String'   ,''         , ...    
                     'Position' ,[DefOffset                  DefOffset  ...
                                 0.96*(FigWidth-2*DefOffset) BtnHeight  ...
                                ]            , ...
                     'Visible'  ,'off'         ...
                     );
WrapQuest=cell(NumQuest,1);
QuestPos=zeros(NumQuest,4);
for ExtLp=1:NumQuest,
  if size(NumLines,2)==2
    [WrapQuest{ExtLp},QuestPos(ExtLp,1:4)]= ...
        textwrap(ExtControl,Prompt(ExtLp),NumLines(ExtLp,2));
   if length(varargin) > 0
        [WrapQuest{ExtLp},QuestPos(ExtLp,1:4)]= ...
            textwrap(ExtControl,Prompt(ExtLp),3*(DefBtnWidth+BtnYOffset));
    else
        [WrapQuest{ExtLp},QuestPos(ExtLp,1:4)]= ...
            textwrap(ExtControl,Prompt(ExtLp),2*(DefBtnWidth+BtnYOffset));
    end
  else,
    [WrapQuest{ExtLp},QuestPos(ExtLp,1:4)]= ...
        textwrap(ExtControl,Prompt(ExtLp),80);
  end
end
delete(ExtControl);
QuestHeight=QuestPos(:,4);
TxtHeight=QuestHeight(1)/size(WrapQuest{1,1},1);
EditHeight=TxtHeight*NumLines(:,1);
EditHeight(NumLines(:,1)==1)=EditHeight(NumLines(:,1)==1)+4;
FigHeight=(NumQuest+2)*DefOffset    + ...
          BtnHeight+sum(EditHeight) + ...
          sum(QuestHeight);
      FigHeight = FigHeight - sum(EditHeight);
TxtXOffset=DefOffset;
LegndWidth = 1;
for i = 1:NumQuest
    LegndWidth = max(LegndWidth, length(WrapQuest{i}{end})*5);
    ini_width_extra(i) = 0;
end
for i = 1:length(WrapQuest{1})
    ini_width_extra(1) = length(WrapQuest{1}{i})*5-LegndWidth;
end
LegndWidth = LegndWidth+10;
TxtXOffset = TxtXOffset*2;
TxtXOffset2 = DefOffset + LegndWidth;
TxtWidth=FigWidth-2*DefOffset;
QuestYOffset=zeros(NumQuest,1);
EditYOffset=zeros(NumQuest,1);
QuestYOffset(1)=FigHeight-DefOffset-QuestHeight(1);
EditYOffset(1)=QuestYOffset(1);%QuestYOffset(1)-EditHeight(1);
for YOffLp=2:NumQuest,
  QuestYOffset(YOffLp)=EditYOffset(YOffLp-1)-QuestHeight(YOffLp)-DefOffset;
  %EditYOffset(YOffLp)=QuestYOffset(YOffLp)-EditHeight(YOffLp); %-SmallOffset;
  EditYOffset(YOffLp)=QuestYOffset(YOffLp);
end
QuestHandle=[];
EditHandle=[];
FigWidth =1;
AxesHandle=axes('Parent',InputFig,'Position',[0 0 1 1],'Visible','off');
for lp=1:NumQuest,
  QuestTag=['Prompt' num2str(lp)];
  EditTag=['Edit' num2str(lp)];
  if ~ischar(DefAns{lp}),
    delete(InputFig);
    error('Default answers must be strings in INPUTDLG.');
  end
  QuestHandle(lp)=text('Parent',AxesHandle, ...
                        TextInfo     , ...
                        'Position'   ,[ TxtXOffset QuestYOffset(lp)], ...
                        'String'     ,WrapQuest{lp}                 , ...
                        'Color'      ,TextForeground                , ...
                        'Interpreter',Interpreter                   , ...
                        'Tag'        ,QuestTag                        ...
                        );
  EditHandle(lp)=uicontrol(InputFig   ,EdInfo     , ...
                          'Max'       ,NumLines(lp,1)       , ...
                          'Position'  ,[ TxtXOffset2 EditYOffset(lp) ...
                                         TxtWidth   EditHeight(lp)  ...
                                       ]                    , ...
                          'String'    ,DefAns{lp}           , ...
                          'Tag'       ,QuestTag               ...
                          );
  if size(NumLines,2) == 2,
    set(EditHandle(lp),'String',char(ones(1,NumLines(lp,2))*'x'));
    Extent = get(EditHandle(lp),'Extent');
    NewPos = [TxtXOffset2 EditYOffset(lp)  Extent(3) EditHeight(lp) ];
    NewPos1= [TxtXOffset QuestYOffset(lp)];
    set(EditHandle(lp),'Position',NewPos,'String',DefAns{lp})
    set(QuestHandle(lp),'Position',NewPos1)
    FigWidth=max(FigWidth,Extent(3)+2*DefOffset);
  else
    FigWidth=max(175,TxtWidth+2*DefOffset);
  end
end % for lp
FigPos=get(InputFig,'Position');
Temp=get(0,'Units');
set(0,'Units','points');
ScreenSize=get(0,'ScreenSize');
set(0,'Units',Temp);
if length(varargin) > 0
    FigWidth=max(FigWidth,3*(BtnWidth+DefOffset)+DefOffset);
else
    FigWidth=max(FigWidth,2*(BtnWidth+DefOffset)+DefOffset);
end
FigPos(1)=(ScreenSize(3)-FigWidth)/2;
FigPos(2)=(ScreenSize(4)-FigHeight)/2;
FigPos(3)=FigWidth;
FigPos(4)=FigHeight;
set(InputFig,'Position',FigPos);
if length(varargin) > 0
    CBString=varargin{1};
	if length(varargin) > 1
        tmpbtnname=varargin{2};
	else
        tmpbtnname='Custom';
	end
    nbbut = 3;
    CustomHandle=uicontrol(InputFig    ,              ...
                   BtnInfo     , ...
                   'Position'  ,[ FigWidth-BtnWidth-DefOffset DefOffset ...
                                  BtnWidth                    BtnHeight ...
                                ]           , ...
                  'String'     ,tmpbtnname        , ...
                  'Callback'   ,CBString    , ...
                  'Tag'        ,CBString          ...
                  );
else
    nbbut = 2;
end
CBString='set(gcbf,''UserData'',''Cancel'');uiresume';
CancelHandle=uicontrol(InputFig   ,              ...
                      BtnInfo     , ...
                      'Position'  ,[FigWidth-(nbbut-1)*BtnWidth-(nbbut-1)*DefOffset DefOffset ...
                                    BtnWidth  BtnHeight  ...
                                   ]           , ...
                      'String'    ,'Cancel'    , ...
                      'Callback'  ,CBString    , ...
                      'Tag'       ,'Cancel'      ...
                      );
CBString='set(gcbf,''UserData'',''OK'');uiresume';
OKHandle=uicontrol(InputFig    ,              ...
                   BtnInfo     , ...
                   'Position'  ,[ FigWidth-nbbut*BtnWidth-nbbut*DefOffset DefOffset ...
                                  BtnWidth                    BtnHeight ...
                                ]           , ...
                  'String'     ,'OK'        , ...
                  'Callback'   ,CBString    , ...
                  'Tag'        ,'OK'          ...
                  );
Data.OKHandle = OKHandle;
Data.CancelHandle = CancelHandle;
Data.EditHandles = EditHandle;
Data.QuestHandles = QuestHandle;
Data.LineInfo = NumLines;
Data.ButtonWidth = BtnWidth;
Data.ButtonHeight = BtnHeight;
Data.EditHeight = TxtHeight+4;
Data.Offset = DefOffset;
if length(varargin) > 2
    Data.Data=varargin{3};
end
set(InputFig ,'Visible','on','UserData',Data);
% This drawnow is a hack to work around a bug
drawnow
set(findall(InputFig),'Units','normalized','HandleVisibility','callback');
set(InputFig,'Units','points');
uiwait(InputFig);
TempHide=get(0,'ShowHiddenHandles');
set(0,'ShowHiddenHandles','on');
if any(get(0,'Children')==InputFig),
  Answer={};
  if strcmp(get(InputFig,'UserData'),'OK'),
    Answer=cell(NumQuest,1);
    for lp=1:NumQuest,
      Answer(lp)=get(EditHandle(lp),{'String'});
    end % for
  end % if strcmp
  delete(InputFig);
else,
  Answer={};
end % if any
set(0,'ShowHiddenHandles',TempHide);





% --- Creates and returns a handle to the GUI figure. 
function h1 = fractal_explorer_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end

h1 = figure(...
'PaperUnits',get(0,'defaultfigurePaperUnits'),...
'Color',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','CSE Fractals III',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'PaperSize',[20.98404194812 29.67743169791],...
'PaperType',get(0,'defaultfigurePaperType'),...
'Position',[623.8 145.384615384615 1132 839],...
'Renderer',get(0,'defaultfigureRenderer'),...
'RendererMode','manual',...
'Resize','off',...
'HandleVisibility','callback',...
'Tag','fractal_explorer',...
'UserData',zeros(1,0));

setappdata(h1, 'GUIDEOptions', struct(...
'active_h', 1.800005e+002, ...
'taginfo', struct(...
'figure', 2, ...
'axes', 4, ...
'frame', 3, ...
'edit', 2, ...
'text', 8, ...
'pushbutton', 7, ...
'checkbox', 2), ...
'override', 0, ...
'release', 13, ...
'resize', 'none', ...
'accessibility', 'callback', ...
'mfile', 1, ...
'callbacks', 1, ...
'singleton', 1, ...
'syscolorfig', 1, ...
'lastSavedFile', 'd:\cavin\veneer\other_mfiles\fractal_explorer.m'));


h2 = axes(...
'Parent',h1,...
'Units','pixels',...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[25 25 800 800],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','main_axis');


h3 = get(h2,'title');

set(h3,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.499375 1.009375 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h4 = get(h2,'xlabel');

set(h4,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.499375 -0.034375 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off');

h5 = get(h2,'ylabel');

set(h5,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.043125 0.498125 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off');

h6 = get(h2,'zlabel');

set(h6,...
'Parent',h2,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-0.030625 1.016875 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h7 = axes(...
'Parent',h1,...
'Units','pixels',...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'Position',[900 523 150 150],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','preview_axis',...
'Visible','off');


h8 = get(h7,'title');

set(h8,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496666666666666 1.05 1.00005459937205],...
'VerticalAlignment','bottom',...
'HandleVisibility','off',...
'Visible','off');

h9 = get(h7,'xlabel');

set(h9,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[0.496666666666666 -0.183333333333334 1.00005459937205],...
'VerticalAlignment','cap',...
'HandleVisibility','off',...
'Visible','off');

h10 = get(h7,'ylabel');

set(h10,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','center',...
'Position',[-0.23 0.49 1.00005459937205],...
'Rotation',90,...
'VerticalAlignment','bottom',...
'HandleVisibility','off',...
'Visible','off');

h11 = get(h7,'zlabel');

set(h11,...
'Parent',h7,...
'Color',[0 0 0],...
'HorizontalAlignment','right',...
'Position',[-5.99666666666667 2.10333333333333 1.00005459937205],...
'HandleVisibility','off',...
'Visible','off');

h12 = uicontrol(...
'Parent',h1,...
'ListboxTop',0,...
'Position',[897 674 155 24],...
'String','Preview Pane',...
'Style','text',...
'Tag','txt_zoom_2',...
'Visible','off');


h13 = uicontrol(...
'Parent',h1,...
'Callback','fractal_explorer(''button_cancel_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[918 451 116 24],...
'String','Cancel Selection',...
'Tag','button_cancel',...
'Visible','off');


h14 = uicontrol(...
'Parent',h1,...
'Callback','fractal_explorer(''button_compute_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[918 480 116 24],...
'String','Compute...',...
'Tag','button_compute',...
'Visible','off');


h15 = uicontrol(...
'Parent',h1,...
'HorizontalAlignment','left',...
'ListboxTop',0,...
'Position',[867 705 238 38],...
'String',{ 'Click twice in the fractal to define zone' 'to zoom in, then click on "Compute..."' },...
'Style','text',...
'Tag','txt_zoom_1',...
'Visible','off');


h16 = uimenu(...
'Parent',h1,...
'Callback','fractal_explorer(''menu_head_program_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Program',...
'Tag','menu_head_program');

h17 = uimenu(...
'Parent',h16,...
'Callback','fractal_explorer(''menu_copy_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Copy',...
'Tag','menu_copy');

h18 = uimenu(...
'Parent',h16,...
'Callback','fractal_explorer(''menu_head_comput_Callback'',gcbo,[],guidata(gcbo))',...
'Label','C&omputation Control',...
'Separator','on',...
'Tag','menu_head_comput');

h19 = uimenu(...
'Parent',h18,...
'Callback','fractal_explorer(''menu_change_iterations_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Iterations',...
'Tag','menu_change_iterations');

h20 = uimenu(...
'Parent',h18,...
'Callback','fractal_explorer(''menu_change_grain_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Precision',...
'Tag','menu_change_grain');

h21 = uimenu(...
'Parent',h16,...
'Callback','fractal_explorer(''menu_head_image_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Co&lor Control',...
'Tag','menu_head_image');

h22 = uimenu(...
'Parent',h21,...
'Callback','fractal_explorer(''menu_head_colors_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Change &Colors',...
'Tag','menu_head_colors');

h23 = uimenu(...
'Parent',h22,...
'Callback','fractal_explorer(''menu_color_standard_Callback'',gcbo,[],guidata(gcbo))',...
'Checked','on',...
'Label','&Standard',...
'Tag','menu_color_standard');

h24 = uimenu(...
'Parent',h22,...
'Callback','fractal_explorer(''menu_color_copper_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Copper',...
'Tag','menu_color_copper');

h25 = uimenu(...
'Parent',h22,...
'Callback','fractal_explorer(''menu_color_psy_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Psychedelic',...
'Tag','menu_color_psy');

h26 = uimenu(...
'Parent',h22,...
'Callback','fractal_explorer(''menu_color_hot_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Hot',...
'Separator','on',...
'Tag','menu_color_hot');

h27 = uimenu(...
'Parent',h22,...
'Callback','fractal_explorer(''menu_color_cool_Callback'',gcbo,[],guidata(gcbo))',...
'Label','C&ool',...
'Tag','menu_color_cool');

h28 = uimenu(...
'Parent',h22,...
'Callback','fractal_explorer(''menu_color_spring_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Sp&ring',...
'Separator','on',...
'Tag','menu_color_spring');

h29 = uimenu(...
'Parent',h22,...
'Callback','fractal_explorer(''menu_color_summer_Callback'',gcbo,[],guidata(gcbo))',...
'Label','S&ummer',...
'Tag','menu_color_summer');

h30 = uimenu(...
'Parent',h22,...
'Callback','fractal_explorer(''menu_color_autumn_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Autumn',...
'Tag','menu_color_autumn');

h31 = uimenu(...
'Parent',h22,...
'Callback','fractal_explorer(''menu_color_winter_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Winter',...
'Tag','menu_color_winter');

h32 = uimenu(...
'Parent',h21,...
'Callback','fractal_explorer(''menu_head_colorshift_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Color Shift',...
'Tag','menu_head_colorshift');

h33 = uimenu(...
'Parent',h32,...
'Callback','fractal_explorer(''menu_color_shift_one_Callback'',gcbo,[],guidata(gcbo))',...
'Label','One step',...
'Tag','menu_color_shift_one');

h34 = uimenu(...
'Parent',h32,...
'Callback','fractal_explorer(''menu_color_shift_conti_Callback'',gcbo,[],guidata(gcbo))',...
'Label','Continuous',...
'Tag','menu_color_shift_conti');

h35 = uimenu(...
'Parent',h16,...
'Callback','fractal_explorer(''menu_save_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Save Picture',...
'Separator','on',...
'Tag','menu_save');

h36 = uimenu(...
'Parent',h16,...
'Callback','fractal_explorer(''menu_help_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Help',...
'Separator','on',...
'Tag','menu_help');

h37 = uimenu(...
'Parent',h16,...
'Callback','fractal_explorer(''menu_quit_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Quit',...
'Tag','menu_quit');

h38 = uicontrol(...
'Parent',h1,...
'Callback','fractal_explorer(''button_zoom_Callback'',gcbo,[],guidata(gcbo))',...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[855 755 108 25],...
'String','Zoom In',...
'Tag','button_zoom');


h39 = uicontrol(...
'Parent',h1,...
'ListboxTop',0,...
'Position',[851 26 250 184],...
'String',{ '' },...
'Style','frame',...
'Tag','frame2');


h40 = uicontrol(...
'Parent',h1,...
'FontWeight','bold',...
'HorizontalAlignment','left',...
'ListboxTop',0,...
'Position',[860 183 192 17],...
'String','Mandelbrot Set',...
'Style','text',...
'Tag','txt_descr_1');


h41 = uicontrol(...
'Parent',h1,...
'HorizontalAlignment','left',...
'ListboxTop',0,...
'Position',[860 110 230 65],...
'String',{ 'Xmin: -2.0; Xmax: 1.0' 'Ymin: -1.5; Ymax: 1.5' 'Iterations: 70' },...
'Style','text',...
'Tag','txt_descr_2');


h42 = uicontrol(...
'Parent',h1,...
'HorizontalAlignment','left',...
'ListboxTop',0,...
'Position',[861 31 229 65],...
'Style','text',...
'Tag','txt_descr_3');


h43 = uimenu(...
'Parent',h1,...
'Callback','fractal_explorer(''menu_head_real_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Real',...
'Tag','menu_head_real');

h44 = uimenu(...
'Parent',h43,...
'Callback','fractal_explorer(''menu_logistic_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Logistic Equation',...
'Tag','menu_logistic');

h45 = uimenu(...
'Parent',h43,...
'Callback','fractal_explorer(''menu_head_2d_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&2-D',...
'Separator','on',...
'Tag','menu_head_2d');

h46 = uimenu(...
'Parent',h45,...
'Callback','fractal_explorer(''menu_henon_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Henon',...
'Tag','menu_henon');

h47 = uimenu(...
'Parent',h45,...
'Callback','fractal_explorer(''menu_pickover_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Pickover',...
'Tag','menu_pickover');

h48 = uimenu(...
'Parent',h45,...
'Callback','fractal_explorer(''menu_quadratic_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Quadratic Map',...
'Tag','menu_quadratic');

h49 = uimenu(...
'Parent',h43,...
'Callback','fractal_explorer(''menu_head_3d_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&3-D',...
'Tag','menu_head_3d');

h50 = uimenu(...
'Parent',h49,...
'Callback','fractal_explorer(''menu_lorenz_Callback'',gcbo,[],guidata(gcbo))',...
'Label','L&orenz',...
'Tag','menu_lorenz');

h51 = uimenu(...
'Parent',h49,...
'Callback','fractal_explorer(''menu_3d_quadratic_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Quadratic Map',...
'Tag','menu_3d_quadratic');

h52 = uimenu(...
'Parent',h49,...
'Callback','fractal_explorer(''menu_rossler_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Rossler',...
'Tag','menu_rossler');

h53 = uimenu(...
'Parent',h49,...
'Callback','fractal_explorer(''menu_rabinovich_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Rabinovich-Fabrikant',...
'Tag','menu_rabinovich');

h54 = uicontrol(...
'Parent',h1,...
'Callback','fractal_explorer(''button_zoomout_Callback'',gcbo,[],guidata(gcbo))',...
'FontWeight','bold',...
'ListboxTop',0,...
'Position',[981 755 108 25],...
'String','Zoom Out',...
'Tag','button_zoomout');


h55 = uimenu(...
'Parent',h1,...
'Callback','fractal_explorer(''menu_head_complex_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Complex',...
'Tag','menu_head_complex');


h56 = uimenu(...
'Parent',h55,...
'Callback','fractal_explorer(''menu_mandlebrot_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Mandelbrot',...
'Tag','menu_mandlebrot');

h57 = uimenu(...
'Parent',h56,...
'Callback','fractal_explorer(''menu_mandelbrot_whole_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Whole Set',...
'Tag','menu_mandelbrot_whole');

h58 = uimenu(...
'Parent',h56,...
'Callback','fractal_explorer(''menu_mandelbrot_user_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&User Defined',...
'Tag','menu_mandelbrot_user');

h59 = uimenu(...
'Parent',h55,...
'Callback','fractal_explorer(''menu_julia_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Julia',...
'Tag','menu_julia');

h60 = uimenu(...
'Parent',h59,...
'Callback','fractal_explorer(''menu_julia_mouse_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Explorer',...
'Tag','menu_julia_mouse');

h61 = uimenu(...
'Parent',h59,...
'Callback','fractal_explorer(''menu_julia_user_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&User Defined',...
'Tag','menu_julia_user');

h62 = uimenu(...
'Parent',h55,...
'Callback','fractal_explorer(''menu_newton_head_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Newton',...
'Separator','on',...
'Tag','menu_newton_head');

h63 = uimenu(...
'Parent',h62,...
'Callback','fractal_explorer(''menu_newton_quad_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Cubic',...
'Tag','menu_newton_quad');

h64 = uimenu(...
'Parent',h62,...
'Callback','fractal_explorer(''menu_newton_user_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&User Defined',...
'Tag','menu_newton_user');

h65 = uimenu(...
'Parent',h55,...
'Callback','fractal_explorer(''menu_others_head_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Others',...
'Separator','on',...
'Tag','menu_others_head');

h66 = uimenu(...
'Parent',h65,...
'Callback','fractal_explorer(''menu_barnsley_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Barnsley''s Tree',...
'Tag','menu_barnsley');

h67 = uimenu(...
'Parent',h65,...
'Callback','fractal_explorer(''menu_circu_poly_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Circunscribed Polygon',...
'Tag','menu_circu_poly');

h68 = uimenu(...
'Parent',h65,...
'Callback','fractal_explorer(''menu_arbitrary_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Arbitrary Complex Map',...
'Separator','on',...
'Tag','menu_arbitrary');

h69 = uicontrol(...
'Parent',h1,...
'ForegroundColor',[0.843137254901961 0 0],...
'HorizontalAlignment','left',...
'ListboxTop',0,...
'Position',[857 216 236 78],...
'String',{ 'Click twice in the fractal to define zone' 'to zoom in, then click on "Compute..."' },...
'Style','text',...
'Tag','txt_help',...
'Visible','off');


h70 = uimenu(...
'Parent',h1,...
'Callback','fractal_explorer(''menu_head_quaternion_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Quaternion',...
'Tag','menu_head_quaternion');

h71 = uimenu(...
'Parent',h70,...
'Callback','fractal_explorer(''menu_quaternion_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&User Defined...',...
'Tag','menu_quaternion');

h72 = uicontrol(...
'Parent',h1,...
'Callback','fractal_explorer(''button_3D_Callback'',gcbo,[],guidata(gcbo))',...
'ListboxTop',0,...
'Position',[913 794 110 27],...
'String','Make It 3D!',...
'Tag','button_3D');


h73 = uimenu(...
'Parent',h1,...
'Callback','fractal_explorer(''manu_head_string_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&String',...
'Tag','manu_head_string');

h74 = uimenu(...
'Parent',h73,...
'Callback','fractal_explorer(''menu_lindenmayer_head_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Lindenmayer Systems',...
'Tag','menu_lindenmayer_head');

h75 = uimenu(...
'Parent',h74,...
'Callback','fractal_explorer(''menu_flakes_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Single Rule',...
'Tag','menu_flakes');

h76 = uimenu(...
'Parent',h74,...
'Callback','fractal_explorer(''menu_patterns_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Multiple Rules',...
'Tag','menu_patterns');

h77 = uimenu(...
'Parent',h73,...
'Callback','fractal_explorer(''menu_plants_head_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Plants',...
'Tag','menu_plants_head');

h78 = uimenu(...
'Parent',h77,...
'Callback','fractal_explorer(''menu_fern_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Fern',...
'Tag','menu_fern');

h79 = uimenu(...
'Parent',h77,...
'Callback','fractal_explorer(''menu_tree_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Tree',...
'Tag','menu_tree');

h80 = uimenu(...
'Parent',h73,...
'Callback','fractal_explorer(''menu_linden3D_head_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&3D-Systems',...
'Tag','menu_linden3D_head');

h81 = uimenu(...
'Parent',h80,...
'Callback','fractal_explorer(''menu_3D_linden_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Multiple Rules',...
'Tag','menu_3D_linden');

h82 = uimenu(...
'Parent',h80,...
'Callback','fractal_explorer(''menu_sponge_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Sponge',...
'Tag','menu_sponge');

h83 = uimenu(...
'Parent',h1,...
'Callback','fractal_explorer(''menu_head_others_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Folded Plan',...
'Tag','menu_head_others');

h84 = uimenu(...
'Parent',h83,...
'Callback','fractal_explorer(''menu_plane_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Grid',...
'Tag','menu_plane');

h85 = uimenu(...
'Parent',h83,...
'Callback','fractal_explorer(''menu_clouds_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Clouds',...
'Separator','on',...
'Tag','menu_clouds');

h86 = uimenu(...
'Parent',h83,...
'Callback','fractal_explorer(''menu_landscape_Callback'',gcbo,[],guidata(gcbo))',...
'Label','&Landscape',...
'Tag','menu_landscape');


hsingleton = h1;


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)


%   GUI_MAINFCN provides these command line APIs for dealing with GUIs
%
%      FRACTAL_EXPLORER, by itself, creates a new FRACTAL_EXPLORER or raises the existing
%      singleton*.
%
%      H = FRACTAL_EXPLORER returns the handle to a new FRACTAL_EXPLORER or the handle to
%      the existing singleton*.
%
%      FRACTAL_EXPLORER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRACTAL_EXPLORER.M with the given input arguments.
%
%      FRACTAL_EXPLORER('Property','Value',...) creates a new FRACTAL_EXPLORER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".

%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.4 $ $Date: 2002/05/31 21:44:31 $

gui_StateFields =  {'gui_Name'
                    'gui_Singleton'
                    'gui_OpeningFcn'
                    'gui_OutputFcn'
                    'gui_LayoutFcn'
                    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error('Could not find field %s in the gui_State struct in GUI M-file %s', gui_StateFields{i}, gui_Mfile);        
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [getfield(gui_State, gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % FRACTAL_EXPLORER
    % create the GUI
    gui_Create = 1;
elseif numargin > 3 & ischar(varargin{1}) & ishandle(varargin{2})
    % FRACTAL_EXPLORER('CALLBACK',hObject,eventData,handles,...)
    gui_Create = 0;
else
    % FRACTAL_EXPLORER(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = 1;
end

if gui_Create == 0
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else
        feval(varargin{:});
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.
    
    % Do feval on layout code in m-file if it exists
    if ~isempty(gui_State.gui_LayoutFcn)
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt);            
        end
    end
    
    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    
    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig 
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA
        guidata(gui_hFigure, guihandles(gui_hFigure));
    end
    
    % If user specified 'Visible','off' in p/v pairs, don't make the figure
    % visible.
    gui_MakeVisible = 1;
    for ind=1:2:length(varargin)
        if length(varargin) == ind
            break;
        end
        len1 = min(length('visible'),length(varargin{ind}));
        len2 = min(length('off'),length(varargin{ind+1}));
        if ischar(varargin{ind}) & ischar(varargin{ind+1}) & ...
                strncmpi(varargin{ind},'visible',len1) & len2 > 1
            if strncmpi(varargin{ind+1},'off',len2)
                gui_MakeVisible = 0;
            elseif strncmpi(varargin{ind+1},'on',len2)
                gui_MakeVisible = 1;
            end
        end
    end
    
    % Check for figure param value pairs
    for index=1:2:length(varargin)
        if length(varargin) == index
            break;
        end
        try, set(gui_hFigure, varargin{index}, varargin{index+1}), catch, break, end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end
    
    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});
    
    if ishandle(gui_hFigure)
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
        
        % Make figure visible
        if gui_MakeVisible
            set(gui_hFigure, 'Visible', 'on')
            if gui_Options.singleton 
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        rmappdata(gui_hFigure,'InGUIInitialization');
    end
    
    % If handle visibility is set to 'callback', turn it on until finished with
    % OutputFcn
    if ishandle(gui_hFigure)
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end
    
    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end
    
    if ishandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end    

function gui_hFigure = local_openfig(name, singleton)
if nargin('openfig') == 3 
    gui_hFigure = openfig(name, singleton, 'auto');
else
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
end


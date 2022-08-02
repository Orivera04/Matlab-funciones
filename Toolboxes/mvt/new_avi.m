function varargout = new_avi(varargin)
% NEW_AVI Open new movie AVI file for recording.
%    [FILENAME, X, Y, QUALITY, COMP, FPS] = NEW_AVI returns the selected
%    settings for the new AVI file FILENAME.
%           X and Y     - resolution X horizontal by Y vertical, in pixels
%           QUALITY     - compression quality, 65-100%
%           COMP        - method of video compression
%           FPS         - Frames per second
%
%    Default settings works well under Windows, Unix users should change
%    compression method. High QUALITY, large resolution X and Y) and more 
%    FPS implies larger files and takes longer time to record (An animation 
%    of 1 minute length at default settings, generates a movie file of about 
%    20 Mbyte).
%
% See also: DIRECTOR.
%
% Author:   Andreas Lund Danielsen
% Date:     10th November 2003
% Revisions: 


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @new_avi_OpeningFcn, ...
                   'gui_OutputFcn',  @new_avi_OutputFcn, ...
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


function new_avi_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for new_avi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes new_avi wait for user response (see UIRESUME)
uiwait(handles.figure1);


function varargout = new_avi_OutputFcn(hObject, eventdata, handles)
if isempty(gco) % user pressed closeWindow    
    % set empty return values
    varargout = { [] [] [] [] [] [] };   
    
elseif ~(gco == handles.pushbutton_ok) % user pressed cancel    
    % set empty return values
    varargout = { [] [] [] [] [] [] };    
    
else % user pressed continue
    
    % read input values
        % get selected element from contents
        cont = get(handles.edit_filename, 'String');
        % get file name string
        handles.filename = cont;
        
        % get selected element from contents
        cont = get(handles.popupmenu_xres, 'String');
        this = cont{get(handles.popupmenu_xres, 'Value')};
        % get selected value
        handles.xres = str2num(this);
        
        % get selected element from contents
        cont = get(handles.popupmenu_yres, 'String');
        this = cont{get(handles.popupmenu_yres, 'Value')};
        % get selected value
        handles.yres = str2num(this);
        
        % get selected element from contents
        cont = get(handles.popupmenu_qual, 'String');
        this = cont{get(handles.popupmenu_qual, 'Value')};
        % get selected value
        handles.qual = str2num(this);
    
        % get selected element from contents
        cont = get(handles.popupmenu_fps, 'String');
        this = cont{get(handles.popupmenu_fps, 'Value')};
        % get selected value
        handles.fps = str2num(this);

        % get selected element from contents
        cont = get(handles.popupmenu_comp, 'String');
        this = cont{get(handles.popupmenu_comp, 'Value')};
        % get selected value
        handles.comp = this;
        
        % update handles
        guidata(hObject, handles);        
        
    % return selected values
    varargout{1} = handles.filename;
    varargout{2} = handles.xres;
    varargout{3} = handles.yres;
    varargout{4} = handles.qual;
    varargout{5} = handles.comp;
    varargout{6} = handles.fps;
    
end

% close dialog box
delete(handles.figure1);


function pushbutton_getfile_Callback(hObject, eventdata, handles)
% use uigetfile to request user specifed file
[filename, pathname, filterindex] = uiputfile( ...
           {'*.avi','AVI-files (*.avi)'; ...
            '*.*',  'All Files (*.*)'}, ...
            'Save file as', 'untitled.avi');

% change output value if any file is selected
if filterindex
    % user selected a file
    handles.filename = fullfile(pathname, filename);
    % set string property
    set(handles.edit_filename, 'String', fullfile(pathname, filename));
    % update handles
    guidata(hObject, handles);
else
    % user pressed cancel
    % file name is not changed
end


function pushbutton_ok_Callback(hObject, eventdata, handles)
% resume execution
uiresume(handles.figure1);


function pushbutton_cancel_Callback(hObject, eventdata, handles)
% resume execution
uiresume(handles.figure1);


% --- create functions ---
function popupmenu_comp_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% set popupmenu list
comp_list = {'Indeo3' 'Indeo5' 'Cinepak' 'MSVC' 'RLE' 'None'};
set(hObject, 'String', comp_list);
% set default choice
set(hObject, 'Value', 3);


function popupmenu_fps_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% set popupmenu list
fps_list = {'10' '11' '12' '13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24'};
set(hObject, 'String', fps_list);
% set default choice
set(hObject, 'Value', 6);


function popupmenu_qual_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% set popupmenu list
qual_list = {'65' '70' '75' '80' '85' '90' '95' '100'};
set(hObject, 'String', qual_list);
% set default choice
set(hObject, 'Value', 4);


function popupmenu_xres_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% set popupmenu list
xres_list = {'120' '160' '200' '240' '300' '320' '380' '400' '480' '520' '600' '640' '728' '800' '960' '1024'};
set(hObject, 'String', xres_list);
% set default choice
set(hObject, 'Value', 12);


function edit_filename_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function popupmenu_yres_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
yres_list = {'120' '160' '200' '240' '300' '320' '380' '400' '480' '520' '600' '640' '728' '800' '960' '1024'};
set(hObject, 'String', yres_list);
% set default choice
set(hObject, 'Value', 9);
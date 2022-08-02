function varargout = director(varargin)
% DIRECTOR Tool for creating 3d animations.
%    DIRECTOR(DATA, VRMLFILE) displays the VR world specified by VRMLFILE
%    and opens a graphical user interface. By using TYPEDEF and CREATEVRML
%    the properties of all vessels in the VRMLFILE are ensured to be 
%    compatible with DATA.
%
%    Animation sequences are created by specifying time intervals, viewpoint
%    and time varying vessel properties (translation, rotation and appearance).
%    Animations may be viewed in the installed VRML viewer, or recorded as 
%    AVI files for Matlab independent playback.
%
% See also: CREATEVRML, VERIFYDATA, TYPEDEF.
%
% Author:    Andreas Lund Danielsen
% Date:      10th November 2003
% Revisions: 


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @director_OpeningFcn, ...
                   'gui_OutputFcn',  @director_OutputFcn, ...
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


function director_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for director
handles.output = hObject;
guidata(hObject, handles);

% turn off vr warning: select viewpoint by name
warning off VR:viewpointbyname

% save input to handle structure
    % first input argument is DATA
    handles.data = struct(varargin{1});
    % second input argument is vrml file
    handles.vrml = char(varargin{2});
    handles.vr_h = vrworld(char(varargin{2}));
    % set animation queue if input
    if nargin == 3
        % load input queue
        handles.queue = struct(varargin{3});
        disp('loading queue');

    end
    % set default time
    handles.t = 1;
    % update handels
    guidata(hObject, handles);

% open vr-world and vr figure
open(handles.vr_h);
reload(handles.vr_h);
% display figure and set default properties
handles.vr_fig = vrfigure(handles.vr_h);

% set text, list and figure properties
    % set text field for loaded file and target file
    [pathstr, vrml_file, ext, version] = fileparts(handles.vrml);
    set(handles.edit_loaded_vrml, 'String', [vrml_file ext]);
    
    % set slider min, max and initial value
    end_sample = length(handles.data(1).t);
    set(handles.slider_start, 'Min', 1, 'Max', end_sample, 'Value', 1);
    set(handles.slider_stop, 'Min', 1, 'Max', end_sample, 'Value', end_sample);
    handles.seq.start  = 1;
    handles.seq.stop  = end_sample;
    
    % set edit start and stop
    set(handles.edit_start, 'String', '1');
    set(handles.edit_stop, 'String', num2str(end_sample));
    
    % list viewpoints
    vi_list = view_list(handles.vr_h);
    set(handles.popupmenu_view, 'String', vi_list);
    handles.seq.view = char(vi_list{1});

    % set default speed
    set(handles.edit_speed, 'String', '1');
    handles.seq.speed  = 1;
    
    % set default vessel properties for sequence
    % for all vessels
    for cv = 1:length(handles.data)
        % vessel switch
        handles.seq.vessel(cv).switch = 0;
        handles.seq.vessel(cv).path_start = '1';
        handles.seq.vessel(cv).path_end = num2str( length(handles.data(1).t) ); 
        handles.seq.vessel(cv).path_switch = 0;
        handles.seq.vessel(cv).path_radius = 1;
        handles.seq.vessel(cv).path_color = .4 * rand(1,3) + .2;
        
        % construct list of cell arrays
            % vessel has a name?
            name_str = '<no name>';
            if isfield(handles.data(cv), 'name')
                % add name string
                name_str = handles.data(cv).name;
            end
        vessel_list{cv} = ['Vessel ' num2str(cv) ' : ' name_str];
        
        % switch list
        switch_list = nodes(handles.vr_h);
        n = 1;
        tmp_list{1} = '<nothing>';
        for index = 1:length(switch_list)
            
            % node an inline?
            if strcmp(get(switch_list(index), 'Type'), 'Inline')
            
                % is it child of vessel 'cv'?
                inline_name = get(switch_list(index), 'Name');
                if strcmp(inline_name(end), num2str(cv))
                    n = n + 1;
                    tmp_list{n} = inline_name(1:end-2);
                    
                end % inner if
                
            end % if : inline
            
        end % for : index
        
        handles.seq.vessel(cv).switchlist = tmp_list;
        guidata(hObject, handles);
        
    end
    
% update handles and figure
guidata(hObject, handles);
set(handles.vr_fig, 'Antialiasing', 'off',      'CameraBound', 'on', ...
                    'Headlight', 'on',          'Lighting', 'on', ...
                    'PanelMode', 'off',         'Textures', 'on', ...
                    'Transparency', 'on',       'Wireframe', 'off');
vrdraw(handles.vr_h, handles.seq, handles.data, handles.t);

% set list strings
set(handles.popupmenu_vessel, 'String', vessel_list);
vesselprop(handles.seq.vessel(1), handles);

% vr figure properties
set(handles.vr_fig, 'PanelMode', 'off');


function varargout = director_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function pushbutton_seq_up_Callback(hObject, eventdata, handles)
% determine if choice is valid:
%   there must be more than one sequence in queue and
%   selected sequence may not be the first sequence

% number of sequences in queue
seq_no = length(handles.queue);

% determine action
if seq_no <= 1
    % too few sequences in queue, display warning and exit
    disp('MOVE UP not a valid choice, too few sequences in queue');
elseif get(handles.listbox_seq, 'Value') > 1
    % choice is valid, swap sequences
    this_seq = get(handles.listbox_seq, 'Value');
    prev_seq = this_seq - 1;
    tmp_seq = handles.queue(this_seq);
    handles.queue(this_seq) = handles.queue(prev_seq);
    handles.queue(prev_seq) = tmp_seq;
    % update handles
    guidata(hObject, handles);
    % refresh displayed list
        % get string
        queue_str = get(handles.listbox_seq, 'String');
        % pick the order of the new text
        tmp_line = queue_str(this_seq, :);
        queue_str(this_seq,:) = queue_str(prev_seq,:);
        queue_str(prev_seq,:) = tmp_line;
        % set new sequence numbers
        new_queue_str = recount(queue_str);
        set(handles.listbox_seq, 'String', new_queue_str);
        % move selection value in queue box up
        set(handles.listbox_seq, 'Value', prev_seq);
else
    % selected sequence is already at top of list
    disp('MOVE UP cannot move sequence any further.');
end


function pushbutton_seq_down_Callback(hObject, eventdata, handles)
% determine if choice is valid:
%   there must be more than one sequence in queue and
%   selected sequence may not be the first sequence

% number of sequences in queue
seq_no = length(handles.queue);

% determine action
if seq_no <= 1
    % too few sequences in queue, display warning and exit
    disp('MOVE DOWN not a valid choice, too few sequences in queue');
elseif get(handles.listbox_seq, 'Value') < seq_no
    % choice is valid, swap sequences
    this_seq = get(handles.listbox_seq, 'Value');
    next_seq = this_seq + 1;
    tmp_seq = handles.queue(this_seq);
    handles.queue(this_seq) = handles.queue(next_seq);
    handles.queue(next_seq) = tmp_seq;
    % update handles
    guidata(hObject, handles);
    % refresh displayed list
        % get string
        queue_str = get(handles.listbox_seq, 'String');
        % pick the order of the new text
        tmp_line = queue_str(this_seq, :);
        queue_str(this_seq,:) = queue_str(next_seq,:);
        queue_str(next_seq,:) = tmp_line;
        % set new sequence numbers
        new_queue_str = recount(queue_str);
        set(handles.listbox_seq, 'String', new_queue_str);
        % move selection value in queue box up
        set(handles.listbox_seq, 'Value', next_seq);
else
    % selected sequence is already at top of list
    disp('MOVE DOWN cannot move sequence any further.');
end


function slider_start_Callback(hObject, eventdata, handles)
% get value from slider
value = get(hObject, 'Value');
% call startstop (slider-edit-update) function to update 
% text fields and check start sample vs stop sample
startstop(value, 'start', hObject, handles);


function slider_stop_Callback(hObject, eventdata, handles)
% get value from slider
value = get(hObject, 'Value');
% call startstop (slider-edit-update) function to update 
% text fields and check start sample vs stop sample
startstop(value, 'stop', hObject, handles);


function edit_start_Callback(hObject, eventdata, handles)
% get value from slider
value = str2double(get(hObject, 'String'));
% is entered value a number?
if isnan(value)
    % entered string is not a number, display error and return
    warning('Input value not a number.');
    value = handles.seq.start;
end
% call startstop (slider-edit-update) function to update 
% text fields and check start sample vs stop sample
startstop(value, 'start', hObject, handles);


function edit_stop_Callback(hObject, eventdata, handles)
% get value from slider
value = str2double(get(hObject, 'String'));
% is entered value a number?
if isnan(value)
    % entered string is not a number, display error and return
    warning('Input value not a number.');
    value = handles.seq.stop;
end
% call startstop (slider-edit-update) function to update 
% text fields and check start sample vs stop sample
startstop(value, 'stop', hObject, handles);


function popupmenu_view_Callback(hObject, eventdata, handles)
% get name of chosen viewpoint
list = get(hObject, 'String');
view = list{get(hObject, 'Value')};

% set active viewpoint
set(handles.vr_fig, 'Viewpoint', view);

% update sequence information
handles.seq.view = view;
guidata(hObject, handles);


function edit_speed_Callback(hObject, eventdata, handles)
% save speed input
handles.seq.speed = str2num(get(hObject, 'String'));

% save changes
guidata(hObject, handles);


function pushbutton_delete_Callback(hObject, eventdata, handles)
% read entry to delete from sequence listbox
seq_del = get(handles.listbox_seq, 'Value');

% determine total number of entries in queue
seq_no = length(handles.queue);

% get old string from listbox to initialize new text
new_queue = get(handles.listbox_seq, 'String');

% delete entry from list
% four different cases:
if (seq_del == 1) & (seq_del == seq_no)
    % remove all entries
    handles = rmfield(handles, 'queue');
    new_queue = '                                                                      ';
    % disable pushbutton delete
    set(handles.pushbutton_delete, 'Enable', 'Off');
elseif seq_del == 1
    % remove first entry from queue
    handles.queue = handles.queue(2:seq_no);
    new_queue = recount(new_queue(2:seq_no,:));    
elseif seq_del == seq_no
    % remove last entry from queue
    handles.queue = handles.queue(1:seq_no-1);
    new_queue = recount(new_queue(1:seq_no-1,:));
    set(handles.listbox_seq, 'Value', seq_no-1);
else
    % remove entry from index seq_del, mid-queue
    first = handles.queue(1:seq_del-1);
    last = handles.queue(seq_del+1:seq_no);
    tmp = first;
    tmp(seq_del:seq_no-1) = last;
    handles.queue = tmp;
    first = new_queue(1:seq_del-1,:);
    last = new_queue(seq_del:seq_no-1,:);
    new_queue = recount([first; last]);
end

% set new string in listbox
set(handles.listbox_seq, 'String', new_queue);

% save changes in handle
guidata(hObject, handles)


function pushbutton_add_Callback(hObject, eventdata, handles)
% is there a queue?
if isfield(handles, 'queue')
    % get number of entries in queue
    in_queue = length(handles.queue);
else
    % no queue, set number of entries to zero
    in_queue = 0;
end

% add sequence to queue
handles.queue(in_queue+1) = handles.seq;

% change text in sequence listbox
txt = get(handles.listbox_seq, 'String');
txt(in_queue+1,:) = seq_format(in_queue+1, handles.seq);
set(handles.listbox_seq, 'String', txt);

% enable pushbutton delete
set(handles.pushbutton_delete, 'Enable', 'On');

% save changes in handle
guidata(hObject, handles);


function pushbutton_play_seq_Callback(hObject, eventdata, handles)
% determine if there are any sequnces to play
if isfield(handles, 'queue')
    
    % get sequence from queue
    selected_seq = handles.queue(get(handles.listbox_seq, 'Value'));
    
    % set active viewpoint
    set(handles.vr_fig, 'Viewpoint', selected_seq.view);
    
    % refresh figure
    vrdraw(handles.vr_h, selected_seq, handles.data, handles.t);
    
    % start player
    vrplay(selected_seq, handles.vr_fig, handles.vr_h, handles.data);
    
end % if : isfield


function pushbutton_rec_Callback(hObject, eventdata, handles)
% create avi object
[avi_name, x_res, y_res, quality, comp, fps] = new_avi;
aviobj = avifile(avi_name, 'Quality', quality, ...
                           'Compression', comp, ...
                           'Fps', fps);

% close current vr-figure and open new figure with given resolution,
% this also ensures that the vr-figure is not covered by other windows
close(handles.vr_fig);
position = [0 0 x_res y_res];
handles.vr_fig = vrfigure(handles.vr_h, position);
% update handles
guidata(hObject, handles);
% set vr-figure properties
set(handles.vr_fig, 'Antialiasing', 'off',      'CameraBound', 'on', ...
                    'Headlight', 'on',          'Lighting', 'on', ...
                    'PanelMode', 'off',         'Textures', 'on', ...
                    'Transparency', 'on',       'Wireframe', 'off');

% for all sequences
for seq = 1:length(handles.queue)
    
    % get sequence
    this_seq = handles.queue(seq);
    
    % set active viewpoint
    set(handles.vr_fig, 'Viewpoint', this_seq.view);

    % start player
    vrdraw(handles.vr_h, this_seq, handles.data, handles.t);
    
    % start player
    aviobj = vrrecord(aviobj, fps, this_seq, handles.vr_fig, handles.vr_h, handles.data);
    
end % sequence loop

% close avi object
aviobj  = close(aviobj);


function pushbutton_play_all_Callback(hObject, eventdata, handles)
% for all sequences
for seq = 1:length(handles.queue)
    
    % get sequence
    this_seq = handles.queue(seq);
    
    % set active viewpoint
    set(handles.vr_fig, 'Viewpoint', this_seq.view);

    % start player
    vrdraw(handles.vr_h, this_seq, handles.data, handles.t);
    
    % start player
    vrplay(this_seq, handles.vr_fig, handles.vr_h, handles.data);
    
end % sequence loop


function edit_path_color_Callback(hObject, eventdata, handles)
% get vessel number
cv = get(handles.popupmenu_vessel, 'Value');

% open color gui with old color as argument
new_color = .4 * rand(1,3) + .4;

% update color in director and in sequence
set(hObject, 'BackgroundColor', new_color);
handles.seq.vessel(cv).path_color = new_color;

% update handle and figure
guidata(hObject, handles);
vrdraw(handles.vr_h, handles.seq, handles.data, handles.t);


function edit_path_radius_Callback(hObject, eventdata, handles)
% get vessel number
cv = get(handles.popupmenu_vessel, 'Value');

% get entered radius
new_radius = str2double(get(hObject, 'String'));


% update handle and figure
handles.seq.vessel(cv).path_radius = new_radius;
guidata(hObject, handles);
vrdraw(handles.vr_h, handles.seq, handles.data, handles.t);


function popupmenu_vessel_as_Callback(hObject, eventdata, handles)
% get vessel number
cv = get(handles.popupmenu_vessel, 'Value');

% get selected value
value = get(hObject, 'Value');

% update value, handle and figure
handles.seq.vessel(cv).switch = value - 2;
guidata(hObject, handles);
vrdraw(handles.vr_h, handles.seq, handles.data, handles.t);


function checkbox_path_Callback(hObject, eventdata, handles)
% get vessel number
cv = get(handles.popupmenu_vessel, 'Value');

% get value
value = get(hObject, 'Value');

% disable or enable path properties?
if value status = 'On';
else status = 'Off';
end
    % set availability of properties
    set(handles.edit_path_start, 'Enable', status);
    set(handles.edit_path_end, 'Enable', status);
    set(handles.edit_path_radius, 'Enable', status);
    set(handles.edit_path_color, 'Enable', status);
    set(handles.text_01, 'Enable', status);
    set(handles.text_02, 'Enable', status);
    set(handles.text_03, 'Enable', status);
    set(handles.text_04, 'Enable', status);

% update path value
handles.seq.vessel(cv).path_switch = value - 1;         % vrml starts listing at zero
guidata(hObject, handles);
vrdraw(handles.vr_h, handles.seq, handles.data, handles.t);


function popupmenu_vessel_Callback(hObject, eventdata, handles)
% get vessel number
cv = get(handles.popupmenu_vessel, 'Value');

% set vessel values
vesselprop(handles.seq.vessel(cv), handles);

% update handle
guidata(hObject, handles);


function edit_path_start_Callback(hObject, eventdata, handles)
% get vessel number
cv = get(handles.popupmenu_vessel, 'Value');

% get entered path_start value
expr = get(hObject, 'String');
if isnan(str2double(expr)) & ~strcmp(expr, 't')
    % entered path_start value not a number
    warning('Entered value not valid.');
    set(handles.edit_path_start, 'String', handles.seq.vessel(cv).path_start);
else
    % set new valid value
    handles.seq.vessel(cv).path_start = expr;
    guidata(hObject, handles);
    vrdraw(handles.vr_h, handles.seq, handles.data, handles.t);
end


function edit_path_end_Callback(hObject, eventdata, handles)
% get vessel number
cv = get(handles.popupmenu_vessel, 'Value');

% get entered path_end value
expr = get(hObject, 'String');
if isnan(str2double(expr)) & ~strcmp(expr, 't')
    % entered path_end value not a number
    warning('Entered path_end value not valid.');
    set(handles.edit_path_end, 'String', handles.seq.vessel(cv).path_end);
else
    % set new valid value
    handles.seq.vessel(cv).path_end = expr;
    guidata(hObject, handles);
    vrdraw(handles.vr_h, handles.seq, handles.data, handles.t);
end


function load_ani_Callback(hObject, eventdata, handles)
% open question dialog
choice = questdlg(['Are you sure to load another animation?';
                   'All unsaved changes will be lost!      '], ...
                   'Load?', 'Yes','Cancel','Yes');
% determine action
if strcmp(choice, 'No')
    % do nothing, user abort
else
    % open uigetfile for user to select file
    [filename, pathname, filterindex] = uigetfile( ...
       {'*.mvt', 'All animation files (*.mvt)';
        '*.*',  'All files (*.*)'}, ...
        'Pick a file to load');
    if ~filterindex
        % user pressed cancel, do nothing
    else
        % load specified file
            % create global variables to overload
            global queue vrml data;
            % load file to workspace
            load(fullfile(pathname, filename), '-mat', 'queue', 'vrml', 'data');
            % load variables to handles
            handles.queue = queue;
            handles.vrml  = vrml;
            handles.data  = data;
            % update handles
            guidata(hObject, handles);
       % clear variables from workspace
       clear queue vrml data;
       
       % display message
       disp(['Animation loading from: ' fullfile(pathname, filename)]);
       
       % close this 'director' gui and start new
            % close vrfig and world
            close(handles.vr_fig);
            close(handles.vr_h);
            
            % call new instance of gui
            %    this restarts and refreshes the already existing gui,
            %    therefore no need to close the calling gui
            director(handles.data, handles.vrml);
    
        % refresh listbox
            % reset listbox string
            set(handles.listbox_seq, 'String', '                                                                      ')
            txt = get(handles.listbox_seq, 'String');
            % for all sequences in queue
            for s = 1:length(handles.queue)
                % change text in sequence listbox
                txt(s,:) = seq_format(s, handles.queue(s));
            end
            % update string
            set(handles.listbox_seq, 'String', txt);

    end
end


function save_ani_Callback(hObject, eventdata, handles)
% open uiputfile dialog
[filename, pathname, filterindex] = uiputfile( ...
       {'*.mvt', 'All animation files (*.mvt)';
        '*.*',  'All files (*.*)'}, ...
        'Save animation as');
% user pressed ok or cancel?
if ~filterindex
    % user pressed cancel
    % do nothing
else
    % save animation as mvt file
        % clear any entered extension
        [tmp1, filename_noext, tmp2, tmp3] = fileparts(filename);
        % add 'mvt' extension
        filename = [filename_noext '.mvt'];
        % save filename with extension .mvt
        full_filename = fullfile(pathname, filename);
        % globalize variables
        global queue vrml data;
        queue = handles.queue;
        vrml  = handles.vrml;
        data  = handles.data;
        % save
        save(full_filename, 'queue', 'vrml', 'data');
        
    % clear variables
    clear queue seq vrml data;
        
    % display name of saved animation
    disp(['Animation saved as: ' full_filename]);
    
end


function exit_Callback(hObject, eventdata, handles)
function help_Callback(hObject, eventdata, handles)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% local functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- return struct list of viewpoints ---
function [list] = view_list(vr_world)
% get list of nodes
node_list = nodes(vr_world);

% search list for viewpoints
vc = 0;       % reset viewpoint counter
for n = 1:length(node_list)
    % is entry n in node_list a viewpoint?
    if strcmp(get(node_list(n), 'Type'), 'Viewpoint')
        vc = vc + 1;
        list{vc} = char( get(node_list(n), 'Name') );
    end
end

% set return value if no viewpoint are found
if vc == 0
    list = '<no viewpoints found>';
end


% --- update all start-stop fields ---
function startstop(value, caller, hObject, handles)
% called by start or stop/slider and edit
% round to integer and check range
value = round(value);
% check limits
if value<1
    value = 1;
end
if value>length(handles.data(1).t)
    value = length(handles.data(1).t);
end

% update time
handles.t = value;

% determine who called this function
if strcmp(caller, 'start')
    % called by start
    start_value = round(value);
    stop_value = get(handles.slider_stop, 'Value');
    if start_value>stop_value
        stop_value = start_value;
    end
else
    % called by stop
    stop_value = round(value);
    start_value = get(handles.slider_start, 'Value');
    if start_value>stop_value
        start_value = stop_value;
    end
end

% update all fields with new values
% struct fields
handles.seq.start = start_value;
handles.seq.stop = stop_value;
guidata(hObject, handles);
% gui fields
set(handles.slider_start, 'Value', start_value);
set(handles.slider_stop, 'Value', stop_value);
set(handles.edit_start, 'String', num2str(start_value));
set(handles.edit_stop, 'String', num2str(stop_value));

% call vrdraw to update vrfigure
vrdraw(handles.vr_h, handles.seq, handles.data, handles.t);


% --- format char for sequence listbox ---
function [string] = seq_format(n, sequence)
n = num2str(n);
sta = num2str(sequence.start);
sto = num2str(sequence.stop);
spe = num2str(sequence.speed);
view = char(sequence.view);
string = '                                                                      ';
string(2:1+length(n)) = n;
string(12:11+length(sta)) = sta;
string(23:22+length(sto)) = sto;
string(34:33+length(view)) = view;
string(64:63+length(spe)) = spe;


% --- refresh numbering in sequence listbox ---
function [fresh] = recount(old)
% initialize return variable
fresh = old;
% for all lines in old
for li = 1:size(old)
    % convert new number to char
    new_number = num2str(li);
    % insert new number in fresh
    fresh(li, 2:3+length(new_number)) = [new_number '  '];
end


% --- set vessel properties for current sequence ---
function vesselprop(seq_prop, handles)
% set string: 'display vessel as'
set(handles.popupmenu_vessel_as, 'String', seq_prop.switchlist);
set(handles.checkbox_path, 'Value', seq_prop.path_switch + 1);
set(handles.edit_path_start, 'String', seq_prop.path_start);
set(handles.edit_path_end, 'String', seq_prop.path_end);
set(handles.edit_path_radius, 'String', num2str(seq_prop.path_radius));
set(handles.edit_path_color, 'BackgroundColor', seq_prop.path_color);
set(handles.popupmenu_vessel_as, 'Value', seq_prop.switch + 2);

% set availability of path properties
if ~seq_prop.path_switch status = 'On';
else status = 'Off';
end
set(handles.edit_path_start, 'Enable', status);
set(handles.edit_path_end, 'Enable', status);
set(handles.edit_path_radius, 'Enable', status);
set(handles.edit_path_color, 'Enable', status);
set(handles.text_01, 'Enable', status);
set(handles.text_02, 'Enable', status);
set(handles.text_03, 'Enable', status);
set(handles.text_04, 'Enable', status);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% create functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit_start_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_speed_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function popupmenu_view_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function listbox_seq_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function slider_start_CreateFcn(hObject, eventdata, handles)
set(hObject,'BackgroundColor',[.9 .9 .9]);


function slider_stop_CreateFcn(hObject, eventdata, handles)
set(hObject,'BackgroundColor',[.9 .9 .9]);


function edit_stop_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function popupmenu_vessel_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_path_start_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_path_end_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function popupmenu_vessel_as_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_path_color_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_path_radius_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function edit_loaded_vrml_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
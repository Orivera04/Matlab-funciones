function varargout = typedef(varargin)
% TYPEDEF Link user data to available vessel models.
%    [NEWDATA, WORLD] = TYPEDEF(DATA) displays an interface where vessels 
%    found in DATA may be linked to specific 3D vessel models. These links
%    are returned in NEWDATA for use with CREATEVRML.
%
%    A search for all VRML files (*.wrl) in the folder:
%    'toolbox\mvt\vessel' returns a list of available vessel models.
%    Each vessel in DATA then may be linked to any listed vessel model.
%
%    The required structure of DATA is described and verified by VERIFYDATA.
%    Returned structure NEWDATA equals DATA, but contains the updated links
%    in field 'type'. Returned char array WORLD is the filename of the 
%    scenario file used by CREATEVRML.
%
%    Note: If the field 'type' is already defined for all vessels, and
%    the desired scenario file is known, it's not necessary to run TYPEDEF!
%
%    See toolbox documentation on how to use your own vessel models.
%
% See also: CREATEVRML, VERIFYDATA, DIRECTOR.
%
% Author:   Andreas Lund Danielsen
% Date:     6th November 2003
% Revisions: 


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @typedef_OpeningFcn, ...
                   'gui_OutputFcn',  @typedef_OutputFcn, ...
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


function typedef_OpeningFcn(hObject, eventdata, handles, varargin)
% save input argument in handle structure
handles.data = struct(varargin{1});
guidata(hObject, handles);

% set default properties for objects
    % construct list of vessels
    for cv = 1:length(handles.data)
        % construct list of cell arrays
        % vessel has a name?
        name_str = '<no name>';
        if isfield(handles.data(cv), 'name')
            % add name string
            name_str = handles.data(cv).name;
        end
        vessel_list{cv} = ['Vessel ' num2str(cv) ' : ' name_str];
        
    end
    % set string property for listbox
    set(handles.listbox_vessels, 'String', vessel_list);
    
    % construct list of available vessel models
    type_list = dirlist('vessel', 'wrl');
    type_list = trim(type_list);
    % update text string if any files were found
    if ~isempty(type_list)
        set(handles.listbox_types, 'String', type_list);
        
        % is type defined?
        if isfield(handles.data(cv), 'type')
            % search for an entry where: data(1).type = type_list(n)
            l = 1;
            while (~strcmp(handles.data(1).type, type_list(l)) & (l < length(type_list)))
                l = l + 1;
            end
            % boundary check
            if l == length(type_list)
                l = 1;
            end
        else
            l = 1;
        end
        set(handles.listbox_types, 'Value', l);
        
    else
        % no available vessels !?
        disp('No available vessels.');
        return;
    end
    
    % set temporary return type for all vessels
    if ~isfield(handles.data, 'type')
        for cv = 1:length(handles.data)
            % set type to entry at top of list
            handles.data(cv).type = char(type_list(1));
            guidata(hObject, handles);            
        end
    end

% save lists in handle
handles.vessel_list = vessel_list;
handles.type_list = type_list;
handles.env_list = get(handles.popupmenu_env, 'String');
guidata(hObject, handles);

% wait for user input before returning
uiwait(handles.figure1);


function varargout = typedef_OutputFcn(hObject, eventdata, handles)
% user pressed cancel/close or continue?
if isempty(gco) % user pressed closeWindow
    
    % set empty return values
    varargout = { [] [] };
   
elseif ~(gco == handles.pushbutton_ok) % user pressed cancel
    
    % set empty return values
    varargout = { [] [] };
    
else % user pressed continue
    
    % return target vrml file
    varargout{1} = handles.data;
    
    % return environment vrml file
    tmp = get(handles.popupmenu_env, 'String');
    varargout{2} = tmp{get(handles.popupmenu_env, 'Value')};
        
end

% close dialog box
delete(handles.figure1);


function listbox_vessels_Callback(hObject, eventdata, handles)
% get vessel number and type_list
cv = get(hObject, 'Value');
% update type_list
if ~strcmp(handles.data(cv).type, '')
    % find list index for identical entries
    l = find(strcmp(handles.type_list, handles.data(cv).type));
else
    l = 1;
end

% set new value in listbox_type
set(handles.listbox_types, 'Value', l);
guidata(hObject, handles);


function listbox_types_Callback(hObject, eventdata, handles)
% get type_list value
l = get(hObject, 'Value');
% get current vessel
cv = get(handles.listbox_vessels, 'Value');

% set new value in data(cv)
handles.data(cv).type = char(handles.type_list(l));
guidata(hObject, handles);


function pushbutton_ok_Callback(hObject, eventdata, handles)
% resume execution
uiresume(handles.figure1);


function pushbutton_help_Callback(hObject, eventdata, handles)


function close_typedef(hObject, eventdata, handles)
% delete handle
uiresume(handles.figure1);


%%% create functions %%%
function listbox_types_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function listbox_vessels_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function popupmenu_env_CreateFcn(hObject, eventdata, handles)
if ispc set(hObject,'BackgroundColor','white');
else set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end
% construct environment list
env_list = dirlist('world', 'wrl');
env_list = trim(env_list);
% update text string if any files were found
if ~isempty(env_list)
    set(hObject, 'String', env_list);
end


%%% local functions %%%
% --- remove extensions from list of files ---
function [out] = trim(file_list)
% for all entries
for l = 1:length(file_list)
    % remove ext
    tmp = file_list{l};
    file_list{l} = tmp(1:end-4);
end
out = file_list;
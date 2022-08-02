function varargout = proteinplotexport(varargin)
% PROTEINPLOTEXPORT M-file for proteinplotexport.fig

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.6.6.5 $  $Date: 2004/01/24 09:20:25 $


% Edit the above text to modify the response to help proteinplotexport

% Last Modified by GUIDE v2.5 29-Oct-2003 14:33:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @proteinplotexport_OpeningFcn, ...
    'gui_OutputFcn',  @proteinplotexport_OutputFcn, ...
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



function proteinplotexport_OpeningFcn(hObject, eventdata, handles, varargin) %#ok

handles.output = hObject;

% store the handle for the PROTEINPLOT gui
handles.proteinplotfig = varargin{1}.proteinplotfig;

% center the dialog
centerdlg(handles.proteinplotfig,handles.ppexport);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes proteinplotexport wait for user response (see UIRESUME)
% uiwait(handles.ppexport);


% -------------------------------------------------------------------------------------------
function varargout = proteinplotexport_OutputFcn(hObject, eventdata, handles) %#ok
varargout{1} = handles.output;


% -------------------------------------------------------------------------------------------
function ok_button_Callback(hObject, eventdata, handles) %#ok

ok(handles)

% ------------------------------------------------------------------------------
function ok_button_KeyPressFcn(hObject, eventdata, handles) %#ok

curkey = get(handles.ppexport,'CurrentKey');

if ~any(strmatch(curkey,{'return';'space'}))
    return
end

ok(handles)


% ------------------------------------------------------------------------------
function ok(handles)

% save/export the data
tf = savedata(handles);

% close the gui

if tf
    closeexport(handles)
end


% ------------------------------------------------------------------------------
function cancel_button_Callback(hObject, eventdata, handles) %#ok

% close the gui
closeexport(handles);

% ------------------------------------------------------------------------------
function cancel_button_KeyPressFcn(hObject, eventdata, handles) %#ok
curkey = get(handles.ppexport,'CurrentKey');
if ~any(strmatch(curkey,{'return';'space'}))
    return
end

closeexport(handles);

% ------------------------------------------------------------------------------
function apply_button_Callback(hObject, eventdata, handles) %#ok

% save/export the data
savedata(handles);

% ------------------------------------------------------------------------------
function apply_button_KeyPressFcn(hObject, eventdata, handles) %#ok
curkey = get(handles.ppexport,'CurrentKey');
if ~any(strmatch(curkey,{'return';'space'}))
    return
end

% save/export the data
savedata(handles);

% -------------------------------------------------------------------------------------------
function exportto_popup_CreateFcn(hObject, eventdata, handles) %#ok

set_os_text(hObject);

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% -------------------------------------------------------------------------------------------
function exportto_popup_Callback(hObject, eventdata, handles) %#ok
% determine which entry was selected
ind = get(hObject,'Value');

if ind == 1
    % workspace    
    set(handles.misc_static,'String','Variable')
    set(handles.misclabel_static,'String','Name:')
    set(handles.misc_edit,'String','pp_data')
    set(handles.miscoverwrite_check,'String','Overwrite variable','Visible','on');    
elseif ind == 2
    % MAT-File
    set(handles.misc_static,'String','Variable')
    set(handles.misclabel_static,'String','Name:')
    set(handles.misc_edit,'String','pp_data')
    set(handles.miscoverwrite_check,'Visible','off')    
end

% -------------------------------------------------------------------------------------------
function misc_edit_CreateFcn(hObject, eventdata, handles) %#ok

set_os_text(hObject);

if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% -------------------------------------------------------------------------------------------
function misc_edit_Callback(hObject, eventdata, handles) %#ok


% -------------------------------------------------------------------------------------------
function misclabel_static_CreateFcn(hObject, eventdata, handles) %#ok

set_os_text(hObject);


% -------------------------------------------------------------------------------------------
function misc_static_CreateFcn(hObject, eventdata, handles) %#ok

set_os_text(hObject);

oldunits = get(hObject,'Units');
set(hObject,'Units','characters');
p = get(hObject,'Position');

set(hObject,'Position',[p(1) p(2) 9 p(4)])
set(hObject,'Units',oldunits)



% -------------------------------------------------------------------------------------------
function exportto_static_CreateFcn(hObject, eventdata, handles) %#ok

set_os_text(hObject);

oldunits = get(hObject,'Units');
set(hObject,'Units','characters');
p = get(hObject,'Position');

set(hObject,'Position',[p(1) p(2) 11 p(4)])
set(hObject,'Units',oldunits)

% -------------------------------------------------------------------------------------------
function miscoverwrite_check_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject);


% -------------------------------------------------------------------------------------------
function ok_button_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject);


% -------------------------------------------------------------------------------------------
function cancel_button_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject);


% -------------------------------------------------------------------------------------------
function apply_button_CreateFcn(hObject, eventdata, handles) %#ok
set_os_text(hObject);


% -------------------------------------------------------------------------------------------
function tf = savedata(handles)

tf = true;

val = get(handles.exportto_popup,'Value');
pphandles = guidata(handles.proteinplotfig);

vname = get(handles.misc_edit,'String');    

data = getdata(handles,pphandles);


if val == 1    
    % access the data:
    if isvarname(vname)
        if evalin('base',['exist(''' vname ''')']) ~= 1 || get(handles.miscoverwrite_check,'Value')
            assignin('base',vname,data);
        elseif evalin('base',['exist(''' vname ''')']) == 1
            overwrite=questdlg(['The variable ' vname ' already exists in the base workspace.  Overwrite?'], ...
                'Variable exists', ...
                'No');
            switch overwrite
                case 'Yes'
                    assignin('base',vname,data);
                case {'No','Cancel'}
                    tf = false;
                    return
            end
        end            
    else
        errordlg(['"' vname '" is not a valid variable name.'],'Invalid variable name','modal')
    end
elseif val == 2
    [fname,pname] = uiputfile({'*.mat', 'MAT-file'},'Save as');
    fullfname = fullfile(pname,fname);
    if isvarname(vname)
        eval([vname ' = data;']);        
        save(fullfname,vname)
    else
        errordlg(['"' vname '" is not a valid variable name.'],'Invalid variable name','modal')
    end
end



% ----------------------------------------------------------------
function set_os_text(hObject)
if ispc
    set(hObject,'FontName','MS Sans Serif','FontSize',8)
else
    set(hObject,'FontName','Helvetica','FontSize',10)
end




% -------------------------------------------------------------------------------------------
function closeexport(handles)

close(handles.ppexport)


% ------------------------------------------------------------------------------

function datastruct = getdata(handles,pphandles) %#ok

data = get(pphandles.linehandles,'YData');

if ~iscell(data)
    data = {data};
end

datastruct = struct('Property',pphandles.propnames,'Data',data');

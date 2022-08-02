function miniproject(cmd)
%MINIPROJECT  An interface tool for loading/saving a MATLAB project.
%   A MATLAB project encapsulates the current MATLAB
%   session including:
%    -Open figures
%    -Base workspace variables
%    -M-path
%    -Dynamic java path (R14 only)
%
%   Example:
%      % Create a figure, variables, modify path
%      plot(1:10);
%      myvar1 = 'hello';
%      myvar2 = 'world';
%      addpath('D:/Work');
%
%      % Save work as a MATLAB Project
%      miniproject
%      File->Save New Project
%      
%      % Restart MATLAB and Reload Project
%      miniproject
%      File->Load Existing Project
%

localShowUI;

%------------------------------------------------%
function localShowUI

hFig = getappdata(0,'miniprojectFigure');

if ~isempty(hFig) && ishandle(hFig)
    return;
end

fig.NumberTiTle = 'off';
fig.Name = ' Mini-Project Manager';
fig.Toolbar = 'none';
fig.Menubar = 'none';
fig.Units = 'Pixels';
fig.IntegerHandle = 'off';
fig.HandleVisibility = 'off';

fig.Resize = 'off';
fig.Position = [200 200 300 100];
u.Figure= figure(fig);

s.HandleVisibility = 'off';
s.Label = 'File';
s.Tag = 'File';
s.Parent = u.Figure;
u.File = uimenu(s);

s.Label = 'Save Work As New Project';
s.Tag = 'NewProject';
s.Parent = u.File;
u.NewProject = uimenu(s);

s.Label = 'Open Existing Project';
s.Tag = 'OpenProject';
u.OpenProject = uimenu(s);

s.Label = 'Save Current Project';
s.Tag = 'SaveCurrentProject';
u.SaveCurrentProject = uimenu(s);

s.HandleVisibility = 'off';
s.Label = 'Edit';
s.Tag = 'Edit';
s.Parent = u.Figure;
u.Edit = uimenu(s);

s.Parent = u.Edit;
s.Label = 'M-Path';
s.Tag = 'EditMPath';
u.MPath = uimenu(s);

ui.Units = 'norm';
ui.Position = [.02 0  1 .9];
ui.Style = 'text';
ui.BackgroundColor = get(u.Figure,'Color');
ui.Parent = u.Figure;
ui.FontSize = 11;
ui.String = localCreateMessage('Untitled','',0,0);
ui.HorizontalAlignment = 'Left';
u.Text = uicontrol(ui);

set(u.File,'Callback',{@localCallback,u});
set(u.NewProject,'Callback',{@localCallback,u});
set(u.OpenProject,'Callback',{@localCallback,u});
set(u.SaveCurrentProject,'Callback',{@localCallback,u});
set(u.Edit,'Callback',{@localCallback,u});
set(u.MPath,'Callback',{@localCallback,u});

setappdata(0,'miniprojectFigure',u.Figure);

%------------------------------------------------%
function localCallback(obj,evd,udata)

hFig = udata.Figure;
tag = get(obj,'tag');

switch(tag)
    case 'NewProject'
       localSaveNew(hFig);
    case 'OpenProject'
       localOpen(hFig);
    case 'SaveCurrentProject'
       localSaveCurrent(hFig)
    case 'EditMPath'
       pathtool
end

drawnow;
info=localGetAppData(hFig);

% Update menu items depending on whether a current project exists
if ~isempty(info.ProjectName) && ~isempty(info.ProjectPath)

    set(udata.Text,'String',...
        localCreateMessage(info.ProjectName,info.ProjectPath,info.SavedFigures,info.SavedVariables));
    set(udata.SaveCurrentProject,'Enable','on');
else
    set(udata.SaveCurrentProject,'Enable','off');
end
        
            
%------------------------------------------------%
function localSaveNew(hFig)

info=localGetAppData(hFig);

% Show save project dialog
[filename, pathname] = uiputfile('*.mproj', 'Save MATLAB Project as');
 
if isempty(filename) || isequal(filename,0)
    return;
end

[pathstr,proj_name,ext,ver] = fileparts(filename);
if isempty(proj_name) || length(proj_name)<1
    return;
end
    
filename = [proj_name,'.mproj'];

% Save project
[n_figs, n_vars] = local_save_project(pathname,proj_name);

% Update appdata
info.ProjectName = proj_name;
info.ProjectPath = pathname;
info.SavedFigures = n_figs;
info.SavedVariables = n_vars;
localSetAppData(hFig,info);

%------------------------------------------------%
function localOpen(hFig)

info=localGetAppData(hFig);

[filename, pathname] = uigetfile('*.mproj', 'Load MATLAB Project');
 
if isempty(filename) || isequal(filename,0)
    return;
end

[pathstr,proj_name,ext,ver] = fileparts(filename);

if length(proj_name)<2
    return;
end

if ~strcmp(ext,'.mproj')
   errordlg('Invalid Project File','MATLAB Project Manager');
   return;
end

[n_figs, n_vars] = local_load_project(pathname,proj_name);

% Update appdata
info.ProjectName = proj_name;
info.ProjectPath = pathname;
info.SavedFigures = n_figs;
info.SavedVariables = n_vars;
localSetAppData(hFig,info);

%------------------------------------------------%
function localSaveCurrent(hFig)

info=localGetAppData(hFig);

doNewProject = true;
if ~isempty(info)
   if isfield(info,'ProjectName') && ~isempty(info.ProjectName)
       [n_figs, n_vars] = local_save_project(info.ProjectPath,info.ProjectName);
       
       % Update appdata
       info.SavedFigures = n_figs;
       info.SavedVariables = n_vars;
       localSetAppData(hFig,info);
       
       doNewProject = false;
   end
end

if doNewProject
  localSaveNew(hFig)    
end

%------------------------------------------------%
function [n_figs, n_vars] = local_load_project(file_dir, proj_name)

n_figs = 0;
n_vars = 0;
proj_path = file_dir;

% Load project file
proj_file = [proj_path,filesep,proj_name,'.mproj'];
data = load(proj_file,'-mat');

if isfield(data,'info')
    info = data.info;
else
    error('Invalid project file');
end

% Set m-path
if isfield(info,'mpath')
   path(info.mpath);
end

% Set java-path
% if isfield(info,'jpath') && strcmp(version('-release'),'14')
%    javaclasspath(info.jpath);
% end
 
% Set root properties
if isfield(info,'root')
   props = fieldnames(info.root);
   for n = 1:length(props)
     try,
        set(0,props{1},getfield(info.root,props{1}));
     end
   end
end

% Load ws data
data_file = [proj_path,filesep,proj_name,'.mat'];
if exist(data_file,'file')
   cmd = ['load(''',data_file,''')'];
   evalin('base',cmd);
   n_vars = evalin('base','length(whos)');
end

% Load figure files
fig_file = [proj_path,filesep,proj_name,'.fig'];
if exist(fig_file,'file')
    fig_handles = [];
    try,
       fig_handles = hgload(fig_file);
    end
    n_figs = length(fig_handles);
end

%------------------------------------------------%
function [n_figs, n_vars] = local_save_project(file_dir, proj_name,hFig)

proj_path = [file_dir];

% Save all hg figures
fig_handles = findobj(0,'type','figure');
n_figs = length(fig_handles);
if ~isempty(fig_handles)
  fig_file = [proj_path,filesep,proj_name,'.fig'];
  hgsave(fig_handles,fig_file);
end

% Save workspace
ws_file = [proj_path,filesep,proj_name,'.mat'];
cmd = ['save(''',ws_file,''')'];
evalin('base',cmd);
n_vars = evalin('base','length(whos)');

% Save m-path
info.mpath = path;

% % Save java dynamic path (R14)
%if strcmp(version('-release'),'14')
%    info.jpath = javaclasspath('-dynamic');
%end

% Save root properties
info.root = get(0);

path_file = [proj_path,filesep,proj_name,'.mproj'];
save(path_file,'info','-mat');

%------------------------------------------------%
function str = localCreateMessage(name,filepath,n_figs,n_vars)

if n_figs==0
    n_figs_str = '';
else
    n_figs_str = num2str(n_figs);
end

if n_vars==0
    n_vars_str = '';
else
    n_vars_str = num2str(n_vars);
end

str = {['    Project: ',name],...
       ['    Location: ',filepath],...
       ['    Figures: ',n_figs_str],...
       ['    Variables: ',n_vars_str]};

%------------------------------------------------%
function info = localGetAppData(hFig)

info = getappdata(hFig,'miniproject');
if isempty(info)
   info.ProjectName = '';
   info.ProjectPath = '';
   info.SavedFigures = 0;
   info.SavedVariables = 0;
   info.MostRecentName = {};
   info.MostRecentPath = {};
   
% ToDo: Later   
%    if ispref('miniproject','data')
%           data = getpref('miniproject','data');
%           try,
%             info.MostRecentName = data.MostRecentName;
%             info.MostRecentPath = data.MostRecentPath;
%           end
%    end
end

%------------------------------------------------%
function localSetAppData(hFig,info)

setappdata(hFig,'miniproject',info);

if ~ispref('miniproject','data')
   addpref('miniproject','data',info);    
else
   setpref('miniproject','data',info);
end




function featnode = importstrategy( featnode, mdlfile, blockname )
%IMPORTSTRATEGY Imports a Simulink model into a feature
%
%  FEATNODE = IMPORTSTRATEGY( FEATNODE, <MDLFILE>, <BLOCKNAME> )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 08:22:53 $ 

CGBH = cgbrowser;
d=CGBH.getViewData;

if ~isempty(d) && ~isempty(d.sys) && ishandle(d.sys)
    try
        bdclose(d.sys);
    end
end


if nargin==1
    filename = i_choosesystem;
    if isnumeric( filename) && (filename==0)
        return;
    end
else
    % we were given a file name
    filename = mdlfile;
end

[path, name] = fileparts( filename );
if isempty(path)
    path = pwd;
end

try
    % now need to load that file
    % we can't load_system with the fullpath,
    % need to cd to the directory first, and then load the model
    originaldir = cd( path );
    load_system( name );
    cd(originaldir);
    sys=get_param(name,'handle');
catch
    i_error(sprintf('Couldn''t open Simulink model %s\n%s\n', name, lasterr));
    i_resetPointer( CGBH );
    return
end
if strcmp(get_param(sys,'Lock'),'on')
    i_error('CAGE cannot parse locked library files');
    close_system(sys,0);
    i_resetPointer( CGBH );
    return
end

set([d.Handles.LibMenu d.Handles.ParseMenu],'enable','on');

% Create a SL window the same size and position as the display frame
browserWidth = 160;
slpos=[170 20 500 300];
set_param(sys,'modelbrowservisibility','on',...
    'modelbrowserwidth',browserWidth,...
    'autozoom','on',...
    'toolbar','off',...
    'statusbar','off',...
    'location',slpos,...
    'zoomfactor','fitsystem',...
    'closefcn','Callbacks(cgfeaturenode,''i_SLClose'',[],[]);');

% make each outport blue, with correct openfcn
blocks=find_system(sys,'findall','on','lookundermasks','all',...
    'Type','block');
openfcn='Callbacks(cgfeaturenode,''i_SLUpdate'',[],[]);';
for i=1:length(blocks)
    set_param(blocks(i),'userdata','');
    if strcmp(get_param(blocks(i),'BlockType'),'Outport')
        set_param(blocks(i),'openfcn',openfcn,'backgroundcolor','blue');
    end
end

% try and parse only available block
try
    if nargin==3
        block = find_system(sys,'searchdepth',1,'BlockType','Outport', 'Name', blockname);
        button = 'Automatic';
    else
        block = find_system(sys,'searchdepth',1,'BlockType','Outport');
        if length(block) == 1
            name = get_param(block,'name');
            if strcmp(lower(name(1:3)),'out')
                button = questdlg('There is only one importable signal at the top level of this strategy. Automatically import this signal or manually choose another from the diagram', ...
                    'Import Strategy', ...
                    'Automatic','Manual','Automatic');
            else
                button = questdlg([name,' is the only importable signal at the top level of this strategy. Automatically import this signal or manually choose another from the diagram'], ...
                    'Import Strategy', ...
                    'Automatic','Manual','Automatic');
            end
        end
    end
    if strcmp(button,'Automatic')
        d.sys = get_param(sys,'handle');
        CGBH.setViewData(d);
        featnode = readstrategy(featnode, sys, block);
        try
            bdclose(sys);
        end
        d.sys = [];
        CGBH.setViewData(d);
        i_resetPointer( CGBH );
        return
    end
end

d.sys = get_param(sys,'handle');
i_resetPointer( CGBH );
set_param(sys,'open','on');
d = pMessage(d, 'Double click on a blue outport to parse the required strategy');
CGBH.setViewData(d);

%--------------------------------------------------------------------------
function filename = i_choosesystem
%--------------------------------------------------------------------------
filename = [];
curdir = pwd;
AP= mbcprefs('mbc');
FileDefaults = getpref(AP,'PathDefaults');
if ~isempty(FileDefaults.cagedatafiles) & exist(FileDefaults.cagedatafiles,'dir')
    cd(FileDefaults.cagedatafiles);
end
[filename,path]=uigetfile('*.mdl','Choose Simulink strategy file...');
cd(curdir);
if isa(filename,'double')
    %Cancel was pushed
    return
else
    if ~exist(path,'dir')
        return
    end
    filename = fullfile(path, filename);
end

%---------------------------------------------------------------------------------------
function i_resetPointer( CGBH )
%---------------------------------------------------------------------------------------
if CGBH.GUIExists
    set(CGBH.Figure,'pointer','arrow');
end

%---------------------------------------------------------------------------------------
function i_error(str)
%---------------------------------------------------------------------------------------
CGBH = cgbrowser;
if CGBH.GUIExists
    uiwait(errordlg(str,'CAGE Error','modal'));
else
    error( 'mbc:importstrategy:FailedToImportStrategy', str );
end

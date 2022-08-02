function [obj, out] = gui_import( obj )
%GUI_IMPORT Import data from a file
%
%  [IN, CALINFO] = GUI_IMPORT(IN)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:49:19 $

% the default return argument
out = [];

% get all the input functions
[fcns, extensions, fileFlags] = getinputfunctions(obj);

% set up the description and function cell arrays
FileDescrip = cell(0, 2);
FileFcn = cell(0, 2);
nonFileDescrips = cell(0, 1);
nonFileFcn = cell(0,1);
nonFileDescrips{1} = 'Load from File';

% construct the display strings
for i = 1:length(fcns)
    fStr = strrep(fcns{i},'_',' ');
    fStr(1) = upper(fStr(1));
    if fileFlags(i)
        rowind = size( FileDescrip, 1 ) + 1;
        FileDescrip{rowind, 1} = sprintf( '%s', extensions{i} );
        FileDescrip{rowind, 2} = sprintf( '%s (%s)', fStr, extensions{i} );
        FileFcn{rowind} = fcns{i};
    else
        rowind = size( nonFileDescrips, 1 ) + 1;
        nonFileDescrips{rowind} = sprintf( 'Load from %s', fStr );
        nonFileFcn{rowind} = fcns{i};
    end
end

if length( nonFileDescrips ) > 1
    % we have some database(?) types - allow user to choose between load from
    % file and load from these other sources
    [selection,OK] = mv_listdlg('Name','Import Calibration data',...
        'PromptString','Select calibration source',...
        'SelectionMode','single',...
        'ListString',nonFileDescrips);    
    % make sure the listdlg has been removed
    drawnow;
    if (OK && selection>1)
        % we have a nonFileType
        obj.inputFcn = nonFileFcn{selection};
        out = import( obj );
        return;
    elseif ~OK
        return;
    end
end

% if we are still going, then it must mean a file type
[ok, fname, fcn] = i_selectFile(FileDescrip, FileFcn);
if (ok)
    obj.filename = fname;
    obj.inputFcn = fcn;
    out = import( obj );
end

% --------------------------------------------------
function [ok, fname, fcn] = i_selectFile(FileDescrip, FileFcn)
% 

fcn = [];
fname = [];
ok = true;

% Set default directory
AP= mbcprefs('mbc');
FileDefaults = getpref(AP,'PathDefaults');
if ~isempty(FileDefaults.cagedatafiles) && exist(FileDefaults.cagedatafiles,'dir')
    startpth = FileDefaults.cagedatafiles;
else
    startpth = pwd;
end
[Filename,Pathname, TypeIdx] = uigetfile(FileDescrip, 'Import Calibration data', startpth);

if isnumeric(Filename)
    % User pressed cancel
    ok = false;
    return
end

fcn = FileFcn{TypeIdx};
fname = fullfile(Pathname, Filename);

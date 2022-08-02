function [MP, msg] = LoadMBCProject(MP, filename)
%LOADMBCPROJECT
% 
%  [MP, MSG] = LOAD(MP, FILENAME)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:03:37 $

% Default output
msg = '';
% Really want to ensure that filename is a fully qualified path
filename = i_ensureFullyQualifiedPath(filename);
oldFilename = MP.Filename;
% Is the requested file really a project file
[fileOK, varList] = isProjectFile(MP, filename);
% Do we think we have a sporting chance of loading the project
if ~fileOK | strcmp(varList.class, 'struct')
    msg = 'File not found or invalid format.';
    return;
end
% Let's try and get a lock on the file we want to open
[MP, msg] = RegisterFile(MP, filename);
if ~isempty(msg)
    return
end
% Change the warning state to off and reset the last error
ws = warning('off');
lasterr('');
% Load the file
S = struct2cell(load(filename , '-mat'));
newMP = S{1};
% Reset the warning state
warning(ws);
% Did we get a new project - if not need to clean up a bit of mess
if isempty(newMP) | ~isa(newMP,'mdevproject')
    % Deal with the file registration
    UnregisterFile(MP, filename);
    MP = RegisterFile(MP, oldFilename);
    % What went wrong
    [mnemonic, component, msg] =  mbcGetLastError;
    if isempty(msg)
        msg = 'Invalid or corrupt file';
    end
    return
end
% Make sure that the previously loaded file is unregistered
UnregisterFile(MP, oldFilename);
newMP = RegisterFile(newMP, filename);
% Delete the previous project
delete(MP);
MP = newMP;

% ------------------------------------------------------------------------------
%
% ------------------------------------------------------------------------------
function filename = i_ensureFullyQualifiedPath(filename)
% Break into constituents
[path, file, ext] = fileparts(filename);
% Has it got a sensible path
if isempty(path)
    filename = [pwd filesep file ext];
end

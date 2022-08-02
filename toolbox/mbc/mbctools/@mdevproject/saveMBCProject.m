function [MP, msg] = SaveMBCProject(MP, filename)
%SAVEMBCPROJECT save MBCmodel project to file
% 
% [MP, MSG] = SaveMBCProject(MP);
% save with new file name
% [MP, MSG] = SaveMBCProject(MP, MBCProjectFile); 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:06:48 $

% Default output
msg = '';
% Get the latest copy from the heap
MP = info(MP);
% Default previous filename 
oldFilename = '';
NEW_FILENAME = false;
% Have we been given a filename
if nargin < 2
    filename = MP.Filename;
elseif ~strcmp(filename, MP.Filename)
    % Indicate that we need to deal with registration correctly and retain
    % the current filename
    NEW_FILENAME = true;
    oldFilename = MP.Filename;    
end
% Really want to ensure that filename is a fully qualified path
filename = i_ensureFullyQualifiedPath(filename);
% Is anyone using the new filename - note this modifies the internal
% Filename property of the project.
if NEW_FILENAME
    [MP, msg] = RegisterFile(MP, filename);
    % Did we encounter any errors whilst trying to register the file
    if ~isempty(msg)
        % Return early because we couldn't lock the new file
        return
    end
end
% OK - lets try and save the project
try
    save('-mat', filename, 'MP');
catch
    % Eeeekkkk - something bailed during save. Need to remove the new lock
    % we created and restore the old one
    UnregisterFile(MP, filename);
    MP = RegisterFile(MP, oldFilename);
    msg = 'File write error. The file you are trying to save may be read-only.';
    return
end
% Finally we need to remove the old lock and indicate that the project has
% just been saved
UnregisterFile(MP, oldFilename);
MP.Modified = false;
xregpointer(MP);


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

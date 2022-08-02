function [MP, msg] = RegisterFile(MP, File);
%REGISTERFILE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:03:13 $

% Default output message
msg = '';
% Get the constituents of the new filename
[newPath, newFile, ext] = fileparts(File); 
% Create the temp filename
tmpFilename = [newPath filesep '~' newFile '.tmp'];
% Get the current username
currentUser = getusername(initfromprefs(mbcuser));
% Check the existance of the temporary file
if exist(tmpFilename, 'file')
    % Try loading it as a mat-file
    try
        S = load('-mat', tmpFilename);
    catch
        msg = ['Lock file of unknown format : ' tmpFilename];
        return
    end
    % Does it contain a variable called 'User' that isn't the currentUser
    if isfield(S, 'User')
        % Note that if the currentUser is the User in the temp file then we
        % drop through the code without a message being generated
        if ~strcmp(S.User, currentUser)
            msg = ['File is currently being used by ',S.User];
        end
    else 
        msg = 'File is currently being used by an unknown user';
    end
    % Was there a suitable lock on the file and hence we can't contine?
    if ~isempty(msg)
        return
    end
else
    try
        User = currentUser;
        save(tmpFilename, 'User', '-mat');
    catch
        msg = 'Error creating temporary file: file may be on a read-only drive';
        return
    end
end

% Ensure that the project filename and name are up-to-date
MP.Filename = File;
MP = name(MP, newFile);
% Ensure that the Project is up-to-date
xregpointer(MP);
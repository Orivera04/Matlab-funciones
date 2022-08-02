function WorkDir = getModelAssistantWorkDir
% get temp working directory of Model Assistant

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:14 $

if isunix
    [status uid] = system('whoami');
    uid = strrep(uid, sprintf('\n'), '');
    WorkDir = fullfile(tempdir, uid, 'ModelAssistant');
else
    WorkDir = fullfile(tempdir, 'ModelAssistant');
end
if ~exist(WorkDir)
    [parentDir subDir] = fileparts(WorkDir);
    mkdir(parentDir, subDir);
end


% create temporary directory
function createWorkingDir
% Get a unique temporary directory name
testdir = tempname;
seps = findstr(testdir,filesep);
testdir = [testdir(1:seps(end)) 'search_' testdir(seps(end)+1:end) ];
while exist( testdir )
    testdir = tempname;
    seps = findstr(testdir,filesep);
    testdir = [testdir(1:seps(end)) 'search_' testdir(seps(end)+1:end)];
end
% Make the directory & go there, save current directory.
[status,msg]=mkdir(tempdir,strrep(testdir,tempdir,''));
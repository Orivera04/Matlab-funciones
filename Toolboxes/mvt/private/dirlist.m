function [out] = dirlist(folder, extension)
% DIRLIST Returns a cell array file names.
%    LIST = DIRLIST(FOLDER, EXTENSION) returns a cell array of file names
%    with specified EXTENSION in the folder:
%    matlabroot [filesep] toolbox [filesep] visual [filesep] FOLDER.
%
% See also DIR, FULLFILE.
%
% Author:    Andreas Lund Danielsen
% Date:      5th November 2003
% Revisions: 

% initiate return value
out = {};

% verify input of class char
if ~isa([folder extension], 'char')
    % input not of class char
    out = {};
    err = 'Input error, must be of class char';
    warning('VISUAL:DirList_InputArgumentError', err);
    return;
end

% construct full file names of input
folder = fullfile(matlabroot, 'toolbox', 'mvt', folder, '');

% verify folder name
if exist(folder) == 7
    list = dir(folder);
else
    % folder not found
    out = {};
    err = ['Folder not found: ' folder];
    warning('VISUAL:DirList_FolderNotFound', err);
    return;
end

% get list of files, list is struct
list = dir([folder '\*.' extension]);

% success, set return values
% convert from complete struct to a Nx1 cell array
out = {list.name}';
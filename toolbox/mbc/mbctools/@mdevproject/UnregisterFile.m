function MP = UnregisterFile(MP, filename);
%UNREGISTERFILE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

% $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:03:14 $

if nargin < 2
    filename = MP.Filename;
end
% Get the path to the current file
[P, F, E] = fileparts(filename);
% Create temporary filename
tmpFilename = [P filesep '~' F '.tmp'];
% Check that the temp file exists (not sure why the path cannot be empty -
% doesn't seem to be unreasonable to have an empty path)
if ~isempty(P) & exist(tmpFilename, 'file')
    try
        delete(tmpFilename);
    catch
        warning('mbc:mbcproject:UnknownError', 'Unable to delete the temporary lock file : %s', tmpFilename);
    end
end
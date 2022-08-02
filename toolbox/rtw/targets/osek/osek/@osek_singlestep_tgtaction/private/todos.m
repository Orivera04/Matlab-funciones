% Function : todos
% 
% Abstract :
%   Converts a directory name with spaces in it into
%   a old dos compatible directory name.
%

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.2.4.1 $  $Date: 2004/04/19 01:30:47 $
function path = todos(path)

% If needs translate into DOS 8.3 format
if (any(isspace(path)) ~= 0)
    % Get the trans2dos utility executable
    trans2dos = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', ...
    'osek', 'common', 'tools', 'win32', 'trans2dos.exe');

    if (exist(trans2dos) == 0)
        error(['trans2dos is unavailable. Path contains space: ' path '. Unable to translate file path']);    
    else
        [status, path ] = dos([trans2dos ' "' path '"']);
        path = strtok(path);
    end
end


function [filename, filetype] = getfile(h, filename)
%GETFILE Find and check the data filename extension.
%   [FILENAME, FILETYPE] = GETFILE(H, FILENAME) checks the FILENAME to see
%   if it has a valid filename extension.  If it has, returns the filename
%   as well as the file type. Otherwise, the returned FILENAME and FILETYPE
%   are empty.
%
%   [FILENAME, FILETYPE] = GETFILE(H) allows the user to select a file and
%   then checks the filename.  If it is valid, returns the filename as well
%   as the file type. Otherwise, the returned FILENAME and FILETYPE are
%   empty.
%
%   H is the RFDATA.DATA object. FILENAME is a string, representing the
%   filename of a .SNP, .YNP, .ZNP, .HNP or .AMP file.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:16 $

% Set the default.
filetype = '';

% Get the filename
if nargin == 1 || (nargin == 2 && isempty(filename))
    % Ask user to select a file.
    [filename, pathname] = uigetfile({'*.s*p;*.S*P','SNP Files (*.s*p)';...
        '*.amp;*.AMP','AMP Files (*.amp)';...
        '*.s2d;*.S2D','S2D Files (*.s2d)';...
        '*.y*p;*.Y*P','YNP Files (*.y*p)';...
        '*.z*p;*.Z*P','ZNP Files (*.z*p)';...
        '*.h*p;*.H*P','HNP Files (*.h*p)';...
        '*.*p;*.*P;*.s2d;*.S2D','All RF Files (*.*p,*.s2d)';...
        '*.*','All Files (*.*)'},...
        'Select an RF network parameters file');
    if isequal(filename,0) || isequal(pathname,0)
        return;
    end
    filename = fullfile(pathname, filename);
end

% Check the filename.
if ~ischar(filename)
    error(['The file name must be a string.']);
end

file_ext = fliplr(strtok(fliplr(filename), '.'));
if length(file_ext) < 3
    error(['The filename extension must be SNP,YNP,ZNP,HNP,S2D or AMP.']);
end

% Check the filename extension.
if strncmpi(filename(end-2:end), 'amp', 3)
    filetype = 'AMP';
elseif strncmpi(filename(end-2:end), 'flp', 3)
    filetype = 'FLP';
elseif strncmpi(filename(end-2:end), 's2d', 3)
    filetype = 'S2D';
elseif strncmpi(filename(end), 'p', 1)
    switch upper(file_ext(1))
        case 'S'
            filetype = 'SNP';
        case 'Y'
            filetype = 'YNP';
        case 'Z'
            filetype = 'ZNP';
        case 'H'
            filetype = 'HNP';
        otherwise
            error(['The filename extension must be SNP,YNP,ZNP,HNP,S2D or AMP.']);
    end
else
    error(['The filename extension must be SNP,YNP,ZNP,HNP,S2D or AMP.']); 
end

% Check if the file exists.
if ~exist(filename, 'file')
    error(['The file: ', filename, ' not found.']);
end

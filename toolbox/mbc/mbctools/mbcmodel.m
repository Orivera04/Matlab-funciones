function varargout = mbcmodel(varargin)
%MBCMODEL Start the Model Browser GUI
%
%  The Model Browser is a GUI that lets you build and explore the
%  properties of experimental designs and complex regression models.
%
%  MBCMODEL starts the Model Browser GUI or brings an existing Model
%  Browser to the front of the screen.
%
%  MBCMODEL FILENAME starts the Model Browser and loads the file specified
%  by FILENAME.
%
%  See also CAGE, MBCCONFIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.7 $  $Date: 2004/04/04 03:32:44 $

% Ensure that the model browser isn't already running
fh = findall(0,'tag','mvModelBrowser');
if ~isempty(fh)
    % bring old session to foreground
    figure(fh);
    % If a filename is given, have to load it
    if nargin
        % load a file
        MBH = MBrowser;
        MBH.OpenProject(varargin{1});
    end
    return
end

try
    % mbc_startup does all the work
    mbc_startup( 'mbcmodel', varargin{:} );
catch
    % Filter out known possible errors that it might be useful for the user
    % to see.  Other errors will be presented as undiagnosed run time
    % problems.
    e = lasterror;
    switch e.identifier
        case {'mbc:mbc_startup:NoJVM', ...
                'mbc:mbc_startup:ActiveXError', ...
                'mbc:mbc_startup:InitializationFailed'}
            % Strip off initial line of error that contains "Error using ..."
            dispstr = regexprep(e.message, sprintf('Error using.*\n'), '');
        otherwise
            dispstr = 'An unknown error occurred during the startup of the Model Browser.';
    end
    uiwait(errordlg(dispstr, 'MBC Toolbox', 'modal')); 
end

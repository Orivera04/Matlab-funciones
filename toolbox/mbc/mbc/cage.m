function varargout = cage(varargin)
%CAGE Start the Cage Browser GUI
%
%  The Cage Browser is a GUI that lets you work with engine models and ECU
%  strategies to build high quality calibrations.
%
%  CAGE starts the Cage Browser GUI or brings an existing Cage Browser to
%  the front of the screen.
%
%  CAGE FILENAME starts the Cage Browser and loads the file specified by
%  FILENAME.
%
%  See also MBCMODEL, MBCCONFIG.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.4.4 $  $Date: 2004/02/09 06:48:25 $

% Ensure that the cage browser isn't already running
fh=findall(0,'tag','cgbrowser');
if ~isempty(fh)
    % Bring old session to foreground
    figure(fh)
    if nargin
        cgb = cgbrowser;
        cgb.openproject(varargin{1});
    end
    return
end

try
    % mbc_startup does all the work
    mbc_startup( 'cage', varargin{:} );
catch
    % Filter out known possible errors that it might be useful for the user
    % to see.  Other errors will be presented as undiagnosed run time
    % problems.
    e = lasterror;
    switch e.identifier
        case {'mbc:mbc_startup:NoJVM', ...
                'mbc:mbc_startup:ActiveXError', ...
                'mbc:mbc_startup:InitializationFailed'}
            % Strip of initial line of error that contains "Error using ..."
            dispstr = regexprep(e.message, sprintf('Error using.*\n'), '');
        otherwise
            dispstr = 'An unknown error occurred during the startup of the CAGE Browser.';
    end
    uiwait(errordlg(dispstr, 'MBC Toolbox', 'modal')); 
end

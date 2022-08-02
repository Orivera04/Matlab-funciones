% MPC555_LAUNCH_DOWNLOADER
%
% MPC555_LAUNCH_DOWNLOADER(FILE_NAME, BOOTCODEDOWNLOAD, USEFLASHPROGRAMMER)
%
% FILE_NAME             - The name of the S-Record to download
% BOOTCODEDOWNLOAD      - if true then this is a bootcode download
%                       - if false then this is a standard download
% USEFLASHPROGRAMMER    - if true then use the bdm flash programmer
%                         if false assume either a CCP kernel on the target
%                         or a manual reset
% Abstract :
%   Launch the embedded_target_download GUI, ready to install
%   an application on the processor
%

%  Copyright 2003-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.6 $
%  $Date: 2004/04/29 03:40:07 $ 
function mpc555_launch_downloader(fname, bootcodeDownload, useFlashProgrammer)

if nargin < 1 
	fname = '';
end

if nargin < 2
    % not a bootcode download by default
	bootcodeDownload = logical(0);
end

if nargin < 3
    % default - standard CAN / Serial download
    % without BDM
    useFlashProgrammer = 0;
end

prefs = RTW.TargetPrefs.load('mpc555.prefs');
try
	prefs.validate;
catch
	uiwait(errordlg(lasterr,'Target Preference Error'));
	prefs.gui;
	return;
end

switch (useFlashProgrammer)
   case {'Yes' 1 }
      disp('Launching the BDM debugger and executing download kernel');
      % Set the flash_programmer_ram application
      tgtaction('run','exe',mpc5xx_get_flash_programmer);
      % Raise the command window
      commandwindow;
   case { 'No' 0 }
   otherwise
       error('Unknown value for useFlashProgrammer!');
end;

import('com.mathworks.toolbox.ecoder.canlib.CanDownload.*');

% use the download tool in commandline mode                  
embedded_target_download('commandline');                   

if isempty(fname)
    % no filename specified
    switch (useFlashProgrammer)
        case {'Yes' 1}
            % Use Case: Download Flash Application via BDM
        
            % using flash programmer => flash application
            embedded_target_download('set','DownloadType', char(StandaloneMPC555Control.FLASH_APPLICATION_CODE));
        case {'No' 0}
            % Use Case: Launch Download Control Panel
        
            % RAM is the most common option
            embedded_target_download('set','DownloadType', char(StandaloneMPC555Control.RAM_APPLICATION_CODE));
        otherwise
            error('Unknown value for useFlashProgrammer!');
    end
else
    % Use Case: Install Bootcode

    % filename specified               
	if ~isempty(regexp(fname,'_flash\.s19'))
		embedded_target_download('set','DownloadType', char(StandaloneMPC555Control.FLASH_APPLICATION_CODE));
	elseif ~isempty(regexp(fname,'_ram\.s19'))
		embedded_target_download('set','DownloadType', char(StandaloneMPC555Control.RAM_APPLICATION_CODE));
    else
        % no support for other filenames
        error('Could not determine application type from filename!');
	end
	embedded_target_download('set','DownloadFilename', fname);
end

% if this is a bootcode download
% disable checking of the bootcode version so that it can be updated!
if bootcodeDownload
    embedded_target_download('set','IgnoreBootcodeVersion',logical(1));
end

% display the gui
embedded_target_download('showgui');

% Display a warning about the BDM connection
switch (useFlashProgrammer)
    case {'No' 0}
        % we only need to show the warning once per session
        persistent show_warning;

        if isempty(show_warning)
            warndlg(['Please make sure either a CAN or Serial cable is connected between the host and target.'...
                 '   Additionally, make sure the BDM connection to the target board is not active.'], 'Download Control Panel Connections'); 
            show_warning = 0;
        end
    case {'Yes' 1}
    otherwise
        error('Unknown value for useFlashProgrammer');
end
end

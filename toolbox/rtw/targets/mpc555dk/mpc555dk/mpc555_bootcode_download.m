% File : mpc555_bootcode_download
%
% Abstract :
%   Launch the embedded_target_download GUI, ready to install
%   the bootcode on the target processor.
%

%  Copyright 2003-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.5 $
%  $Date: 2004/04/19 01:26:51 $ 
   
prefs = RTW.TargetPrefs.load('mpc555.prefs');
try
	prefs.validate;
catch
	uiwait(errordlg(lasterr,'Target Preference Error'));
	prefs.gui;
	return;
end

% display warning about potential dangers of CAN / Serial download

[pathstr,name,ext,versn] = fileparts(mfilename('fullpath'));
file = fullfile(pathstr,'bootcodewarn.txt');
warningmessage = textread(file,'%s','delimiter','\n');

options.Interpreter='tex';
options.Default = 'Cancel';


answer = questdlg(warningmessage, 'MPC5XX Bootcode Downloader', 'Yes', 'No', 'Cancel', options);

% always a bootcode download
bootcodeDownload = logical(1);

switch (lower(answer))
    case 'yes'
        useFlashProgrammer = 1;
    case 'no'
        useFlashProgrammer = 0;
    otherwise
        return;
end;

% download
mpc555_launch_downloader(mpc5xx_get_bootcode, bootcodeDownload, useFlashProgrammer);



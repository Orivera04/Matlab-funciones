function opensoundcontrol()
% OPENSOUNDCONTROL open the Windows Volume Control Panel
% 
%  OPENSOUNDCONTROL open the Windows Volume Control Panel for
%  control the Volume at Presentations, Videos and all attached Devices to 
%  Volume. 

%% AUTHOR    : Frank Gonzalez-Morphy 
%% $DATE     : 27-Jun-2002 09:39:26 $ 
%% $Revision : 1.00 $ 
%% FILENAME  : opensoundcontrol.m 

if ~ispc
    error('  :: Sorry, these is only under Windows supported !')
end

try
    dos('sndvol32.exe &');
catch
    error([' Couldn''t open SNDVOL32.EXE. Error in', mfilename])
end

% ===== EOF ====== [opensoundcontrol.m] =====  


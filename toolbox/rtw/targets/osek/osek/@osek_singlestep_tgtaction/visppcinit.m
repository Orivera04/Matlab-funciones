function visppcinit(obj)
% VISPPCINIT is function for initializing the visionPROBE for use
% with the phyCORE-MPC555. 

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.3.4.2 $  $Date: 2004/03/21 22:58:24 $
  
  localVISPPCinit;
  
function output = localVISPPCinit
% TVISPPCINIT is function for initializing the visionPROBE for use
% with the phyCORE-MPC555. 

  output = [];
  
% Check that target preferences are set up
  sdsExe    = osektgtaction('osekprivate','getsdsexe');
  sdsExe    = osektgtaction('osekprivate','todos', sdsExe{1});
  
  if isempty(regexp(sdsExe,'visppc'))
    error('Preferences are not setup for SingleStep with vision');
  end

  % construct command to invoke visppc
  sdsWSPfile = localGetWSPfile;
  sdsRAMscr  = localCREATEvisppcInitCommands;

  sdsArgs   = [];
  sdsArgs   = [sdsArgs ' -r ' ];
  sdsArgs   = [sdsArgs ' ' sdsRAMscr];
  sdsArgs   = [sdsArgs ' -S ' sdsWSPfile];
  sdsCmd    = ['start ' sdsExe{1} ' ' sdsArgs];

  disp(['Execute SingleStep as: ' sdsCmd]);
  [s,w] = system(sdsCmd);
return

function file = localGetWSPfile()
  [path,file,ext]=fileparts(mfilename('fullpath'));
  file = fullfile(path, 'visppcinit.wsp');

function file = localCREATEvisppcInitCommands()
% A FUNCTION TO CREATE THE SINGLESTEP COMMAND FILE FOR A MODEL.

  % get other pieces required to invoke visppc
  osekPrefs     = osek.prefs.load('osek.prefs');
  debugSwitches = osekPrefs.ToolChain.DebuggerSwitches;

  regFile = fullfile(matlabroot, 'toolbox', 'rtw', 'targets', 'osek','osek','@osek_singlestep_tgtaction','rtw_phycore555.reg');

  debugCmd = ['debug ' debugSwitches ' -T -'];
  
  fileName = 'visppcinit.cfg';
  fid = fopen(fileName,'w');
  fprintf(fid, 'echo \n');
  fprintf(fid, 'echo visionPROBE initialization\n');
  fprintf(fid, 'echo \n');
  fprintf(fid, '\n');
  fprintf(fid, '%s\n',[debugCmd]);
  fprintf(fid, '\n');
  fprintf(fid, 'alias _config ''''\n');
  fprintf(fid, 'if ( "$status" == "1" ) then\n');
  fprintf(fid, ' echo \n');
  fprintf(fid, ' echo Failed to connect to visionPROBE using SingleStep command\n');
  fprintf(fid, ' echo\n');
  fprintf(fid, ' echo -b -- \\tdebug -V MPC555 -p visionPROBE:LPT1 -T -\n');
  fprintf(fid, ' echo\n');
  fprintf(fid, ' echo Work through the SingleStep with vision documentation to \n');
  fprintf(fid, ' echo resolve this error.\n');
  fprintf(fid, ' echo\n');
  fprintf(fid, 'else\n');
  fprintf(fid, ' echo \n');
  fprintf(fid, ' echo When the SingleStep prompt returns...\n\n');
  fprintf(fid, ' echo Cycle power on the phyCORE-MPC555 (no reset will suffice) \n');
  fprintf(fid, ' echo then type reset at the SingleStep prompt. Having the  \n');
  fprintf(fid, ' echo SingleStep prompt return again with no intervening \n');
  fprintf(fid, ' echo error message suggests the this process has succeeded.\n');
  fprintf(fid, ' echo \n');
  fprintf(fid, '%s','vsh -f ');
  fwrite(fid, regFile);
  fprintf(fid, '\n');
  fprintf(fid, 'endif\n');
  fclose(fid);

  file = fullfile(pwd,fileName);  

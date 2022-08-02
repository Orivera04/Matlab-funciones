function visppcinit(obj)
% VISPPCINIT is function for initializing the visionPROBE for use
% with the MPC5xx. 

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/19 01:26:42 $
  
  localVISPPCinit(obj);
  
function output = localVISPPCinit(obj)
% TVISPPCINIT is function for initializing the visionPROBE for use
% with the MPC5xx. 

  output = [];
  
% Check that target preferences are set up
  sdsExe    = getsdsexe(obj);
  
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
  sdsCmd    = ['start ' sdsExe ' ' sdsArgs];

  disp(['Execute SingleStep as: ' sdsCmd]);
  [s,w] = system(sdsCmd);
return

function file = localGetWSPfile()
  file = fullfile(local_dir, 'visppcinit.wsp');

function fileName = localCREATEvisppcInitCommands()
% A FUNCTION TO CREATE THE SINGLESTEP COMMAND FILE FOR A MODEL.

  % get other pieces required to invoke visppc
  prefs = RTW.TargetPrefs.load('mpc555.prefs');
  debugSwitches = prefs.ToolChainOptions.DebuggerSwitches;

% select MPC555, MPC565 etc.
    switch prefs.TargetBoard.ProcessorVariant
    case '555'
      variant = '-V MPC555';
      tar = '555';
    case '561'
      variant = '-V MPC561';
      tar = '561';
    case '562'
      variant = '-V MPC561';
      tar = '561';
    case '563'
      variant = '-V MPC563';
      tar = '563';
    case '564'
      variant = '-V MPC563';
      tar = '563';
    case '565'
      variant = '-V MPC565';
      tar = '565';
    case '566'
      variant = '-V MPC565';
      tar = '565';
    otherwise
       error('Unknown variant');
    end;

    % check that debugOpts does not already contain a -V
    % processor option
    index = strfind(debugSwitches, '-V');
    if ~isempty(index) 
      error('SingleStep debugger option, -V, found in debugger options.  Please remove this option.');
    end;

  % no longer use a reg file
  % regFile = fullfile(local_dir,'visppcinit.reg');

  debugCmd = ['debug ' variant ' ' debugSwitches ' -T -'];
  
  fileName = fullfile(tempdir, 'visppcinit.cfg');  
  fid = fopen(fileName,'w');
  fprintf(fid, 'echo \n');
  fprintf(fid, 'echo visionPROBE initialization\n');
  fprintf(fid, 'echo \n');
  fprintf(fid, 'alias _config ''''\n');
  fprintf(fid, '\n');
  fprintf(fid, '%s\n',[debugCmd]);
  fprintf(fid, '\n');

  % NOTE:  if ("$status... line must come immediately after the 
  % debugCmd is executed, since $status returns the status of the last
  % command!
  
  fprintf(fid, 'if ( "$status" == "1" ) then\n');
  fprintf(fid, ' echo \n');
  fprintf(fid, ' echo Failed to connect to visionPROBE using SingleStep command\n');
  fprintf(fid, ' echo\n');
  fprintf(fid, ' echo -b -- \\tdebug %s %s -T -\n', variant, debugSwitches);
  fprintf(fid, ' echo\n');
  fprintf(fid, ' echo Work through the SingleStep with vision documentation to \n');
  fprintf(fid, ' echo resolve this error.\n');
  fprintf(fid, ' echo\n');
  fprintf(fid, 'else\n');
  fprintf(fid, ' echo \n');
  fprintf(fid, ' echo When the SingleStep prompt returns...\n\n');
  fprintf(fid, ' echo Cycle power on the phyCORE-MPC555\n');
  fprintf(fid, ' echo then type reset at the SingleStep prompt. Having the \n');
  fprintf(fid, ' echo SingleStep prompt return again with no intervening \n');
  fprintf(fid, ' echo error message suggests the this process has succeeded.\n');
  fprintf(fid, ' echo \n');
  
  %% No longer use a Reg File
  %fprintf(fid, '%s','vsh -f ');
  %fwrite(fid, regFile);
  %fprintf(fid, '\n');
 
  % select correct target
  fprintf(fid, ' vsh CF TAR %s\n', tar);
  % hardware breakpoints
  fprintf(fid, ' vsh CF SB IHBC\n');
  % clear VisionProbe NVM registers
  fprintf(fid, ' vsh SC GRP ERASE\n');
  % IMMR needs to be configured
  fprintf(fid, ' vsh SCGA SIU IMMR 0000027E FFFF0000 SIU /no_addr /cpur /va_dr /sa:0\n');
  % don't need the group enabled
  fprintf(fid, ' vsh CF GRP SIU DISABLED\n');
  
  fprintf(fid, 'endif\n');
  fclose(fid);


function ld = local_dir
    ld = fileparts(which('diab_tgtaction'));

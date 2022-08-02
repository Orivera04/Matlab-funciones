function setup_osekworks_phycorebsp()
% SETUP_OSEKWORKS_PHYCOREBSP creates a phycore-mpc555 board support package into
% a OSEKWorks directory tree. Also creates a batch-file that can be executed
% from CMD window to build the phycore-mpc555 BSP.
%  
% The Target Preferences must be setup for OSEKWorks prior to running this file.
%

% Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.3.4.2 $  $Date: 2004/04/19 01:31:06 $

  % Get OSEKWorks root directory from Target Preferences
  try
    prefs = RTW.TargetPrefs.load('osek.prefs');
  catch
    error(lasterr);
  end
  if ~strcmp(deblank(lower(prefs.Implementation)), 'osekworks')
    disp('Please setup Target Preferences for OSEKWorks installation and rerun.');
    return;
  end
  
  bspRootDir = fullfile(prefs.ImpPath, 'target','osekworks');
  if ~exist(bspRootDir,'dir')
    disp(['''',bspRootDir,'''',sprintf('\n'),' does not appear to be a valid path,',...
          ' please update Target Preferences.']);
    return;
  else
    disp(['Ready to create Phytec BSP into directory tree:',sprintf('\n'),...
          '''',bspRootDir,'''']);
    answer = input('Do you want to continue?([y]/n):','s');
    if ~strcmp(deblank(lower(answer)),'y') && ~isempty(deblank(answer))
      disp('Exiting ''setup_osekworks_phycorebsp'', no changes were made.');
      return;
    end
  end

  %% Clean out previous phycore BSP (can't use /Y as NT doesn't support it)
  bspDstDir = fullfile(bspRootDir,'bsp','ppc','phycore555');
  if exist(bspDstDir,'file')
    [status, output] = system(['del /S /Q /F ', bspDstDir]);
    if status
      disp([output, sprintf('\n'),'Deletion of previous phycore555 BSP failed.']);
      return;
    end
  end
  bspDstDir = fullfile(bspRootDir,'sys','oilfiles','ppcphycore555.oil');
  if exist(bspDstDir,'file')
    [status, output] = system(['del /S /Q /F ', bspDstDir]);
    if status
      disp([output, sprintf('\n'),'Deletion of previous phycore555 BSP failed.']);
      return;
    end
  end
  bspDstDir = fullfile(bspRootDir,'sys','oilfiles','ppcphycore555_def.oil');
  if exist(bspDstDir,'file')
    [status, output] = system(['del /S /Q /F ', bspDstDir]);
    if status
      disp([output, sprintf('\n'),'Deletion of previous phycore555 BSP failed.']);
      return;
    end
  end
  
  
  %% Copy over axiomcme555 BSP files into phycore555 dir, don't use /Y as NT doesn't support it
  bspSrcDir = fullfile(bspRootDir,'bsp','ppc','axiomcme555');
  bspDstDir = fullfile(bspRootDir,'bsp','ppc','phycore555');
  [status, output] = system(['xcopy ',bspSrcDir,' ',bspDstDir,' /E /R /I']);
  if status
    disp([output, sprintf('\n'),'setup of phycore555 BSP failed, unable to copy files.']);
    return;
  end
  bspSrcDir = fullfile(bspRootDir,'sys','oilfiles','ppcaxiomcme555.oil');
  bspDstDir = fullfile(bspRootDir,'sys','oilfiles','ppcphycore555.oil');
  [status, output] = system(['copy ',bspSrcDir,' ',bspDstDir]);
  if status
    disp([output, sprintf('\n'),'setup of phycore555 BSP failed, unable to copy files.']);
    return;
  end
  bspSrcDir = fullfile(bspRootDir,'sys','oilfiles','ppcaxiomcme555_def.oil');
  bspDstDir = fullfile(bspRootDir,'sys','oilfiles','ppcphycore555_def.oil');
  [status, output] = system(['copy ',bspSrcDir,' ',bspDstDir]);
  if status
    disp([output, sprintf('\n'),'setup of phycore555 BSP failed, unable to copy files.']);
    return;
  end
  disp('Successfully copied BSP files into OSEKWorks tree...');

  %% Change oscillator frequency in board.h and divider in systimer.c
  bspChangeFile = fullfile(bspRootDir,'bsp','ppc','phycore555','src','include','board.h');
  fid = fopen(bspChangeFile,'r+');
  fileContents = fread(fid, '*char')';
  fileContents = regexprep(fileContents,'OSCM\s+\d+','OSCM   20000000');    
  frewind(fid);
  fwrite(fid, fileContents, 'char');
  fclose(fid);
  bspChangeFile = fullfile(bspRootDir,'bsp','ppc','phycore555','src','rtc','systimer.c');
  fid = fopen(bspChangeFile,'r+');
  fileContents = fread(fid, '*char')';
  fileContents = regexprep(fileContents,'OSCM\s*/\s*\d+','OSCM/16');    
  frewind(fid);
  fwrite(fid, fileContents, 'char');
  fclose(fid);
  %% Change inclusion to phycore in _def.oil
  bspChangeFile = fullfile(bspRootDir,'sys','oilfiles','ppcphycore555_def.oil');
  fid = fopen(bspChangeFile,'r+');
  fileContents = fread(fid, '*char')';
  fileContents = regexprep(fileContents,'ppcaxiomcme555','ppcphycore555');
  frewind(fid);
  fwrite(fid, fileContents, 'char');
  fclose(fid);
  %% Change FPU setup in begin.s
  bspChangeFile = fullfile(bspRootDir,'bsp','ppc','phycore555','src','utilities','begin.s');
  fid = fopen(bspChangeFile,'r+');
  fileContents = fread(fid, '*char')';
  fileContents = regexprep(fileContents,'ori\s+r3\s*,\s*r3\s*,\s*[0-9A-Fa-fXx]+','ori     r3,r3,0x3102');
  frewind(fid);
  fwrite(fid, fileContents, 'char');
  fclose(fid);
  %% Change various register setups in procinit.s
  bspChangeFile = fullfile(bspRootDir,'bsp','ppc','phycore555','src','utilities','procinit.s');
  fid = fopen(bspChangeFile,'r+');
  fileContents = fread(fid, '*char')';
  % SIUMCR
  fileContents = regexprep(fileContents,'(LA\s+r3\s*,\s*)[0-9A-Fa-fXx]+([^\n]*\s*stw\s+r3\s*,\s*SIUMCR\s*\(\s*r18\s*\))',...
                           '$1 0x00020000 $2','tokenize');
  % PLPRCR
  fileContents = regexprep(fileContents,'(LA\s*r3\s*,\s*)[0-9A-Fa-fXx]+([^\n]*\s*stw\s+r3\s*,\s*PLPRCR\s*\(\s*r18\s*\))',...
                           '$1 0x00014000 $2','tokenize');
  % Allow CS to be setup
  fileContents = regexprep(fileContents,'(\.ifdef\s*)(FLASHSUPPORT)([^\n]*)',...
                           ['        $2 = 1',sprintf('\n'),'$1$2$3'],'tokenize');
  % Disable CS0
  fileContents = regexprep(fileContents,'\s*stw\s+r\d\s*,\s*BR0\s*\(\s*r18\s*\)',...
                           [sprintf('\n'),'   LA     r3,0x00000000',sprintf('\n'),'   stw     r3,BR0(r18)']);
  fileContents = regexprep(fileContents,'\s*stw\s+r\d\s*,\s*OR0\s*\(\s*r18\s*\)',...
                           [sprintf('\n'),'   LA     r3,0x00000000',sprintf('\n'),'   stw     r3,OR0(r18)']);
  % Enable CS1
  fileContents = regexprep(fileContents,'\s*stw\s+r\d\s*,\s*BR1\s*\(\s*r18\s*\)',...
                           [sprintf('\n'),'   LA     r3,0x00000001',sprintf('\n'),'   stw     r3,BR1(r18)']);
  fileContents = regexprep(fileContents,'\s*stw\s+r\d\s*,\s*OR1\s*\(\s*r18\s*\)',...
                           [sprintf('\n'),'   LA     r3,0xffc00000',sprintf('\n'),'   stw     r3,OR1(r18)']);
  % Disable CS2
  fileContents = regexprep(fileContents,'\s*stw\s+r\d\s*,\s*BR2\s*\(\s*r18\s*\)',...
                           [sprintf('\n'),'   LA     r3,0x00000000',sprintf('\n'),'   stw     r3,BR2(r18)']);
  fileContents = regexprep(fileContents,'\s*stw\s+r\d\s*,\s*OR2\s*\(\s*r18\s*\)',...
                           [sprintf('\n'),'   LA     r3,0x00000000',sprintf('\n'),'   stw     r3,OR2(r18)']);
  frewind(fid);
  fwrite(fid, fileContents, 'char');
  fclose(fid);
  %% Lastly, change linker command file to provide a FLASHable/RAMable map for phyCORE-MPC555 and other examples
  bspChangeFile = fullfile(bspRootDir,'bsp','ppc','phycore555','src','bsp.lk');
  fid = fopen(bspChangeFile,'r+');
  fileContents = fread(fid, '*char');
  fileContents = regexprep(fileContents,'\n\s*ram_as_rom\s*:[^\n]*','');
  newmaps = [sprintf('\n'),...
             '    /* This linker file shows some examples of different memory    ',sprintf('\n'),...
             '     * maps that can be chosen. The default map can be used for    ',sprintf('\n'),...
             '     * either a FLASHable image or loading into RAM.               ',sprintf('\n'),...
             '     * The naming convention is to call the read-only sections     ',sprintf('\n'),...
             '     * "ram_as_rom" and the read/write sections "ram".             ',sprintf('\n'),...
             '     *****************************************************/        ',sprintf('\n'),...
             '     /* DEFAULT memory map: Put "ram_as_rom" region at address:    ',sprintf('\n'),...
             '        0 + 0x2000(account for above vector table). This map allows',sprintf('\n'),...
             '        placement in either on-chip FLASH or external RAM          ',sprintf('\n'),...
             '        depending upon FLEN bit in IMMR. Note, to use external RAM,',sprintf('\n'),...
             '        CS1 is setup using BR1/OR1 registers in the procinit.c     ',sprintf('\n'),...
             '        function of the BSP, but when FLEN is 1, the processor     ',sprintf('\n'),...
             '        ignores this and maps addresses 0 to 0x2fbfff to on-chip   ',sprintf('\n'),...
             '        flash. Additionally, "ram" is placed in on-chip RAM(26KB)  ',sprintf('\n'),...
             '        to allow image to be used from RAM or FLASH. */            ',sprintf('\n'),...
             '     ram_as_rom: org = 0x2000,    len = 0x3e000                    ',sprintf('\n'),...
             '     ram       : org = 0x3f9800,  len = 0x6800                     ',sprintf('\n'),...
             '                                                                   ',sprintf('\n'),...
             '     /* 256K(0x40000) Off-chip RAM memory map, divided evenly      ',sprintf('\n'),...
             '        between "ram_as_rom" and "ram" sections.                   ',sprintf('\n'),...
             '     ram_as_rom: org = 0x2000,    len = 0x1e000                    ',sprintf('\n'),...
             '     ram       : org = 0x20000,  len = 0x20000*/                   ',sprintf('\n'),...
             '                                                                   ',sprintf('\n'),...
             '     /* 1MB(0x100000) Off-chip RAM memory map, divided evenly      ',sprintf('\n'),...
             '        between "ram_as_rom" and "ram" sections. Also, ensure      ',sprintf('\n'),...
             '        solder connections on J18 of phycore daughter board        ',sprintf('\n'),...
             '        are setup per Table 5 in Phycore manual.                   ',sprintf('\n'),...
             '     ram_as_rom: org = 0x2000,   len = 0x7e000                     ',sprintf('\n'),...
             '     ram       : org = 0x80000,  len = 0x80000 */                  ',sprintf('\n')];
  fileContents = regexprep(fileContents,'\n\s*ram\s*:[^\n]*',newmaps);
  frewind(fid);
  fwrite(fid, fileContents, 'char');
  fclose(fid);

  % Create batch-file for building phycore-mpc555 BSP and place it in src dir
  bspBuildDir = fullfile(bspRootDir,'bsp','ppc','phycore555','src');
  cmdFile = fullfile(bspBuildDir,'phycore_make.bat');
  cmdFileFid = fopen(cmdFile,'wt');
  if cmdFileFid == -1
    disp(['Unable to create batch-file: ''', cmdFile,''' check permissions.']);
    return;
  end
  fprintf(cmdFileFid, '@echo off\n');
  fprintf(cmdFileFid, '@set WIND_BASE=%s\n', prefs.ImpPath);
  fprintf(cmdFileFid, '@set WIND_HOST_TYPE=x86-win32\n');
  fprintf(cmdFileFid, '@set WIND_KERNEL=OSEKWorks\n');
  diabRoot = fullfile(prefs.ImpPath,'host','diab','4.4b');
  fprintf(cmdFileFid, '@set DIABLIB=%s\n', diabRoot);
  osekworks = fullfile(prefs.ImpPath,'target','osekworks');
  fprintf(cmdFileFid, '@set OSEKWORKS=%s\n', osekworks);
  path = getenv('Path');
  owpath1 = fullfile(prefs.ImpPath,'host','x86-win32','bin;');
  if ~isempty(strfind(path,owpath1)) owpath1 = ''; end
  owpath2 = fullfile(prefs.ImpPath,'host','license;');
  if ~isempty(strfind(path,owpath2)) owpath2 = ''; end
  owpath3 = fullfile(prefs.ImpPath,'host','diab','4.4b','WIN32','bin;');
  if ~isempty(strfind(path,owpath3)) owpath3 = ''; end
  fprintf(cmdFileFid, '@set Path=%s%s%s%s\n', owpath1, owpath2, owpath3, path);
  
  makeCmd = fullfile(prefs.ImpPath,'host','x86-win32',...
                         'bin', 'make');
  fprintf(cmdFileFid, '%s %%1\n', makeCmd);
  fclose(cmdFileFid);
  disp('Successfully created ''phycore_make.bat''...');
  
  if isempty(getenv('LM_LICENSE_FILE'))
    disp(['Environment variable LM_LICENSE_FILE not defined,',...
         'but needed for OSEKWorks, unable to build BSP.']);
    return;
  end

  answer = input('Do you want to build the BSP now?([y]/n):','s');
  if strcmp(deblank(lower(answer)),'y') || isempty(deblank(answer))
    savedPWD=pwd;
    try
      cd(bspBuildDir);
      [status, output] = system('phycore_make clean');
      disp(output);
      if status
        disp('''phycore_make clean'' failed.');
        cd(savedPWD);
        return;
      end
      [status, output] = system('phycore_make all');
      disp(output);
      if status
        disp('''phycore_make all'' failed.');
        cd(savedPWD);
        return;
      end
    end
    cd(savedPWD);
  else
    disp(['Yon can build the phycore555 bsp from the directory:',...
          sprintf('\n'),'  ''',bspBuildDir,'''',sprintf('\n'),...
          'by running the batch-file:',...
          sprintf('\n'),'  ''phycore_make all''']);
  end
  disp('Finished setup of phycore555 BSP.');

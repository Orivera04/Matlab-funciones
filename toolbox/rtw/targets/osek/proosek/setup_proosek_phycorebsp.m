function setup_proosek_phycorebsp()
% SETUP_PROOSEK_PHYCOREBSP copies phycore-mpc555 board support package into a
% ProOSEK directory tree. 
%  
% The Target Preferences must be setup for ProOSEK prior to running this file.
%

% Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.3.4.1 $  $Date: 2004/04/19 01:31:10 $

  % Get Proosek root directory from Target Preferences
  try
    prefs = RTW.TargetPrefs.load('osek.prefs');
  catch
    error(lasterr);
  end
  if ~strcmp(deblank(lower(prefs.Implementation)), 'proosek')
    disp('Please setup Target Preferences for Proosek installation and rerun.');
    return;
  end
  
  bspSrcDir = fullfile(matlabroot, 'toolbox','rtw','targets','osek','proosek','boards');
  bspDstDir = fullfile(prefs.ImpPath, 'boards');
  if ~exist(bspDstDir,'dir')
    disp(['''',bspDstDir,'''',sprintf('\n'),' does not appear to be a valid path,',...
          ' please update Target Preferences.']);
    return;
  else
    bspsToCopy = dir(bspSrcDir);
    tempDirs = [];
    for i=1:length(bspsToCopy)
      if isempty(regexp(bspsToCopy(i).name,'^\..*$'))
	tempDirs = [tempDirs ' ' bspsToCopy(i).name];
      end
    end
    disp(['Ready to copy BSPs,' tempDirs ', into directory tree:',sprintf('\n'),...
          '''',bspDstDir,'''']);
    answer = input('Do you want to continue?([y]/n):','s');
    if ~strcmp(deblank(lower(answer)),'y') && ~isempty(deblank(answer))
      disp('Exiting ''setup_proosek_phycorebsp'', no changes were made.');
      return;
    end
  end
  
  % Get set of directories that need to be copied from toolbox to ProOSEK.
  local_dir = fileparts(mfilename('fullpath'));
  boards_files = dir(fullfile(local_dir,'boards',''));
  copy_dirs = [];
  for i = 1:length(boards_files)
    if boards_files(i).isdir && ~strncmp(boards_files(i).name,'.',1)
      copy_dirs = [copy_dirs {boards_files(i).name}];
    end
  end

  % Remove pre-existing directories, otherwise xcopy would prompt
  % for file replacement. (NT and Win2k are not compatible here)
  for i = 1:length(copy_dirs)
    delDir = fullfile(bspDstDir,copy_dirs{i});
    [status, output] = system(['del /S /Q /F ',delDir]);
  end;
  
  % Copy over phycore BSP files into Proosek tree
  [status, output] = system(['xcopy ',bspSrcDir,' ',bspDstDir,' /E /R']);
  if status
    disp([output, sprintf('\n'),'setup of phycore555 BSP failed, unable to copy files.']);
    return;
  else
    disp('Successfully copied BSP files into Proosek tree...');
  end

  disp('Finished setup of phycore555 BSP.');









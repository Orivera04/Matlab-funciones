function varargout = hc12_tgtaction(srcMCPProjectPathAndFile,varargin)
% HC12_TGTACTION 
% Invoke CodeWarrior with any of the following
% target actions: 'run', 'build', or 'download'.
% Input args: dstMCPProjectPathAndFile is defined as the path and file
% name of the destination (copy to) directory and CodeWarrior .mcp project file. 

% Copyright 2002-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $
% $Date: 2004/03/30 13:13:23 $

% Argument handling
errmsg = [];

switch nargin
  case 0
    errmsg = [' Requires an action argument.'];
  otherwise
    action = varargin{1};
end

if isempty(action)
  action='empty';
end

disp(['### Target action: ', action])

switch lower(action)
  %
  % Permitted actions:
  case 'codegenonly'
    dstMCPProjectPathAndFile = duplicateProject(srcMCPProjectPathAndFile); 

  case {'build','download','run'}
    %
    dstMCPProjectPathAndFile = duplicateProject(srcMCPProjectPathAndFile);   
    
    % Invoke CodeWarrior via "cwautomation_hc12" and load the CodeWarrior
    % .mcp project stationery from: usersWorkingDir\<modelname>_hc12rt\.  
    disp(['### Invoking CodeWarrior with ', upper(action),' action.'])
    [pathStr,name,ext,versn]=fileparts(dstMCPProjectPathAndFile);
    rtwlibPathAndFileStr=[pathStr,filesep,'rtwlib.mcp'];
    disp(['### Library project file: ',rtwlibPathAndFileStr])
    
    % --------- (start) Enable conditional resuse of rtwlib.lib -----------
    hc12Prefs = RTW.TargetPrefs.load('hc12.prefs');
    hc12_temp_dir = hc12Prefs.ProjectStationery.StaticLibraryDirectory;

    % From "PurelyIntegerCode" flag, determine which rtwlib is needed.
    rtwOptsStr = get_param(gcs,'RTWOptions');
    pat = 'PurelyIntegerCode=';
    [s,f,x]=regexp(rtwOptsStr,pat);
    purelyIntegerCodeStr = rtwOptsStr(s:f+1);
    eval([purelyIntegerCodeStr,';']);
    % PurelyIntegerCode --> value of 1 or 0
    if PurelyIntegerCode
        libObj.localLibName    = 'rtwintlib.lib'; 
        libObj.localTestFile   = 'rtwintlib.mpf';
        libObj.localDir        = pwd;
        libObj.storageLibName  = 'rtwintlib.lib';
        libObj.storageTestFile = 'rtwintlib.mpf';
        libObj.storageDir      = hc12_temp_dir;
    else
        libObj.localLibName    = 'rtwlib.lib'; 
        libObj.localTestFile   = 'rtwlib.mpf';
        libObj.localDir        = pwd;
        libObj.storageLibName  = 'rtwlib.lib';
        libObj.storageTestFile = 'rtwlib.mpf';
        libObj.storageDir      = hc12_temp_dir;
    end
        
    % Execute the function "markerfile" that creates a 
    % marker file used for determining whether a change
    % has occurred in target prefs. 
    %
    % Any change in target prefs settings results in 
    % a rebuild of rtwlib.lib.    
    markerfile;
        
    % The following section is used to avoid rebuilding the
    % rtwlib or rtwintlib library.
    %
    % If needed, rename rtwlib.mpf to rtwintlib.mpf. 
    % Needs to be done before calling hc12_rtwlib_reuse
    if ~strcmp('rtwlib.mpf',libObj.localTestFile)
        system(['copy rtwlib.mpf ',libObj.localTestFile]); 
    end
    rtwlibNeedsRebuild     = hc12_rtwlib_reuse(libObj,'tryretrieve');      

    if ~rtwlibNeedsRebuild
        % Found the right library and comparison files match enabling us to
        % to copy rtwlib from persistent storage and avoid a rebuild.
        %
        % Two possibilities: \sources\rtwlib.lib or \sources\rtwintlib.lib
        % Copy the lib file to:
        % ..\rtwlib\rtwlib.lib 
        % Note that the library file is always named rtwlib.lib within
        % the project directory. When stored, it may be renamed and 
        % stored as rtwintlib.lib when using integer only.
        % 
        rtwlibDirStr = ['..',filesep,'rtwlib'];
        if ~exist(rtwlibDirStr)
            system(['mkdir ',rtwlibDirStr]);
        end
        system(['copy ',libObj.localLibName,' ..',filesep,'rtwlib',filesep,'rtwlib.lib']);          
    else
        % We must rebuild.      
        % CWAutomation always produces:  \rtwlib\rtwlib.lib
        cwautomation_hc12(rtwlibPathAndFileStr,'build');
        try 
            %                Copy  from       \rtwlib\rtwlib.lib to      \sources\<localLibName> 
            [status,result] = system(['copy ..',filesep,'rtwlib',filesep,'rtwlib.lib ',     libObj.localLibName]);
            if (status)
                disp('Warning: unable to copy rtwlib.lib to persistent storage location. ');
                rtwlibNeedsRebuild = 1; 
            end
        catch
            disp('Warning: unable to copy rtwlib.lib to persistent storage location. ');
            rtwlibNeedsRebuild = 1;    
        end
    end
    %
    % Use hc12_rtwlib_reuse to store libObj.localLibName to persistent library dir. 
    failedToStoreFlag = hc12_rtwlib_reuse(libObj,'store'); 
    %
    % Remove rtwlib.lib or rtwintlib.lib from sources\ directory
    % since it is already in place in rtwlib\ directory.
    system(['del ',libObj.localLibName]); 
    % --------- (end) Enable conditional resuse of rtwlib.lib -----------
    
    disp(['### Target project: ',dstMCPProjectPathAndFile])
    cwautomation_hc12(dstMCPProjectPathAndFile,lower(action));
    
  otherwise
    % Unsupported actions:
    errmsg = ['Unsupported action: ', action];
end                  

disp(['### Completed target action: ',action]);
if ~isempty(errmsg)
    error(errmsg);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: dstMCPProjectPathAndFile
%
% Abstract: Copy project from the location specified by targetPrefs entry and
%           place entire duplicate in a directory relative to current "pwd"
%
function dstMCPProjectPathAndFile = duplicateProject(srcMCPProjectPathAndFile)
    %
    % Clone CodeWarrior project stationery that is preconfigured for
    % the HC12 target. 
    %
    % "srcMCPProjectPathAndFile": Is the path and .mcp file name 
    %   for the template CodeWarrior project stationery that is needed.
    %   The file "hc12_make_rtw_hooks.m" retrieves srcMCPProjectPathAndFile
    %   as follows:
    %
    %   >> tp = gethc12targetprefs 
    %   >> srcMCPProjectPathAndFile = tp.MCPProjectPathAndFile
    %
    % The entire contents of the CodeWarrior project stationery 
    % directory RTW_ICD12_MC9S12DP256 (or other selected stationery) 
    % must be copied to: 
    %
    %   usersWorkingDir\<modelname>_hc12rt
    %
    % The System Target File hc12.tlc directs generated code 
    % to be deposited below this directory to: 
    %
    %   usersWorkingDir\<modelname>_hc12rt\sources
    %   
    % The source project directory is derived from: srcMCPProjectPathAndFile
    % while the destination project directory is derived from the current directory.
    %
    [srcProjDir, srcProjFile, projSuffix, dummy1] = fileparts(srcMCPProjectPathAndFile);
    dstProjDir = pwd;
    [dstProjDir, dummy1, dummy3, dummy3] = fileparts(dstProjDir);
    dstMCPProjectPathAndFile = [dstProjDir,'\',srcProjFile,projSuffix];
    projectCopy(srcProjDir, dstProjDir);
     
%-----------------------------------------------------------------------------
% Function: projectCopy(srcProjDir, dstProjDir)
%
% Abstract: Copy (clone) the project from the sourceProjDir
%           to the destProjDir. This includes all files and
%           subdirectories located under the project directory.
%           Attributes on all project files in the new
%           destination project directory are set to read/write.
%
% Input Args:
%           srcProjDir -- The source project directory that contains 
%                         CodeWarrior project stationery to be copied.
%
%           dstProjDir -- The destination directory (e.g.  <modelname>_hc12rt)
%                         where the CodeWarrior project stationery is copied to.
%
function projectCopy(srcProjDir, dstProjDir)
%
% Determine which Windows OS on host:
[stat,result]=system('ver');
if ~isempty(regexp(result,'Windows 2000'))
  hostArch = 'win2000';

elseif ~isempty(regexp(result,'Windows XP'))
  hostArch = 'winxp';

elseif ~isempty(regexp(result,'Windows NT'))
  hostArch = 'nt' % or 'jnt' treated same as NT.

else
  hostArch = 'unsupported';

end
%
switch hostArch
    case {'win2000','winxp'}
       dosCommand = 'xcopy /S /Y';
    case {'nt','jnt'}
       dosCommand = 'xcopy /S';
    otherwise
       error('Unsupported Host.');
end

% Copy project stationery
dosCmdString = [dosCommand,' ',srcProjDir,' ',dstProjDir];
[status1, result1] = dos(dosCmdString);

% Copy simstruc_types.h
hFile = [matlabroot,filesep,'simulink',filesep,'include',filesep,'simstruc_types.h'];
dosCmdString = [dosCommand,' ',hFile,' ',[dstProjDir,filesep,'sources'] ];
[status1, result1] = dos(dosCmdString);

% Copy rtlibsrc.h
hFile = [matlabroot,filesep,'rtw',filesep,'c',filesep,'libsrc',filesep,'rtlibsrc.h'];
dosCmdString = [dosCommand,' ',hFile,' ',[dstProjDir,filesep,'sources'] ];
[status1, result1] = dos(dosCmdString);

% Copy tmwtypes.h
hFile = [matlabroot,filesep,'extern',filesep,'include',filesep,'tmwtypes.h'];
dosCmdString = [dosCommand,' ',hFile,' ', [dstProjDir,filesep,'sources'] ];
[status1, result1] = dos(dosCmdString);

% Copy rtw_extmode.h
hFile = [matlabroot,filesep,'simulink',filesep,'include',filesep,'rtw_extmode.h'];
dosCmdString = [dosCommand,' ',hFile,' ', [dstProjDir,filesep,'sources'] ];
[status1, result1] = dos(dosCmdString);

% Copy rtw_matlogging.h
hFile = [matlabroot,filesep,'simulink',filesep,'include',filesep,'rtw_matlogging.h'];
dosCmdString = [dosCommand,' ',hFile,' ', [dstProjDir,filesep,'sources'] ];
[status1, result1] = dos(dosCmdString);

% Copy rtw_continuous.h
hFile = [matlabroot,filesep,'simulink',filesep,'include',filesep,'rtw_continuous.h'];
dosCmdString = [dosCommand,' ',hFile,' ', [dstProjDir,filesep,'sources'] ];
[status1, result1] = dos(dosCmdString);

% Copy rtw_solver.h
hFile = [matlabroot,filesep,'simulink',filesep,'include',filesep,'rtw_solver.h'];
dosCmdString = [dosCommand,' ',hFile,' ', [dstProjDir,filesep,'sources'] ];
[status1, result1] = dos(dosCmdString);


% Function: markerfile
% Abstract: Generate a markerfile in local directory
%           containing all target prefs settings.
%           Any changes in settings result in a rebuild of rtwlib.lib files.
function markerfile
  a = ver('rtw');
  rtwVersion = a.Version;

  tpObj = RTW.TargetPrefs.load('hc12.prefs','structure');
  objStr = 'tpObj.';
  p1 = 'TargetProjectType';
  v1 = eval([objStr,p1]);
  
  % Start "ProjectStationery"
  objStr = 'tpObj.ProjectStationery.';
  p2 = 'ProjectPathAndFile_RAM';
  v2 = eval([objStr,p2]);
  %
  p3 = 'ProjectPathAndFile_Flash';
  v3 = eval([objStr,p3]);
  %
  p4 = 'ProjectPathAndFile_Banked';
  v4 = eval([objStr,p4]);
  %
  p5 = 'StaticLibraryDirectory';
  v5 = eval([objStr,p5]);
  % End ProjectStationery
  
  objStr = 'tpObj.';
  p6 = 'TargetCompiler';
  v6 = eval([objStr,p6]);

  try 
    fid = fopen('markerfile.txt','w');
      fprintf(fid,['rtw version',':%s\n'],rtwVersion);
      fprintf(fid,[p1,':%s\n'],v1);
      fprintf(fid,[p2,':%s\n'],v2);
      fprintf(fid,[p3,':%s\n'],v3);
      fprintf(fid,[p4,':%s\n'],v4);
      fprintf(fid,[p5,':%s\n'],v5);
      fprintf(fid,[p6,':%s\n'],v6);
    fclose(fid);
  catch
    error('Unable to generate rtwlib markerfile in \source directory');
  end
  

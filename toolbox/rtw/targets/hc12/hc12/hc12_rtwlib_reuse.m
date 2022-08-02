function rtwlibNeedsRebuild = hc12_rtwlib_reuse(libObj, action);
%
%HC12_RTWLIB_REUSE 
%   Input arguments: libObj, action
%
%   Actions:
%     'tryretrieve' -- Determine whether it is possible to 
%                      use a persistently stored rtw library. 
%                      Returns 1 if rtwlib must be rebuilt.
%                      Returns 0 if rtwlib is being reused and
%                      also copies rtwlib to specified directory and file.
%
%     'store'       -- Persistently store the rtw library.
%                      Returns 0 when successful.
% 
%   Fields of libObj:    Sample values:
%     localLibName         'rtwlib.lib'
%     localTestFile        'filesandflags.txt'
%     localDir             'd:\work\r12\work\vpd_rt'
%     storageLibName       'rtwlib.lib'
%     storageTestFile      'filesandflags.txt'
%     storageDir           'c:\temp\hc12'

%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.3.6.2 $
%   $Date: 2004/03/21 22:57:08 $

  % Error checking.
  % Input arguments require an object and an action.
  if ~(nargin==2)
    error([mfilename,' requires arguments: libObj and action.']);
  end
  % Insure input object has 6 fields.
  b = fieldnames(libObj);
  len = length(b);
  if ~(len==6)
    % Error in input args. Prepare error message 
    str = b{1};
    for i = 2:len
      str = [str,', ',b{i}];        
    end
    error(['Input object must contain 6 fields. Received: ',str]);     
  end
 
  switch lower(action)
    case 'store'
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %  For persistent storage, store:
      %  [libObj.localDir, filesep, libObj.localLibName]
      %
      %  into:
      %  [libObj.storageDir, filesep, libObj.storageLibName]
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      rtwlibNeedsRebuild = store(libObj); 
      
    case 'tryretrieve'
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %  Check existance of stored library and storage library dir.
      %  Compare contents of:
      %    libObj.localTestFile to libObj.storageTestFile
      %
      %    For example, these files can contain a list of
      %    C source files used to create rtwlib as well as
      %    all compiler flags used to create rtwlib. If they
      %    all match, set the flag "rtwlibNeedsRebuild=0"
      %    and copy:
      %    [libObj.storageDir, filesep, libObj.storageLibName]
      % 
      %    into:
      %    [libObj.localDir, filesep, libObj.localLibName]
      %
      %    -- rtwlib.lib as either rtwlib.lib or rtwintlib.lib
      %    -- rtwlib.lst as either rtwlib.lst or rtwintlib.lib
      %
      %  If any condirion results in "rtwlibNeedsRebuild=1",
      %  the files are not copied and it is assumed you will
      %  rebuild the library.
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      rtwlibNeedsRebuild = tryRetrieve(libObj);
    
    otherwise
      error(['Unsupported action: ',action]);    
  end
  
  
% ----------------------------------------------------------------------------
% Function store
%
%   When Integer Only is checked, rtwlib.lib is stored 
%   as  <tempdir>\hc12\rtwintlib.lib 
%   and <tempdir>\hc12\rtwintlib.lst 
%
%   When retrieved, it is copied back and renamed to rtwlib.lib.
%   CodeWarrior ONLY generates the file as rtwlib.lib. We rename
%   rtwlib.lib to allow Integer Only as well as floating point to 
%   both be stored concurrently.  
%
function rtwlibNeedsRebuild = store(libObj)  
  try 
    % Remove all existing *.lib, *.mpf in case they were built with different
    % memory model. Otherwise, they will not get rebuilt as they should on
    % some subsequent build.
    if ~isempty(dir([libObj.storageDir,filesep,'*.lib']))
      system(['del ',libObj.storageDir,filesep,'*.lib']);
    end
    if ~isempty(dir([libObj.storageDir,filesep,'*.mpf']))
      system(['del ',libObj.storageDir,filesep,'*.mpf']);
    end
      [s1,r1] = system(['copy ', libObj.localDir,   filesep, libObj.localLibName, ' ', ...
                       libObj.storageDir, filesep, libObj.storageLibName]);
               
      [s2,r2] = system(['copy ', libObj.localDir,   filesep, libObj.localTestFile, ' ', ...
                       libObj.storageDir, filesep, libObj.storageTestFile]); 

      [s3,r3] = system(['copy ', libObj.localDir,   filesep, 'markerfile.txt', ' ', ...
                       libObj.storageDir, filesep, 'markerfile.txt']);                

      rtwlibNeedsRebuild = 0; % e.g. success
      
  catch
      rtwlibNeedsRebuild = 1; % e.g. failed.
      disp(['### Unable to provide persistent storage for ',libObj.localLibName]); 
  end

% ----------------------------------------------------------------------------
% Function tryRetrieve
%
%   When Integer Only is checked, rtwlib.lib is stored 
%   as  <tempdir>\hc12\rtwintlib.lib 
%   and <tempdir>\hc12\rtwintlib.lst 
%
%   When retrieved, it is copied back and renamed to rtwlib.lib.
%   CodeWarrior ONLY generates the file as rtwlib.lib. We rename
%   rtwlib.lib to allow Integer Only as well as floating point to 
%   both be stored concurrently.  
%
function rtwlibNeedsRebuild = tryRetrieve(libObj)
  rtwlibNeedsRebuild = 0; % Assume it is not necessary to rebuild


    % From the dialog setting for "StaticLibraryRebuild" we can
    % override copying rtwlib from a persistent location and 
    % force a library rebuild.
    %
    % Get "StaticLibraryRebuild" into workspace with a value of 1 or 0
    rtwOptsStr = get_param(gcs,'RTWOptions');
    pat = 'StaticLibraryRebuild='; 
    [s,f,x]=regexp(rtwOptsStr,pat);
    staticLibFlagStr = rtwOptsStr(s:f+1);
    eval([staticLibFlagStr,';']);  
  if (StaticLibraryRebuild)
        rtwlibNeedsRebuild=1; 
  elseif ~exist(libObj.storageDir)
      % If storageDir doesn't exist, can't reuse rtwlib.lib. Needs rebuild.           
      disp(['### Rebuilding library ',libObj.localLibName]);
      rtwlibNeedsRebuild = 1; 
      try
          system(['mkdir ',libObj.storageDir]);
      catch
          disp(['### Warning. Cannot create directory ',libObj.storageDir, ...
               ' for persistent storage of rtw library.']);
      end
  elseif ~exist([libObj.storageDir,filesep,libObj.storageLibName])
      % If rtwlib.lib does not exist, can't reuse rtwlib.lib. Needs rebuild.
      disp(['### Library not found. Rebuilding ',libObj.storageLibName]);
      rtwlibNeedsRebuild = 1; 
  elseif ~exist([libObj.storageDir,filesep,libObj.storageTestFile]) 
      % If test file not stored, can't reuse rtwlib.lib. Needs rebuild.
      disp(['### Undetermined status of RTW library. Rebuilding ', libObj.localLibName]);
      rtwlibNeedsRebuild = 1;   
  elseif ~exist([libObj.storageDir,filesep,'markerfile.txt']) 
      % If marker file "markerfile.txt" not stored, can't reuse rtwlib.lib. 
      % Needs rebuild.
      disp(['### RTW library is unavailable. Rebuilding ', libObj.localLibName]);
      rtwlibNeedsRebuild = 1;   
  else   
      try
        % File Compare: "fc" to determine whether local and
        % stored test files match.
        [status,result] = system(['fc ', ...
            libObj.storageDir, filesep, libObj.storageTestFile, ' ', ...
            libObj.localDir,   filesep, libObj.localTestFile ]);
        if ~(status==0)
            rtwlibNeedsRebuild = 1;    
            disp(['### Library file requires rebuild: ', libObj.localLibName]); 
        end   
      catch
        rtwlibNeedsRebuild = 1;
      end
      try
        % File Compare: "fc" to determine whether local and
        % stored marker files "markerfile.txt" match.
        [status,result] = system(['fc ', ...
            libObj.storageDir, filesep, 'markerfile.txt', ' ', ...
            libObj.localDir,   filesep, 'markerfile.txt' ]);
        if ~(status==0)
            rtwlibNeedsRebuild = 1;    
            disp(['### Marker file indicates library file requires rebuild: ', libObj.localLibName]); 
        end     
      catch
        rtwlibNeedsRebuild = 1;
      end
  end % end  if ~exist(libObj.storageDir)
  
  if ~(rtwlibNeedsRebuild)
    disp(['### Reusing stored rtw library file ', libObj.storageDir, filesep, libObj.storageLibName]);
    try  
      system(['copy ', ...
          libObj.storageDir, filesep, libObj.storageLibName, ' ', ...
          libObj.localDir,   filesep, libObj.localLibName]);
    catch
      rtwlibNeedsRebuild = 1;
      disp(['### Warning. Unable to retrieve ', ...
          libObj.storageDir, filesep, libObj.storageLibName ]);
    end
  end % end  if ~(rtwlibNeedsRebuild)

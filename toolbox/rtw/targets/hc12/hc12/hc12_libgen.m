function hc12_libgen(modelName,rtwroot,templateMakefile,buildOpts,buildArgs)
% HC12_LIBGEN creates a file list for each set of libraries that needs to be
%       build and linked against. For example, the most common library
%       to consider is rtwlib.lib. File lists are generated and placed
%       in an ASCII text file. Paths to the file precede the file names.
%
%       The library will be of the form:
%       rtwlib.mpf (MathWorks Project File for CodeWarrior)
%
%
%       This function is designed to be invoked by by the hooks file
%       hc12_make_rtw_hook.m. All arguments 
%       (modelName,rtwroot,templateMakefile,buildOpts,buildArgs)
%       are assumed to be preset.
%
%       buildOpts is a structure containing:
%          buildOpts.sysTargetFile
%          buildOpts.noninlinedSFcns
%          buildOpts.listSFcns
%          buildOpts.solver
%          buildOpts.solverType
%          buildOpts.numst
%          buildOpts.tid01eq
%          buildOpts.ncstates
%          buildOpts.mem_alloc
%          buildOpts.modules
%          buildOpts.RTWVerbose
%          buildOpts.codeFormat
%          buildOpts.compilerEnvVal -   '' or the location of the env var
%                                       for the compiler. This will be
%                                       non-NULL on the PC when we
%                                       use the mex preferences file
%                                       to determine which template makefile
%                                       to use.
%
%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/03/21 22:57:06 $
  
currPath  = path; 
% Add path to ML pwd when the build was initiated
searchPath= unique({[fullfile('..','..')],...
                    ['.'],...
                    [matlabroot,filesep,'simulink',filesep,'src']});   
cmdOut = evalc('addpath(searchPath{:})');

sfcns =' ';
sfcnLibs = '';
sfcnObjs = '';
% treat non-inlined non-sfunction same as non-inlined sfunction.
buildOpts.noninlinedSFcns = [buildOpts.noninlinedSFcns, buildOpts.noninlinednonSFcns];
for i=1:length(buildOpts.noninlinedSFcns)
  if ~isempty(findstr('.lib', buildOpts.noninlinedSFcns{i}))
    sfcnLibs = [sfcnLibs, [buildOpts.noninlinedSFcns{i}, ' ']];
  elseif ~isempty(findstr('.a', buildOpts.noninlinedSFcns{i}))
    % 
    % If the filename begins with "lib" and is not in the current
    % directory, use the unix-peculiar libpath library file name
    % reference transform (librob.a -> -lrob); otherwise, leave 
    % the name alone.  The library must then be on the library 
    % path (e.g. LD_LIBRARY_PATH environment var.) or must be
    % set explicitly in the make_rtw command using
    % LDFLAGS= -L<libpathitem> for RTW to find the library.
    %
    if isempty(dir(buildOpts.noninlinedSFcns{i})) && ...
          strcmp(buildOpts.noninlinedSFcns{i}(1:3),'lib')
      sfcnLibs = [sfcnLibs, ['-l',strrep( ...
          buildOpts.noninlinedSFcns{i}(4:end),'.a',' ')]];
    else
      %
      %lib file must be in pwd or is a nonstandard name;
      %We expect the user libs to be not in the 
      %code generation directory. If however we detect 
      %it in pwd we put it in pwd else it is in the parent dir. 
      if(~isempty(dir(buildOpts.noninlinedSFcns{i})))
        sfcnLibs = [sfcnLibs, ['.',filesep, buildOpts.noninlinedSFcns{i}, ' ']];
      else  
        sfcnLibs = [sfcnLibs, ['..',filesep, buildOpts.noninlinedSFcns{i}, ' ']];
      end       
    end
  elseif ~isempty(findstr('.obj', buildOpts.noninlinedSFcns{i}))
     % objects found here will go on the link command
     sfcnLibs = [sfcnLibs, ['..', filesep, buildOpts.noninlinedSFcns{i}, ' ']];
  elseif ~isempty(findstr('.o', buildOpts.noninlinedSFcns{i}))
    % objects found here will go on the link command
    sfcnLibs = [sfcnLibs, ['..', filesep, buildOpts.noninlinedSFcns{i}, ' ']];
  else
    if(exist([buildOpts.noninlinedSFcns{i},'.cpp'],'file') == 2)
      sfcns  = [sfcns, [buildOpts.noninlinedSFcns{i}, '.cpp ']];
      sfcnObjs = [sfcnObjs, [buildOpts.noninlinedSFcns{i}, '.obj ']];
    elseif(exist([buildOpts.noninlinedSFcns{i},'.c'],'file') == 2)
      sfcns  = [sfcns, [buildOpts.noninlinedSFcns{i}, '.c ']];
      sfcnObjs = [sfcnObjs, [buildOpts.noninlinedSFcns{i}, '.obj ']];
    end
  end
end
if length(sfcns) > 0
  sfcns(end) = [];
end
path(currPath);

listfile = 'rtw_filelist.mpf';
if exist(listfile,'file') == 2
  if (length(sfcns) > 1)
    % Include into 'rtw_filelist.mpf', any c files from S-Functions,
    % either due to being noninlined or due to SfunctionModules
    % parameter being set. Assume file will be in ML cwd. See
    % gen_rtw_filelist_mpf.tlc for original creation of the file.
    [start,finish] = regexp(sfcns,'\s*');
    fid = fopen(listfile,'a'); 
    for i=1:length(finish)
      if (length(sfcns) > finish(i))
        if i == length(start)
          filename = sfcns(finish(i)+1:end);
        else
          filename = sfcns(finish(i)+1:start(i+1)-1);
        end
        if exist(filename,'file')
          fullname = which(filename);
          fprintf(fid,'%s\n',fullname);
        elseif exist(fullfile('..','..',filename),'file')
          fullname = fullfile('..','..',filename);
          fprintf(fid,'%s\n',fullname);
        else
          error(['Unable to locate S-function file dependency: ', filename]);
        end
      end
    end
    fclose(fid);
  end
end

last_error = lasterr;
last_warng = lastwarn;

currDir        = pwd;
includeDirs    = {};
sourceDirs     = {};
sfcnNames      = {};
%% always add RTW library sources
sfcnPathArray  = {fullfile(matlabroot,'rtw','c','libsrc')};
libraryList    = {};
locationList   = {};
modulesArray   = {};
preCompLib     = {};
preCompLibLoc  = {};
preCompModules = {};

[mf, mexf] = inmem;

% Only build Stateflow for non-accelerator targets
sfIsHere = any(strcmp(mexf,'sf'));

if (sfIsHere)
  sf_makeinfo = sf_rtw('get_sf_makeinfo',modelName);
  if ~isempty(sf_makeinfo)
    sourceDirs  = sf_makeinfo.fileNameInfo.userAbsPaths;
    includeDirs = sf_makeinfo.fileNameInfo.userIncludeDirs;
  end
end

if ~isempty(sfcnNames)
  sfcnNames = unique(sfcnNames);
  for i=1:length(sfcnNames)
    [sfcnPath, sfcnName, sfcnExt] = fileparts(which(sfcnNames{i}));
    if ~isempty(sfcnPath)
      sfcnPathArray = {sfcnPathArray{:}, sfcnPath};
    end
  end
end

sfcnPathArray = unique(sfcnPathArray);
  
for i=1:length(sfcnPathArray)
  cd(sfcnPathArray{i});
  if exist(['.',filesep,'rtwmakecfg.m'],'file') == 2
    set_param(0, 'CurrentSystem', modelName);
    rtwCfgStr = eval('rtwmakecfg','[]');
    tmpIncludeDirs = eval('rtwCfgStr.includePath', '{}');
    tmpSourceDirs  = eval('rtwCfgStr.sourcePath',  '{}');
    includeDirs    = { includeDirs{:}, tmpIncludeDirs{:} };
    sourceDirs     = { sourceDirs{:},  tmpSourceDirs{:}  };
    bPreCompile    = eval('rtwCfgStr.precompile', '0');
    tmpLibraryStr      = eval('rtwCfgStr.library', '{}');
    tmpLibraryList     = eval('{tmpLibraryStr(:).Name}','{}');
    tmpLibraryLocation = eval('{tmpLibraryStr(:).Location}','{''''}');
    tmpModulesArray    = eval('{tmpLibraryStr(:).Modules}','{}');
   % 
   % Assume we can skip the "pre-compiled" libraries -- since they
   % were not provided for HC12.
   % 
   libraryList    = { tmpLibraryList{:}, libraryList{:} };
   locationList   = { tmpLibraryLocation{:}, locationList{:} };
   modulesArray   = { tmpModulesArray{:}, modulesArray{:} };
  end
end
%
includeDirs = ordered_unique_paths(includeDirs);
sourceDirs  = ordered_unique_paths(sourceDirs);
%
[libraryList, idx] = unique(libraryList);
modulesArray = modulesArray(idx);
locationList = locationList(idx);
%
[preCompLib, idx] = unique(preCompLib);
preCompModules = preCompModules(idx);
preCompLibLoc = preCompLibLoc(idx);
%
cd(currDir);

if exist([libraryList{i},'.mpf'],'file')
  system(['del ',libraryList{i},'.mpf']);
end 

% Write list of fNames to the library.mpf file(s).
% At least rtwlib.mpf is generated. Depending on model
% contents (e.g. which blocks used), it is possible to
% find additional libraries such as DSP, Fuzzy, Fixed-Point,
% and so forth.
for i = 1:length(libraryList)
    % Open the "libraryname.mpf" for writing
    fid = fopen([libraryList{i},'.mpf'],'a'); 
    fNames=modulesArray;
    for k=1:length(modulesArray{i})
        if ~(strcmp('rt_logging',fNames{i}{k}))
            fprintf(fid,'%s%s%s.c\n',sourceDirs{i},filesep,fNames{i}{k});
        end
    end
    fclose(fid);
end
%  libraryList --> "rtwlib"
%  includeDirs
%  libraryList
%  locationList
lasterr(last_error); lastwarn(last_warng);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function orderedList = ordered_unique_paths(orderedList)
%
% orderedList must be a cell array of strings. This function gets rid of duplicate
% paths while preserving the original order of unique elements. Also note that
% on PC platforms paths are case insensitive. At the same time Simulink saves PC
% drive letters of absolute paths in uppercase format. This is inconsistent with pwd
% function. So to remove any ambiguity on PC we return all paths in lower case form.
%
% Thanks to the Stateflow team !  
%  
  if ispc
    orderedList = lower(orderedList);
    for i=1:length(orderedList)
      if(orderedList{i}(end)=='\')
        % if this is the root of a drive, then get rid of the 
        % trailing \ since it causes compilation failures
        % G76510
        orderedList{i}=orderedList{i}(1:end-1);
      end
    end
  end
  len = length(orderedList);
  if (len<=1), return; end
  reverseList = orderedList(end:-1:1);
  [l,uniqueIndx] = unique(reverseList);
  uniqueIndx = sort(len+1-uniqueIndx);
  orderedList = orderedList(uniqueIndx);

%endfunction 
%  
%[eof] hc12_libgen.m
%
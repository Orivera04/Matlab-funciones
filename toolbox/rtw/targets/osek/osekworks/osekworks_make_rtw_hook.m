function osekworks_make_rtw_hook(method, modelName, rtwRoot, tmf, buildOpts, buildArgs)
%OSEKWORKS_MAKE_RTW_HOOK  Make RTW hook file for OSEKWorks target

% Copyright 2002-2004 The MathWorks, Inc.
% $Revision: 1.13.6.5 $
% $Date: 2004/03/21 22:58:35 $

switch method
 case 'entry'
  % No action
  fprintf(1,['\n### Starting Real-Time Workshop build procedure for ', ...
             'model: %s\n'],modelName);
  % Setup desired TFL support
  cs = getActiveConfigSet(modelName);
  if strcmp(get_param(cs,'GenFloatMathFcnCalls'), 'ISO_C')
    set_param(cs,'TargetFcnLib','osekworks_math_tmw.mat');
  end
 case 'before_tlc'
  % no action
 case 'before_make'
  cs = getActiveConfigSet(modelName);
  if strcmp(get_param(cs,'GenerateReport'),'on')
    % Optionally add .oil file to html report
    localAddToHTMLReport([modelName,'.oil']);
  end
 case 'exit'
  cs = getActiveConfigSet(modelName);
  % ASAP2 post processing, get addresses into .a2l file
  if strcmp(get_param(cs,'GenerateASAP2'),'on')
    % Specify perl script capable of processing the generated MAP file
    perlFile = fullfile(matlabroot,'toolbox','rtw','targets','osek',...
                        'osekworks','asap2post.pl');
    if isValidParam(cs, 'targetSuffix') && ~strcmp(get_param(cs,'targetSuffix'), 'none')
      suffix = get_param(cs,'targetSuffix');
      fullmodelName = [modelName,'_',suffix];
      %Copy .map so target_asap2_util can find it
      [s,r]=system(['copy ..',filesep,fullmodelName,'.map',' ..',filesep,modelName,'.map ']);
    else
      fullmodelName = modelName;
    end
    target_asap2_utils('postProcess', modelName, perlFile);
    %Copy .a2l to BSP Dir as it is BSP specific and other output files reside there as well
    newa2l = [get_param(cs,'bspName'), '_obj',filesep, fullmodelName,'.a2l'];
    [s,r]=system(['copy ',modelName,'.a2l ', newa2l]);
    %Copy .a2l to Model Dir to be consistent with other generated output files.
    [s,r]=system(['copy ',modelName,'.a2l ','..',filesep,fullmodelName,'.a2l']);
  end

  % Perform any auto download,run tasks
  localDownloadHandling(modelName,buildOpts.generateCodeOnly);

  if (buildOpts.generateCodeOnly == 0)  
    % Update html report with RAM/ROM information
    htmlreport;
    fprintf(1,...
	    ['### Successful completion of Real-Time Workshop build '...
	    'procedure for model: %s\n'], modelName); 
  else
    fprintf(1,...
	    ['### Successful completion of Real-Time Workshop code '...
             'generation procedure for model: %s\n'], modelName);      
  end
  
 otherwise
  errdlg(['Unrecognized hook file method: ', method]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function localAddToHTMLReport(fileName)
    %
    % Add to generated HTML the filename provided. Normally, all .c and .h
    % file in RTW build directory are added. This function would be used to
    % add other files in builddir with different extensions such as .oil.
    % This function leverages RTW private functions, specifically rtwctags
    % is used which presumes file contains C like syntax.
    %
    savedBuildDir = pwd;
    try
      lasterr('');
      cd('html');
      fileToTag = {fullfile(savedBuildDir,fileName)};
      rtwprivate('rtwctags',fileToTag);
      fid = fopen('contents_file.tmp','r');
      fileContents = fread(fid, '*char')';
      fclose(fid);
      [s,f,t] = regexp(fileContents, '<A HREF[^\n]*');
      insertTxt = ['</TD></TR><TR></TR><TR><TD>', sprintf('\n'), fileContents(s:f)];
      rptContentsFile = rtwprivate('rtwattic', 'getContentsFileName');
      fid = fopen(rptContentsFile, 'r');
      fileContents = fread(fid, '*char')';
      fclose(fid);
      [s,f,t] = regexp(fileContents, '</A>\s*');
      fileContents = [fileContents(1:f(end)), insertTxt, fileContents(f(end)+1:end)];
      fid = fopen(rptContentsFile, 'w');
      fwrite(fid, fileContents, 'char');
      fclose(fid);
      rptFileName = rtwprivate('rtwattic', 'getReportFileName');
      rtwprivate('rtwshowhtml', rptFileName);
    end
    cd(savedBuildDir);
    error(lasterr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function value = localDownloadHandling(modelName,generateCodeOnly)
  if (generateCodeOnly == 0)
    %
    % Some target action may be requested, which is only relevent
    % when we have actually compiled the generated code
    %
    
    % Get the BuildAction and other variables into our context
    cs = getActiveConfigSet(modelName);
    tgtactionOption = get_param(cs,'BuildAction');
    BuildAction = tgtactionOption;
    
    % handle the BuildAction.
    switch BuildAction
      case 'Download_and_run'
       osektgtaction('run',modelName);
     case 'Download_and_debug'
      osektgtaction('debug',modelName);
     case 'None'
      % no action
     otherwise
      error(['Unhandled build action: ' BuildAction])
    end
  end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

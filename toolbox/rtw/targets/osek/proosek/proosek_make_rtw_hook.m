function proosek_make_rtw_hook(method, modelName, rtwRoot, tmf, buildOpts, buildArgs)
%PROOSEK_MAKE_RTW_HOOK  Make RTW hook file for ProOSEK target
%   During its build process, Real-Time Workshop checks for the existence
%   of <target>_make_rtw_hook.m where <target> is the base name of the 
%   active system target file. For example, if your system target file
%   is grt.tlc, then the hook file name is grt_rtw_info_hook.m.  If the
%   hook file is present (i.e., on the MATLAB path), then the code
%   defined in this file is called at the corresponding stages during 
%   the build process.

% Copyright 2002-2004 The MathWorks, Inc.
% $Revision: 1.6.4.2 $
% $Date: 2004/03/21 22:58:38 $

switch method
 case 'entry'
  % No action
  fprintf(1,['\n### Starting Real-Time Workshop build procedure for ', ...
             'model: %s\n'],modelName);
 case 'before_tlc'
  % No action
 case 'before_make'
  cs = getActiveConfigSet(modelName);
  if strcmp(get_param(cs,'GenerateReport'),'on')
    % Optionally add .oil file to html report
    localAddToHTMLReport([modelName,'.oil']);
  end
 case 'exit'
  % specify perl script capable of processing the generated MAP file
  perlFile = fullfile(matlabroot,'toolbox','rtw','targets','osek',...
                      'proosek','asap2post.pl');
  target_asap2_utils('postProcess', modelName, perlFile);

  localDownloadHandling(modelName,buildOpts.generateCodeOnly);
  if (buildOpts.generateCodeOnly == 0)  
    htmlreport;
    delete htmlreport.m;  % house keeping
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

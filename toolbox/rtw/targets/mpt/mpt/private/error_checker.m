function [status,varargout] = error_checker(errorLC, modelName, chkcat, varargin)
%ERROR_CHECKER will check and reports errors.
%
%  [STATUS, VARARGOUT] = ERROR_CHECKER(ERRORLC,MODELNAME, CHKCAT, VARARGIN)
%         
%   INPUT:
%         errorLC: error Log control, 1: enable error check; 0 disable error check
%         modelName: name of model to generate code for
%         chkcat:    error checking category
%         chkcat is not case sensitive and can be any one in the following list:
%           dirreadonly --- for checking if the work directory is read-only
%           dirpath --- for checking the work directory path validation
%           filefound --- for checking if there is .c file(s) generated from Stateflow
%           editvalid --- for checking if editable fields/files in GUI are valid
%           dow -------- for checking if names of potential objects for DOW are
%                        valid
%         varargin: any additional input            
%   OUTPUT:
%        status: the status of error check, 1: no error; 0: error   
%        varargout: any additional output  


%  Linghui Zhang
%  Copyright 2003 The MathWorks, Inc. 
%  $Revision: 1.1.6.1 $
%  $Date: 2003/12/31 19:43:59 $

if errorLC == 0
    status = 1; 
    varargout{1} = '';
    return;
else
    cr = sprintf('\n');
    varargout{1} = '';
    msg = ''; 
    status = 0;
    switch upper(chkcat)
        case 'DIRREADONLY'
            dirName = varargin{1};
            [status, msg] = dirreadonly(dirName);
            varargout{1} = msg;
        case 'DIRPATH'
            dirName = varargin{1};
            [status, msg] =  dirpath(dirName);
            varargout{1} = msg;
        case 'EDITVALID'
            [status, msg] = editvalid(modelName);
            varargout{1} = msg;
        case 'DOW'
            datalist = varargin{1};
            [status,msg,failedlist,goodlist] = objnamevalid(modelName,datalist);
            if status == 0
                slsfnagctlr('Clear', modelName, 'Simulink Diagnostic Window');
                nag = slsfnagctlr('NagTemplate');
                errmsg = failedlist;
                nag.type = 'Error';
                nag.msg.type = 'Parse';
                nag.msg.details =  sprintf('Model: "%s"\n  %s', modelName, errmsg);
                nag.msg.summary = msg;
                nag.sourceName = modelName;
                nag.sourceFullName = '';
                nag.component = 'Simulink';
                nag.sourceHId= '';
                nag.ids= [];
                slsfnagctlr('Naglog', 'push', nag);
                slsfnagctlr('ViewNaglog');
            end
            varargout{1} = goodlist;
        otherwise
            disp([cr,' ERROR_CHECKER: Invalid Error Checking Category']);
            return;
    end    
end

%-----------------------------------------------------------------------
function [status,msg] =  dirpath(dirName)
%DIRPATH Check directory path validation
%   status = 1, the directory path is valid; status = 0, the directory path is invalid
% Stateflow centric

msg = '';
numS = findstr(filesep,dirName);
pathS = dirName;
for i = 1: length(numS)
    [pathS,dirS] = fileparts(pathS);
    for j = 1: length(dirS)        
        if isletter(dirS(j)) || dirS(j) == '_' || ~isempty(str2num(dirS(j)))
            status = 1;
            continue;
        else
            status = 0;
            msg = 'Invalid Directory Name';
            return; 
        end
    end
end

%----------------------------------------------
function [status,msg] =  dirpath1(dirName)
%DIRPATH Check directory path validation
%   status = 1, the directory path is valid; status = 0, the directory path is invalid

% The build directory path can not include ' 

cr = sprintf('\n');
index = findstr(dirName,'''');
if  isempty(index) == 0
    status = 0;
    msg = [errmsg,'The directory name "',dirName,'"',  ' is INVALID', ...
            ' because it contains single quote(s).'];
else
    status = 1;
    msg = '';
end

%-----------------------------------------------------------------------
function [status,msg] = dirreadonly(dirName)
%DIRREADONL Check if the given directory is read-only
%   status = 0, read-only  ; status = 1, not read-only

msg = '';
[s, mes]=fileattrib(dirName);
status = 1;
if isempty(mes) == 0, 
    if mes.UserWrite == 0
        status = 0;
        msg = ['The directory ''',dirName,''' is read-only.'];
    end
end
return;

%------------------------------------------------------------------
function [status, failedlist] = editvalid(modelName)
%EDITVALID Check if editable fields/files in GUI are valid 

list = '';
failedlist = '';
cr = sprintf('\n');
status = 1;

% For checking Data Placement
%%% Gloal data placement
value = mpt_config_get(modelName,'GlobalDataDefinition');
if strcmp(value,'InSeparateSourceFile') == 1
    value = mpt_config_get(modelName,'DataDefinitionFile');
    value = strrep(value,' ','');
    if isempty(value) == 1
       list{end+1} =['Data definition filename needs to be specified when ',...
                     '''Data defined in a single separate source file'' is selected for ',...
                     'Data definition.'];
    else
      if strcmp(value,'.c') == 1
         list{end+1} =['Data definition filename ''.c'' is not a valid c file name when ',...
                       '''Data defined in a single separate source file'' is selected for ',...
                       'Data definition.'];
      else
         fileName = strtok(value, '.');
         if ~isvarname(fileName) & ~iskeyword(fileName)
            list{end+1} =['Data definition filename ''',value,''' is not a valid c file name when ',...
                          '''Data defined in a single separate source file'' is selected for ',...
                          'Data definition.'];
         else
            mpt_config_set(modelName,'DataDefinitionFile',value); 
         end
      end
    end
end
value = mpt_config_get(modelName,'GlobalDataReference');
if strcmp(value,'InSeparateHeaderFile') == 1
    value = mpt_config_get(modelName,'DataReferenceFile');
    value = strrep(value,' ','');
    if isempty(value) == 1
       list{end+1} =['Data reference filename needs to be specified when ',...
                     '''Data referenced in a single separate header file'' is selected for ',...
                     'Data reference.'];
    else
      if strcmp(value,'.h') == 1
         list{end+1} =['Data reference filename ''.h'' is not a valid h file name when ',...
                       '''Data referenced in a single separate header file'' is selected for ',...
                       'Data reference.'];
      else
         fileName = strtok(value, '.');
         if ~isvarname(fileName) & ~iskeyword(fileName)
            list{end+1} =['Data reference filename ''',value,''' is not a valid h file name when ',...
                          '''Data referenced in a single separate header file'' is selected for ',...
                          'Data reference.'];
         else
            mpt_config_set(modelName,'DataReferenceFile',value); 
         end
      end
    end
end

%%% Module name
value = mpt_config_get(modelName,'ModuleNamingRule');
if strcmp(value,'UserSpecified')
    %Module naming: User specified
    value = mpt_config_get(modelName,'ModuleName');
    value = strrep(value,' ','');
    if isempty(value) == 1
       list{end+1} =['Module name needs to be specified when ''User specified''',...
                     'is selected for Module naming.'];
    else
        if isvarname(value)== 0 & isequal(value(1), '_') == 0
            list{end+1} =['Module name has to be a valid c variable name when ',...
                          '''User specified'' is selected for Module naming.'];
        else
            mpt_config_set(modelName,'ModuleName',value);             
        end
    end
end

%%% Display level & Tune level
value = mpt_config_get(modelName,'SignalDisplayLevel');

%for checking namingrules
%%% #define naming
value = mpt_config_get(modelName,'DefineNamingRule');
if strcmp(value,'Custom') 
    value = mpt_config_get(modelName,'DefineNamingFcn');
    value = strrep(value,' ','');
    if isempty(value) == 1
       list{end+1} =['#define naming M-funtion is undefined.'];
    else        
        if exist(value, 'file') ~= 2
            list{end+1} =['#define naming M-funtion ''', value, ''' is undefined.'];
        else
            mpt_config_set(modelName,'DefineNamingFcn',value);
        end
    end
end

%%% Parameter naming
value = mpt_config_get(modelName,'ParamNamingRule');
if strcmp(value,'Custom') 
    value = mpt_config_get(modelName,'ParamNamingFcn');
    value = strrep(value,' ','');
    if isempty(value) == 1
        list{end+1} =['Parameter naming M-funtion is undefined.'];
    else
        if exist(value, 'file') ~= 2
            list{end+1} =['Parameter naming M-funtion ''', value, ''' is undefined.'];
        else
            mpt_config_set(modelName,'ParamNamingFcn',value);
        end
    end
end

%%% Signal naming
value = mpt_config_get(modelName,'SignalNamingRule');
if strcmp(value,'Custom') 
    value = mpt_config_get(modelName,'SignalNamingFcn');
    value = strrep(value,' ','');
    if isempty(value) == 1
        list{end+1} =['Signal naming M-funtion is undefined.'];
    else
        if exist(value, 'file') ~= 2
            list{end+1} =['Signal naming M-funtion ''', value, ''' is undefined.'];
        else
            mpt_config_set(modelName,'SignalNamingFcn',value);
        end
    end
end

if length(list)> 0
    status = 0;
    failedlist= [failedlist,cr];
    for i=1:length(list)
        failedlist= [failedlist,'   ',list{i},cr];
    end  
end
return;

%-----------------------------------------------------------------
function [status,msg,failedlist,goodlist] = objnamevalid(modelName,dataList)
%Check if names of potential objects for DOW are valid

status = 1;
msg = '';
list1 = '';
list2 = '';
failedlist = '';
goodlist = '';
cr = sprintf('\n');

%for holding non-empty name data
paramName = '';
param = '';
signalName = '';
signal='';

for k = 1:length(dataList)
    if isequal(dataList{k}.name,'') == 0
        %split the list to parameter and signal
        if strcmp(dataList{k}.type,'Parameter') == 1
            paramName{end+1} = dataList{k}.name;
            param{end+1} = dataList{k};
        else
            signalName{end+1} = dataList{k}.name;
            signal{end+1} = dataList{k};
        end     
    end
end
if ~isempty(paramName) || ~isempty(signalName)
    if ~isempty(paramName) && ~isempty(signalName)
        %%%%case1: check unique name
        comm = intersect(signalName,paramName);
        if isempty(comm) == 0
            % Parameter & Signal name duplicate
            list1{end+1} =['The following data names are used for both a parameter and signal: '];                          
            for k = 1:length(comm)
                list1{end+1} =['        ', comm{k}];
            end
            [diff,ia,ib] = setxor(signalName,comm);
            signal = signal(ia); %take duplicate names out of the signal list
            signalName = signalName(ia);
            [diff,ia,ib] = setxor(paramName,comm);
            param = param(ia); %take duplicate names out of the param list
            paramName = paramName(ia);
        end
    end
    alldataName = cellstr([signalName,paramName]);
    alldata = [signal,param];
    cKeyword = {'asm','auto','break','case','char','const','continue',...
                'default','do','double','else','entry','enum','extern',...
                'float','for','fortran','goto','if','int','long',...
                'register','return','short','signed','sizeof','static',...
                'struct','switch','tyepdef','union','unsigned','void',...
                'volatile','while'};
    list2{end+1} =['The following names of parameters or signals are invalid: '];        
    for k = 1:length(alldataName)
      %%%%case2: check valid variable name/matlab keyword/c keyword
        if ~isvarname(alldataName{k})|iskeyword(alldataName{k})|...
           ismember(alldataName{k},cKeyword)
            list2{end+1} =['        ',alldataName{k}];
        else
            goodlist{end+1} = alldata{k};
        end
    end
end
    
if length(list1)>1 || length(list2)>1
    status = 0;
    msg = 'Invalid Parameter or Signal Name';
    status = 0;
    failedlist= ['Error ',cr];
    for i=1:length(list1)
        failedlist= [failedlist,'     ',list1{i},cr];
    end    
    if length(list2)>1
      for i=1:length(list2)
         failedlist= [failedlist,'     ',list2{i},cr];
      end      
    end
end
return;


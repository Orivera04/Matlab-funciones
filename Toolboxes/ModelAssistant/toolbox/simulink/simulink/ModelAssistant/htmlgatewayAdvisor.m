function htmlgatewayAdvisor(actionString)
% it inteprets HTML form info into m function arguments.
% Usage in HTML file:
%    <form method="POST" action="matlab: htmlgatewayAdvisor ">

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:15 $

% get rid of leading "?" 
%varargin{:}
%actionString  %debug info
actionString = strtok(actionString, '?');

ButtonClicked = 'Search';

% record user input from HTML page
USER_INPUT = [];

CheckQuestionBlock  = -1;
CheckUnconnectedObj = -1;
CheckRootLevelInports = -1;
CheckSolver = -1;
CheckTaskingMode = -1;
CheckFixedPoint = -1;
CheckSystemTLC = -1;
CheckExpensiveBlocks = -1;
CheckStateflowInterface = -1;
CheckCodeInstrumentation = -1;
CheckDataInitialization = -1;
updateSTF = -1;
updateSolver = -1;
updateMATFileLogging = -1;

ProdHWWordLengths ='';
ProdHWWordLengthsCount = 0;
HighLevelConfiguration = [];
while (length(actionString) > 0)
    [tokenElement, actionString] = strtok(actionString, '&');
    [elementName, elementValue] = analyzeToken(tokenElement);
    % ignore submitButton 
    switch elementName
        case 'submitButton'
            ButtonClicked = 'Search';
            continue;
        case 'Model'    
            if ~strcmp(elementValue, HTMLattic('AtticData', 'model'))
                open_system(elementValue);
                HTMLattic('AtticData', 'model', elementValue); % update model/subsystem
                createStartInSystemTemplate;
                %regenerate pages
                createAdvisorStartPage;
                createDetailConfigurePage;
                createDiagnoseStartPage; 
            end
        case 'checkModel'
            ButtonClicked = 'checkModel';
        case 'highLevelConfigModel'
            ButtonClicked = 'highLevelConfigModel';
        case 'updateModel'
            ButtonClicked = 'updateModel';
            continue;
        case 'undoButton'
            ButtonClicked = 'Undo';
            continue 
        case 'refreshDetailConfigButton'
            ButtonClicked = 'refreshDetailConfigButton';
            continue 
        case 'CheckQuestionBlock'
            if strcmpi(elementValue, 'on') %CheckQuestionBlock checkbox is selected
                CheckQuestionBlock = 1; 
            else
                CheckQuestionBlock = 0;
            end
        case 'CheckUnconnectedObj'
            if strcmpi(elementValue, 'on') %CheckUnconnectedObj checkbox is selected
                CheckUnconnectedObj = 1; 
            else
                CheckUnconnectedObj = 0;
            end
        case 'CheckRootLevelInports'
            if strcmpi(elementValue, 'on') %CheckRootLevelInports checkbox is selected
                CheckRootLevelInports = 1;
            else
                CheckRootLevelInports = 0;
            end
        case 'CheckSolver'
            if strcmpi(elementValue, 'on') %CheckSolver checkbox is selected
                CheckSolver = 1; 
            else
                CheckSolver = 0; 
            end
        case 'CheckTaskingMode'
            if strcmpi(elementValue, 'on') %CheckTaskingMode checkbox is selected
                CheckTaskingMode = 1; 
            else
                CheckTaskingMode = 0; 
            end
        case 'CheckFixedPoint'
            if strcmpi(elementValue, 'on') %CheckFixedPoint checkbox is selected
                CheckFixedPoint = 1; 
            else
                CheckFixedPoint = 0; 
            end            
        case 'CheckSystemTLC'
            if strcmpi(elementValue, 'on') %CheckSystemTLC checkbox is selected
                CheckSystemTLC = 1;
            else
                CheckSystemTLC = 0; 
            end
        case 'CheckStateflowInterface'
            if strcmpi(elementValue, 'on') %CheckStateflowInterface checkbox is selected
                CheckStateflowInterface = 1;
            else
                CheckStateflowInterface = 0; 
            end
        case 'CheckExpensiveBlocks'
            if strcmpi(elementValue, 'on') %CheckExpensiveBlocks checkbox is selected
                CheckExpensiveBlocks = 1;
            else
                CheckExpensiveBlocks = 0; 
            end            
        case 'CheckCodeInstrumentation'
            if strcmpi(elementValue, 'on') %CheckCodeInstrumentation checkbox is selected
                CheckCodeInstrumentation = 1;
            else
                CheckCodeInstrumentation = 0; 
            end
        case 'CheckDataInitialization'
            if strcmpi(elementValue, 'on') %CheckDataInitialization checkbox is selected
                CheckDataInitialization = 1;
            else
                CheckDataInitialization = 0; 
            end
        case 'updateSTF'
            if strcmpi(elementValue, 'Yes') %update System Target File is selected
                updateSTF = 1;
                % feed into USER_INPUT unify structure
                updateSTFRecord = HTMLattic('AtticData', 'updateSTFRecord');
                i = length(USER_INPUT);
                USER_INPUT(i+1).Property = 'RTWSystemTargetFile';
                USER_INPUT(i+1).IsorNot = 1;
                USER_INPUT(i+1).paramChecked = 1;
                USER_INPUT(i+1).Value = updateSTFRecord.thisTargetFile;
                USER_INPUT(i+1).NewValue = updateSTFRecord.ERT_TargetFile;
                USER_INPUT(i+2).Property = 'RTWTemplateMakefile';
                USER_INPUT(i+2).IsorNot = 1;
                USER_INPUT(i+2).paramChecked = 1;
                USER_INPUT(i+2).Value = updateSTFRecord.this_MakeFile;
                USER_INPUT(i+2).NewValue = updateSTFRecord.ERT_MakeFile;
                USER_INPUT(i+3).Property = 'RTWMakeCommand';
                USER_INPUT(i+3).IsorNot = 1;
                USER_INPUT(i+3).paramChecked = 1;
                USER_INPUT(i+3).Value = updateSTFRecord.this_MakeCmd;
                USER_INPUT(i+3).NewValue = updateSTFRecord.ERT_MakeCmd;
            else
                updateSTF = 0; 
            end
        case 'updateSolver'
            if strcmpi(elementValue, 'Yes') %update Solver is selected
                updateSolver = 1;
                % feed into USER_INPUT unify structure
                i = length(USER_INPUT);
                USER_INPUT(i+1).Property = 'Solver';
                USER_INPUT(i+1).IsorNot = 1;
                USER_INPUT(i+1).paramChecked = 1;
                USER_INPUT(i+1).NewValue = 'FixedStepDiscrete';
                %set_param(hModel, 'Solver', 'FixedStepDiscrete')
            else
                updateSolver = 0;
            end
        case 'updateMATFileLogging'
            if strcmpi(elementValue, 'Yes') %updateMATFileLogging is selected
                updateMATFileLogging = 1;
                % feed into USER_INPUT unify structure
                i = length(USER_INPUT);
                USER_INPUT(i+1).Property = 'rtwoption_MatFileLogging';
                USER_INPUT(i+1).IsorNot = 1;
                USER_INPUT(i+1).paramChecked = 1;
                USER_INPUT(i+1).NewValue = 0;
            else
                updateMATFileLogging = 0;
            end
        case 'updateScheduler' 
            switch elementValue
                case 'multi'    % user choose generate Multi tasking scheduler
                    if strcmp(get_param(bdroot(HTMLattic('AtticData', 'model')), 'SolverMode'), 'SingleTasking');
                        %set_param(hModel, 'SolverMode', 'Auto');
                        i = length(USER_INPUT);
                        USER_INPUT(i+1).Property = 'SolverMode';
                        USER_INPUT(i+1).IsorNot = 1;
                        USER_INPUT(i+1).paramChecked = 1;
                        USER_INPUT(i+1).NewValue = 'Auto';
                        % Recompile model to check for invalid rate transitions:
                        %set_param(hModel, 'SimulationCommand', 'update');
                    end
                case 'single'   % user choose generate Single tasking scheduler
                    % set_param(hModel, 'SolverMode', 'SingleTasking');
                    i = length(USER_INPUT);
                    USER_INPUT(i+1).Property = 'SolverMode';
                    USER_INPUT(i+1).IsorNot = 1;
                    USER_INPUT(i+1).paramChecked = 1;
                    USER_INPUT(i+1).NewValue = 'SingleTasking';
                case 'noupdate' % no action
            end
        case 'updateDataInitialization'
            if strcmpi(elementValue, 'Yes') %updateDataInitialization is selected
                updateDataInitialization = 1;
                % feed into USER_INPUT unify structure
                i = length(USER_INPUT);
                USER_INPUT(i+1).Property = 'rtwoption_ZeroExternalMemoryAtStartup';
                USER_INPUT(i+1).IsorNot = 1;
                USER_INPUT(i+1).paramChecked = 1;
                USER_INPUT(i+1).NewValue = 0;
                USER_INPUT(i+2).Property = 'rtwoption_ZeroInternalMemoryAtStartup';
                USER_INPUT(i+2).IsorNot = 1;
                USER_INPUT(i+2).paramChecked = 1;
                USER_INPUT(i+2).NewValue = 0;
                USER_INPUT(i+3).Property = 'rtwoption_InitFltsAndDblsToZero';
                USER_INPUT(i+3).IsorNot = 1;
                USER_INPUT(i+3).paramChecked = 1;
                USER_INPUT(i+3).NewValue = 0;
            else
                updateDataInitialization = 0;
            end
        case {'ProdHWWordLengths_char', 'ProdHWWordLengths_short', 'ProdHWWordLengths_int', 'ProdHWWordLengths_long'}
            ProdHWWordLengths = [ProdHWWordLengths ',' elementValue];
            ProdHWWordLengthsCount = ProdHWWordLengthsCount+1;
            if ProdHWWordLengthsCount >= 4
                serialNum = length(USER_INPUT)+1;
                USER_INPUT(serialNum).NewValue = ProdHWWordLengths(2:end);
                % feed into USER_INPUT unify structure
                USER_INPUT(serialNum).Property = 'ProdHWWordLengths';
                USER_INPUT(serialNum).paramChecked = 1;
                USER_INPUT(serialNum).IsorNot = 1;
            end
        otherwise 
            % process element based on their name
            [category, paramName] = analyzeName(elementName);
            % use paramName as index, look for serialNum inside USER_INPUT
            serialNum = length(USER_INPUT)+1;
            if isfield(USER_INPUT, 'Property')
                for i=1:length(USER_INPUT)
                    if strcmp(USER_INPUT(i).Property, paramName)
                        serialNum = i;
                        break;
                    end
                end
            end
            
            switch category
                case 'NewValue'
                    if strcmp(paramName, 'OptimizeBlockIOStorage') % inverse logic for OptimizeBlockIOStorage
                        if strcmp(elementValue, 'on')
                            elementValue = 'off';
                            elementValue2 = 'No';
                        else
                            elementValue = 'on';
                            elementValue2 = 'Yes';
                        end
                        % internally, we'll do 2 things for "Implement
                        % every signal in persistent global memory"
                        USER_INPUT(serialNum+1).NewValue = elementValue2;
                        USER_INPUT(serialNum+1).Property = 'rtwoption_LocalBlockOutputs';
                        USER_INPUT(serialNum+1).paramChecked = 1;
                        USER_INPUT(serialNum+1).IsorNot = 1;
                    end
                    USER_INPUT(serialNum).NewValue = elementValue;
                    % feed into USER_INPUT unify structure
                    USER_INPUT(serialNum).Property = paramName;
                    USER_INPUT(serialNum).paramChecked = 1;
                    USER_INPUT(serialNum).IsorNot = 1;
                case 'HighLevel'  % high-level configuration options, in HighLevel_options pattern
                    [category, paramName] = analyzeName(paramName);  % analyze token
                    str = ['HighLevelConfiguration.' category ' = elementValue;'];
                    eval(str);  % save into HighLevelConfiguration
                otherwise
            end
    end
    %get rid of leading "&" of remain part
    actionString = actionString(2:end);;
end

HTMLattic('AtticData', 'CheckQuestionBlock', CheckQuestionBlock);
HTMLattic('AtticData', 'CheckUnconnectedObj', CheckUnconnectedObj);
HTMLattic('AtticData', 'CheckRootLevelInports', CheckRootLevelInports);
HTMLattic('AtticData', 'CheckSolver', CheckSolver);
HTMLattic('AtticData', 'CheckTaskingMode', CheckTaskingMode);
HTMLattic('AtticData', 'CheckExpensiveBlocks', CheckExpensiveBlocks);
HTMLattic('AtticData', 'CheckSystemTLC', CheckSystemTLC);
HTMLattic('AtticData', 'CheckFixedPoint', CheckFixedPoint);
HTMLattic('AtticData', 'CheckStateflowInterface', CheckStateflowInterface);
HTMLattic('AtticData', 'CheckCodeInstrumentation', CheckCodeInstrumentation);
HTMLattic('AtticData', 'CheckDataInitialization', CheckDataInitialization);

model = HTMLattic('AtticData', 'model');
if isempty(model)
    errordlg('Please use ModelAdvisor.m to start the tool.');
    return
end

switch ButtonClicked
    case 'NewSearch'
        model = HTMLattic('AtticData', 'model');
        SearchConfigWizard(model);
        return
    case 'checkModel'
        %model = get_param(bdroot(HTMLattic('AtticData', 'model')), 'Handle');
        model = get_param(HTMLattic('AtticData', 'model'), 'Handle');
        HTMLattic('AtticData', 'FOUND_OBJECTS', []);  % clear log
        DiagnoseResultPage = HTMLattic('AtticData', 'DiagnoseResultPage');
        f=fopen(DiagnoseResultPage, 'w');
        line = DiagnoseModel(model);
        fprintf(f, '%s', line);
        fclose(f);
        browser(DiagnoseResultPage);
    case 'highLevelConfigModel'
        HTMLattic('AtticData', 'errorLog', '');
        foundObjects = [];
        model = get_param(bdroot(HTMLattic('AtticData', 'model')), 'Handle');
        foundObjects(1) = model;
        USER_INPUT = HighLevel2LowLevelConfig(HighLevelConfiguration);
        errorLog = updatefoundObjects(foundObjects, USER_INPUT);
        HTMLattic('AtticData', 'errorLog', errorLog);
        %refreshRTWOptions(model);
        CreateUpdateResultPageAdvisor;
        browser(HTMLattic('AtticData', 'UpdateResultPage'));                              
    case 'updateModel'
        HTMLattic('AtticData', 'errorLog', '');
        foundObjects = [];
        model = get_param(bdroot(HTMLattic('AtticData', 'model')), 'Handle');
        foundObjects(1) = model;
        errorLog = updatefoundObjects(foundObjects, USER_INPUT);
        HTMLattic('AtticData', 'errorLog', errorLog);
        %refreshRTWOptions(model);
        CreateUpdateResultPageAdvisor('gotoRefreshPage');
        browser(HTMLattic('AtticData', 'UpdateResultPage'));                      
    case 'refreshDetailConfigButton'
        createDetailConfigurePage;
        browser(HTMLattic('AtticData', 'DetailConfigurePage'));
    case 'Undo'
        errorLog = undoUpdates;
        HTMLattic('AtticData', 'errorLog', errorLog);
        model = get_param(bdroot(HTMLattic('AtticData', 'model')), 'Handle');
        lastClickedbutton = HTMLattic('AtticData', 'ButtonClicked');
        ButtonClicked = lastClickedbutton;
        if strcmpi(lastClickedbutton, 'highLevelConfigModel')
            CreateUpdateResultPageAdvisor;
        else
            CreateUpdateResultPageAdvisor('gotoRefreshPage');
        end
        %refreshRTWOptions(model);
        browser(HTMLattic('AtticData', 'UpdateResultPage'));                              
    otherwise
        error('Unexpected button clicked. Please re-start the tool.');
        return
end

% save buttonclicked into HTML attic
HTMLattic('AtticData', 'ButtonClicked', ButtonClicked);

% end main function

% token must be in "name=value" format
function [name, value] = analyzeToken(token)
[name, value] = strtok(token, '=');
value = value(2:end);
value = strrep(value, '+', ' ');
value = HTMLjsencode(value, 'decode');
%value = value{1:end};

% analyze HTML form element:  "Name=Value"
% we expect "Name" follow category_serialNum pattern
function [category, serialNum] = analyzeName(name)
[category, serialNum] = strtok(name, '_');
serialNum = serialNum(2:end);

% translate User input into arguments array
function [positiveArgumentsArray, negativeArgumentsArray] = UserInput2argumetlist(USER_INPUT)
positiveArgumentsArray = {};
negativeArgumentsArray = {};
for i=1:length(USER_INPUT)
    if ~isempty(USER_INPUT(i).Property) %&& ~isempty(USER_INPUT(i).Value) 
        if ~isfield(USER_INPUT(i), 'paramChecked')
            continue        % skip non checked params
        end
        if isempty(USER_INPUT(i).paramChecked) || (~USER_INPUT(i).paramChecked)  % skip non checked params
            continue
        end
        if USER_INPUT(i).IsorNot == 1
            positiveArgumentsArray{length(positiveArgumentsArray)+1} = USER_INPUT(i).Property;
            positiveArgumentsArray{length(positiveArgumentsArray)+1} = USER_INPUT(i).Value;
        else
            negativeArgumentsArray{length(negativeArgumentsArray)+1} = USER_INPUT(i).Property;
            negativeArgumentsArray{length(negativeArgumentsArray)+1} = USER_INPUT(i).Value;
        end
    end
end

% save found objects into HTML attic
function savefoundObjects(foundObjects, foundParameters, foundDialogParameters)
FOUND_OBJECTS = [];
for i=1:length(foundObjects)
    FOUND_OBJECTS(i).handle = get_param(foundObjects(i), 'handle');
    FOUND_OBJECTS(i).checked = 1; % init to true
    FOUND_OBJECTS(i).fullname = getfullname(foundObjects(i));
    FOUND_OBJECTS(i).name = get_param(foundObjects(i),'name');
end
HTMLattic('AtticData', 'FOUND_OBJECTS', FOUND_OBJECTS);        
HTMLattic('AtticData', 'FOUND_PARAMETERS', foundParameters);
HTMLattic('AtticData', 'FOUND_DIALOG_PARAMETERS', foundDialogParameters);

% update object property based on user input
function errorLog = updatefoundObjects(foundObjects, USER_INPUT)
updateLog=[];
errorLog='';
for i=1:length(foundObjects)
    %refreshRTWOptions(foundObjects(1));
    LogforCurrentObj=[];
    fp = get_param(foundObjects(i), 'ObjectParameters');
    for j=1:length(USER_INPUT)
        currentLog=[]; 
        if isfield(USER_INPUT(j), 'Property') && isfield(USER_INPUT(j), 'NewValue') && isfield(USER_INPUT(j), 'paramChecked')
            if ~isempty(USER_INPUT(j).Property) && ~isempty(USER_INPUT(j).NewValue) && ~isempty(USER_INPUT(j).paramChecked)
                currentLog.ParamName = USER_INPUT(j).Property; % always log param name
                if isfield(fp, USER_INPUT(j).Property) && USER_INPUT(j).paramChecked
                    currentLog.NA = 0; % not Not Applicable
                    currentLog.oldValue = get_param(foundObjects(i), USER_INPUT(j).Property);
                    %currentLog.setValue = USER_INPUT(j).NewValue;
                    setValue = l_translate(USER_INPUT(j).NewValue, 'decode');
                    if iscell(setValue)
                        setValue = setValue{:};
                    end
                    if isnumeric(currentLog.oldValue) && isstr(setValue)
                        setValue = str2num(setValue);
                    end
                    currentLog.setValue = setValue;
                    % skip this paramter if oldValue matches setValue
                    if isnumeric(currentLog.setValue) 
                        if currentLog.setValue == currentLog.oldValue
                            %continue;
                        end
                    elseif isstr(currentLog.setValue)
                        if strcmpi(currentLog.setValue, currentLog.oldValue)
                            %continue;
                        end
                    end
                    
                    try
                        if ~isfield(USER_INPUT(j), 'Value')
                            set_param(foundObjects(i), USER_INPUT(j).Property, currentLog.setValue);
                        elseif isempty(USER_INPUT(j).Value)
                            set_param(foundObjects(i), USER_INPUT(j).Property, currentLog.setValue);
                        else
                            currentValue = get_param(foundObjects(i), USER_INPUT(j).Property);
                            if USER_INPUT(j).Value == currentValue
                                set_param(foundObjects(i), USER_INPUT(j).Property, currentLog.setValue);
                            end
                        end
                    catch
                        errorLog = [errorLog, sprintf('\n'), lasterr];
                    end
                    currentLog.newValue = get_param(foundObjects(i), USER_INPUT(j).Property);
                else
                    [category, subParamName] = analyzeName(USER_INPUT(j).Property);
                    if strcmpi(category, 'rtwoption')  % support for rtwoption sub category
                        currentLog.NA = 0; % not Not Applicable
                        currentLog.oldValue = getrtwoption(foundObjects(i), subParamName);
                        if strcmpi(currentLog.oldValue, 'We_Can_Not_Find_The_Value')
                            currentLog.NA = 1; % Not Applicable
                            continue;
                        else
                            setValue = l_translate(USER_INPUT(j).NewValue, 'decode');
                            if iscell(setValue)
                                setValue = setValue{:};
                            end
                            if isnumeric(currentLog.oldValue) && isstr(setValue)
                                setValue = str2num(setValue);
                            end
                            currentLog.setValue = setValue;
                            % skip this paramter if oldValue matches setValue
                            if isnumeric(currentLog.setValue) 
                                if currentLog.setValue == currentLog.oldValue
                                    %continue;
                                end
                            elseif isstr(currentLog.setValue)
                                if strcmpi(currentLog.setValue, currentLog.oldValue)
                                    %continue;
                                end
                            end
                            
                            try
                                setrtwoption(foundObjects(i), subParamName, setValue);
                            catch
                                errorLog = [errorLog, sprintf('\n'), lasterr];
                            end
                            currentLog.newValue = getrtwoption(foundObjects(i), subParamName);
                        end
                    elseif strcmpi(category, 'stateflow')  % support for stateflow sub category
                        currentLog.NA = 0; % not Not Applicable
                        currentLog.oldValue = stateflowsettings('get', getfullname(foundObjects(i)), subParamName);
                        if isempty(currentLog.oldValue)
                            currentLog.NA = 1; % Not Applicable
                            continue;
                        else
                            setValue = l_translate(USER_INPUT(j).NewValue, 'decode');
                            if iscell(setValue)
                                setValue = setValue{:};
                            end
                            currentLog.setValue = setValue;
                            % skip this paramter if oldValue matches setValue
                            if isnumeric(currentLog.setValue) 
                                if currentLog.setValue == currentLog.oldValue
                                    %continue;
                                end
                            elseif isstr(currentLog.setValue)
                                if strcmpi(currentLog.setValue, currentLog.oldValue)
                                    %continue;
                                end
                            end
                            
                            try
                                stateflowsettings('set', getfullname(foundObjects(i)), subParamName, currentLog.setValue);
                            catch
                                errorLog = [errorLog, sprintf('\n'), lasterr];
                            end
                            currentLog.newValue = stateflowsettings('get', getfullname(foundObjects(i)), subParamName);
                        end
                    elseif strcmpi(category, 'makecmdption')  % support for makecmdption sub category
                        currentLog.NA = 0; % not Not Applicable
                        currentLog.oldValue = getrtwmakecmd(foundObjects(i), subParamName);
                        if strcmpi(currentLog.oldValue, 'We_Can_Not_Find_The_Value')
                            currentLog.NA = 1; % Not Applicable
                            continue;
                        else
                            setValue = l_translate(USER_INPUT(j).NewValue, 'decode');
                            if iscell(setValue)
                                setValue = setValue{:};
                            end
                            if isnumeric(currentLog.oldValue) && isstr(setValue)
                                setValue = str2num(setValue);
                            end
                            currentLog.setValue = setValue;
                            % skip this paramter if oldValue matches setValue
                            if isnumeric(currentLog.setValue) 
                                if currentLog.setValue == currentLog.oldValue
                                    %continue;
                                end
                            elseif isstr(currentLog.setValue)
                                if strcmpi(currentLog.setValue, currentLog.oldValue)
                                    %continue;
                                end
                            end
                            
                            try
                                setrtwmakecmd(foundObjects(i), subParamName, setValue, 1);
                            catch
                                errorLog = [errorLog, sprintf('\n'), lasterr];
                            end
                            currentLog.newValue = getrtwmakecmd(foundObjects(i), subParamName);
                        end
                    else
                        currentLog.NA = 1; % Not Applicable
                    end
                end
                LogforCurrentObj{length(LogforCurrentObj)+1} = currentLog;
            end
        end % end isfield
    end % for j=1:length(USER_INPUT)
    updateLog{i}.obj = foundObjects(i);
    updateLog{i}.log = LogforCurrentObj;
end
% save into HTML attic
HTMLattic('AtticData', 'updateLog', updateLog);

%undo updates
function errorLog = undoUpdates
lastupdateLog = HTMLattic('AtticData', 'updateLog');
updateLog=[];
errorLog='';
for i=1:length(lastupdateLog)
    obj = lastupdateLog{i}.obj;
    currentLog = lastupdateLog{i}.log;
    LogforCurrentObj=[];
    for j=1:length(currentLog)
        newLog=[];
        newLog.ParamName = currentLog{j}.ParamName;
        if currentLog{j}.NA
            newLog.NA = 1; % Not Applicable
        else
            newLog.NA = 0;
            newLog.oldValue = currentLog{j}.setValue;
            newLog.setValue = currentLog{j}.oldValue;
            try
                [category, subParamName] = analyzeName(currentLog{j}.ParamName);
                if strcmpi(category, 'rtwoption')  % support for rtwoption sub category                
                    setrtwoption(obj, subParamName, currentLog{j}.oldValue);                    
                elseif strcmpi(category, 'stateflow')  % support for stateflow sub category
                    stateflowsettings('set', getfullname(obj), subParamName, currentLog{j}.oldValue);
                elseif strcmpi(category, 'makecmdption')  % support for makecmdption sub category                
                    setrtwmakecmd(obj, subParamName, currentLog{j}.oldValue); 
                else
                    set_param(obj, currentLog{j}.ParamName, currentLog{j}.oldValue);
                end
            catch
                errorLog = [errorLog, sprintf('\n'), lasterr];
            end
            if strcmpi(category, 'rtwoption')  % support for rtwoption sub category                
                newLog.newValue = getrtwoption(obj, subParamName);                    
            elseif strcmpi(category, 'stateflow')  % support for stateflow sub category
                newLog.newValue = stateflowsettings('get', getfullname(obj), subParamName);
            elseif strcmpi(category, 'makecmdption')  % support for makecmdption sub category                
                newLog.newValue = getrtwmakecmd(obj, subParamName);                    
            else
                newLog.newValue = get_param(obj, currentLog{j}.ParamName);
            end
        end
        LogforCurrentObj{length(LogforCurrentObj)+1} = newLog;
    end
    updateLog{i}.obj = obj;
    updateLog{i}.log = LogforCurrentObj;
end
% save into HTML attic
HTMLattic('AtticData', 'updateLog', updateLog);

% this function will translate between HTML page display and internal
% representive. i.e., "Yes"<->1 "No <->0
function output = l_translate(input, choice)
Table = ...
    { 'Yes' '1';...
      'No' '0';...
  };
input = num2str(input);
output = input;
switch choice
    case 'encode'
        for i=1:length(Table)
            if strcmpi(Table(i,2), input)
                output = Table(i,1);
                return
            end
        end
    case 'decode'
        for i=1:length(Table)
            if strcmpi(Table(i,1), input)
                output = Table(i,2);
                output = str2num(output{:});
                return
            end
        end
    otherwise
end


% translate high level configure into low level paramer settings
function USER_INPUT = HighLevel2LowLevelConfig(HighLevelConfiguration)
USER_INPUT = [];
TargetApp.FloatPoint = {
    '', 'rtwoption_PurelyIntegerCode', 'No';
};
TargetApp.FixedPoint = {
    '', 'rtwoption_PurelyIntegerCode', 'Yes';
};
TargetApp.Mixed = TargetApp.FloatPoint;
MaxEfficiency.Yes = {
    '', 'BlockReductionOpt', 'on';
    '', 'rtwoption_ZeroExternalMemoryAtStartup', 'No';
    '', 'rtwoption_ZeroInternalMemoryAtStartup', 'No';
    '', 'rtwoption_InitFltsAndDblsToZero', 'No';
    '', 'RTWInlineParameters', 'on';
    '', 'ParameterPooling', 'on';
    '', 'rtwoption_InlinedParameterPlacement', 'NonHierarchical';
    '', 'OptimizeBlockIOStorage', 'on';
    '', 'rtwoption_LocalBlockOutputs', 'Yes';
    '', 'BufferReuse', 'on';
    '', 'RTWExpressionDepthLimit', 'Yes';
    '', 'rtwoption_EnforceIntegerDowncast', 'No';
    '', 'rtwoption_FoldNonRolledExpr', 'Yes';
    '', 'BooleanDataType', 'on';
    '', 'rtwoption_InlineInvariantSignals', 'Yes';
    '', 'rtwoption_MultiInstanceERTCode', 'No';
    '', 'rtwoption_SuppressErrorStatus', 'Yes';
    '', 'rtwoption_CombineOutputUpdateFcns', 'Yes';
    '', 'rtwoption_IncludeMdlTerminateFcn', 'No';
    '', 'ConditionallyExecuteInputs', 'on';
    '', 'rtwoption_MatFileLogging', 'No';
};
MaxEfficiency.No = {
};
RAMROM.RAM = {
    '', 'stateflow_statebitsets', 'Yes';
    '', 'stateflow_databitsets', 'Yes';
};
RAMROM.ROM = {
    '', 'stateflow_statebitsets', 'No';
    '', 'stateflow_databitsets', 'No';
};

IncludeComment.Yes = {
    '', 'rtwoption_GenerateComments', 'Yes';
};
IncludeComment.No = {
    '', 'rtwoption_GenerateComments', 'No';
};

CombineModels.Yes = {
    '', 'rtwoption_PrefixModelToSubsysFcnNames', 'Yes';
};

CombineModels.No = {
    '', 'rtwoption_PrefixModelToSubsysFcnNames', 'No';
};

IDVerbose.Verbose = {
    '', 'rtwoption_IncHierarchyInIds', 'Yes';
    '', 'rtwoption_IncDataTypeInIds', 'Yes';
};
IDVerbose.Compact = {
    '', 'rtwoption_IncHierarchyInIds', 'No';
    '', 'rtwoption_IncDataTypeInIds', 'No';
};

RequiredInterface.None = {
    '', 'rtwoption_ExtMode', 'No';
};

RequiredInterface.ASAP2 = {
    '', 'rtwoption_GenerateASAP2', 'Yes';
    '', 'rtwoption_ExtMode', 'No';
};

RequiredInterface.ExtMode = {
    '', 'rtwoption_ExtMode', 'Yes';
};

RequiredInterface.CAPI = {
    '', 'makecmdption_BlockIOSignals', 'Yes';
    '', 'makecmdption_ParameterTuning', 'Yes';
    '', 'rtwoption_ExtMode', 'No';
};

GenerateReport.Yes = {
    '', 'rtwoption_GenerateReport', 'Yes';
};

GenerateReport.No = {
    '', 'rtwoption_GenerateReport', 'No';
};

switch HighLevelConfiguration.TargetApp
    case 'Floating point'
        USER_INPUT = Options2UserInput(USER_INPUT, TargetApp.FloatPoint);
    case 'Fixed point'
        USER_INPUT = Options2UserInput(USER_INPUT, TargetApp.FixedPoint);
    case 'Mixed'
        USER_INPUT = Options2UserInput(USER_INPUT, TargetApp.Mixed);
end

switch HighLevelConfiguration.MaxEfficiency
    case 'Yes'
        USER_INPUT = Options2UserInput(USER_INPUT, MaxEfficiency.Yes);
    case 'No'
        USER_INPUT = Options2UserInput(USER_INPUT, MaxEfficiency.No);
end

switch HighLevelConfiguration.RAMROM
    case 'RAM'
        USER_INPUT = Options2UserInput(USER_INPUT, RAMROM.RAM);
    case 'ROM'
        USER_INPUT = Options2UserInput(USER_INPUT, RAMROM.ROM);
end

switch HighLevelConfiguration.IDVerbose
    case 'Verbose'
        USER_INPUT = Options2UserInput(USER_INPUT, IDVerbose.Verbose);
    case 'Compact'
        USER_INPUT = Options2UserInput(USER_INPUT, IDVerbose.Compact);
end


switch HighLevelConfiguration.IncludeComment
    case 'Yes'
        USER_INPUT = Options2UserInput(USER_INPUT, IncludeComment.Yes);
    case 'No'
        USER_INPUT = Options2UserInput(USER_INPUT, IncludeComment.No);
end

switch HighLevelConfiguration.CombineModels
    case 'Yes'
        USER_INPUT = Options2UserInput(USER_INPUT, CombineModels.Yes);
    case 'No'
        USER_INPUT = Options2UserInput(USER_INPUT, CombineModels.No);
end

switch HighLevelConfiguration.RequiredInterface
    case 'None'
        USER_INPUT = Options2UserInput(USER_INPUT, RequiredInterface.None);
    case 'ASAP2'
        USER_INPUT = Options2UserInput(USER_INPUT, RequiredInterface.ASAP2);
    case 'External mode'
        USER_INPUT = Options2UserInput(USER_INPUT, RequiredInterface.ExtMode);
    case 'C API'
        USER_INPUT = Options2UserInput(USER_INPUT, RequiredInterface.CAPI);
end

switch HighLevelConfiguration.GenerateReport
    case 'Yes'
        USER_INPUT = Options2UserInput(USER_INPUT, GenerateReport.Yes);
    case 'No'
        USER_INPUT = Options2UserInput(USER_INPUT, GenerateReport.No);
end

function OUTPUT = Options2UserInput(INPUT, OptionsGroup)
OUTPUT = INPUT;
count = length(OUTPUT);
[col, row] = size(OptionsGroup);
for i=1:col
    temp = OptionsGroup(i, 2);
    OUTPUT(count+i).Property = temp{:};
    OUTPUT(count+i).IsorNot = 1;
    OUTPUT(count+i).paramChecked = 1;
    temp = OptionsGroup(i, 3);
    OUTPUT(count+i).NewValue = temp{:};
end

% ====================================================================
function l_closeSimPrmDlg(hModel)

% Find handle to Simulation Parameters dialog
hSimPrmDlg = findall(0, 'Type', 'figure', ...
  'Name', sprintf('Simulation Parameters: %s', get_param(hModel, 'Name')));

% If SimParamDialog is open, prompt user to close it before continuing
for i = 1:length(hSimPrmDlg)
  if strcmp(get(hSimPrmDlg(i), 'Visible'), 'on')
    simprm('show', hSimPrmDlg(i));
    qString = 'The Simulation Parameters dialog box needs to be closed before continuing.';
    errordlg(qString);
    waitfor(hSimPrmDlg(i), 'Visible', 'off');
  end
end

% ====================================================================
function refreshRTWOptions(hModel)
% Ensure that Sim Param Dialog is closed for this model
l_closeSimPrmDlg(hModel);

% Open new Sim Param Dialog on RTW pane and press "OK" ==> update RTWOptions
oldSimParamPage = get_param(hModel, 'SimParamPage');
set_param(hModel, 'SimParamPage', 'RTW');
hSimPrmDlg = simprm('create', hModel);
set(hSimPrmDlg, 'Visible', 'off');
simprm('SystemButtons', 'OK', hSimPrmDlg);
set_param(hModel, 'SimParamPage', oldSimParamPage);
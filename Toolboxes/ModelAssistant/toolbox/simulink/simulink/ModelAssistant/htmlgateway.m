function htmlgateway(actionString)
% it inteprets HTML form info into m function arguments.
% Usage in HTML file:
%    <form method="POST" action="matlab: htmlgateway ">

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:15 $

% get rid of leading "?" 
%varargin{:}
%actionString  %debug info
actionString = strtok(actionString, '?');

argumentString = '';
argumentsArray = {};
positiveArgumentsArray={};
negativeArgumentsArray={};

idx = 1;
%CaseSensitive = 0;
%Grammar = 'ContainsWord';
%ShowDialogParam = 0;
%SearchAnnotation = 0;
%SearchSignal = 0;
%SearchBlock = 1;
%ShowFullName = 1;
% if an checkbox in HTML is NOT checked, nothing would be send to backend
% CGI program, so we need following code to indicate this situation.
PreserveCase = -1;
CaseSensitive = -1;
Grammar = 'ContainsWord';
ShowDialogParam = -1;
SearchAnnotation = -1;
SearchSignal = -1;
SearchBlock = -1;
SearchData = -1;
ShowFullName = -1;
%SearchPort = -1;
SearchInport = -1;
SearchOutport = -1;
SearchParamValue = -1;
SearchSignalName = -1;
% arguments for fuzzy search
fuzzySearch = -1;
fuzzyParameter = '';
fuzzyValue = '';
fuzzyReplaceValue = '';
DialogPrompt='';


ButtonClicked = 'Search';
ActionScope = 'withinModel';
lastfoundObjectsStruct = HTMLattic('AtticData', 'FOUND_OBJECTS');
for i=1:length(lastfoundObjectsStruct)
    lastfoundObjectsStruct(i).checked = 0; % reset to 0
end

% record user input from HTML page
USER_INPUT = [];

while (length(actionString) > 0)
    [tokenElement, actionString] = strtok(actionString, '&');
    [elementName, elementValue] = analyzeToken(tokenElement);
    % ignore submitButton 
    switch elementName
        case 'submitButton'
            ButtonClicked = 'Search';
            continue;
        case 'updateButton'
            ButtonClicked = 'Update';
            continue;
        case 'researchButton'
            ButtonClicked = 'ReSearch';
            continue;
        case 'research2Button'
            ButtonClicked = 'ReSearch2';
            continue;
        case 'showParamvalueButton'
            ButtonClicked = 'ShowParamValue';
            continue
        case 'gotoupdateButton'
            ButtonClicked = 'GotoUpdatePage';
            continue
        case 'paramSearchButton'
            ButtonClicked = 'paramSearchButton';
            continue
        case 'undoButton'
            ButtonClicked = 'Undo';
            continue
        case 'continuedoButton'
            ButtonClicked = 'ContinueDoUpdate';
            continue
        case 'newsearchButton'
            ButtonClicked = 'NewSearch';
            continue
        case 'frequentTaskButton'
            ButtonClicked = 'frequentTask';  % frequent task button clicked
            continue
        case 'frequentFindTaskButton'
            ButtonClicked = 'frequentFindTask';
            continue
        case 'textSearchButton'
            ButtonClicked = 'textSearchButton';
            continue
        case 'TextupdateButton'
            ButtonClicked = 'TextupdateButton';
            continue
        case 'sfSearchButton'
            ButtonClicked = 'SearchStateflow';
            continue
        case 'Model'    
            HTMLattic('AtticData', 'model', elementValue); % update model/subsystem
            createStartInSystemTemplate;
        case 'ActionScope'
            ActionScope = elementValue;
        case 'PreserveCase'
            if strcmpi(elementValue, 'on')
                PreserveCase = 1;
            else
                PreserveCase = 0;
            end
        case 'MatchCase'
            if strcmpi(elementValue, 'on')
                CaseSensitive = 1;
            else
                CaseSensitive = 0;
            end
        case 'Grammar'
            if strcmpi(elementValue, 'Contains word')
                Grammar = 'ContainsWord';
            elseif  strcmpi(elementValue, 'Match whole word')
                Grammar = 'MatchWholeWord';
            else
                Grammar = 'RegularExpression';
            end
        case 'ShowDialogParam'
            if strcmpi(elementValue, 'on')
                ShowDialogParam = 1;
            else
                ShowDialogParam = 0;
            end
        case 'ShowFullName'
            if strcmpi(elementValue, 'on')
                ShowFullName = 1;
            else
                ShowFullName = 0;
            end
        case 'SearchAnnotation'
            if strcmpi(elementValue, 'on')
                SearchAnnotation = 1;
            else
                SearchAnnotation = 0;
            end
        case 'SearchSignal'
            if strcmpi(elementValue, 'on')
                SearchSignal = 1;
            else
                SearchSignal = 0;
            end
        case 'SearchBlock'
            if strcmpi(elementValue, 'on')
                SearchBlock = 1;
            else
                SearchBlock = 0;
            end
        case 'SearchInport'
            if strcmpi(elementValue, 'on')
                SearchInport = 1;
            else
                SearchInport = 0;
            end
        case 'SearchOutport'
            if strcmpi(elementValue, 'on')
                SearchOutport = 1;
            else
                SearchOutport = 0;
            end
        case 'SearchParamValue'
            if strcmpi(elementValue, 'on')
                SearchParamValue = 1;
            else
                SearchParamValue = 0;
            end
            HTMLattic('AtticData', 'SearchParamValue', SearchParamValue);
        case 'SearchSignalName'
            if strcmpi(elementValue, 'on')
                SearchSignalName = 1;
            else
                SearchSignalName = 0;
            end
            HTMLattic('AtticData', 'SearchSignalName', SearchSignalName);
        case 'SearchData'
            if strcmpi(elementValue, 'on')
                SearchData = 1;
            else
                SearchData = 0;
            end
            HTMLattic('AtticData', 'SearchData', SearchData);
        case 'fuzzySearch'
            if strcmpi(elementValue, 'on')
                fuzzySearch = 1;
            else
                fuzzySearch = 0;
            end
        case 'fuzzyParameter'
            fuzzyParameter = elementValue;
            if ~isempty(fuzzyParameter)
                fuzzySearch = 1;    % whenever it's not empty
            end
        case 'fuzzyValue'
            fuzzyValue = elementValue;
            if ~isempty(fuzzyValue)
                fuzzySearch = 1;    % whenever it's not empty
            end
        case 'fuzzyReplaceValue'
            fuzzyReplaceValue = elementValue;
        case 'DialogPrompt'
            DialogPrompt = elementValue;
        otherwise 
            % process element based on their name
            [category, serialNum] = analyzeName(elementName);
            serialNum = str2num(serialNum);
            switch category
                case 'Property'
                    USER_INPUT(serialNum).Property = elementValue;
                case 'IsorNot'
                    if strcmpi(elementValue, 'is')
                        USER_INPUT(serialNum).IsorNot = 1;
                    else
                        USER_INPUT(serialNum).IsorNot = 0;
                    end
                case 'Value'
                    USER_INPUT(serialNum).Value = elementValue;
                case 'NewValue'
                    USER_INPUT(serialNum).NewValue = elementValue;
                case 'foundObjChecked'
                    lastfoundObjectsStruct(serialNum).checked = 1;
                case 'paramChecked'
                    if strcmpi(elementValue, 'on')
                        USER_INPUT(serialNum).paramChecked = 1;
                    else
                        USER_INPUT(serialNum).paramChecked = 0;
                    end
                otherwise
            end
    end
    %get rid of leading "&" of remain part
    actionString = actionString(2:end);;
end

model = HTMLattic('AtticData', 'model');
if isempty(model)
    error('Please use SearchConfigWizard.m to start search');
    return
end

% save USER_INPUT into HTML attic
HTMLattic('AtticData', 'USER_INPUT', USER_INPUT);
HTMLattic('AtticData', 'ButtonClicked', ButtonClicked);

% if an checkbox in HTML is NOT checked, nothing would be send to backend
% CGI program, so we need following code to indicate this situation.
if PreserveCase == -1
    PreserveCase = 0;
end
if CaseSensitive == -1
    CaseSensitive = 0;
end
%Grammar = 'ContainsWord';
if ShowDialogParam == -1
    ShowDialogParam = 0;
end
if SearchAnnotation == -1
    SearchAnnotation = 0;
end
if SearchSignal == -1
    SearchSignal = 0;
end
if SearchBlock == -1
    SearchBlock = 0;
end
if SearchInport == -1
    SearchInport = 0;
end
if SearchOutport == -1
    SearchOutport = 0;
end
if ShowFullName == -1
    ShowFullName = 0;
end

if SearchParamValue == -1;
    SearchParamValue = 0;
end

if SearchSignalName == -1;
    SearchSignalName = 0;
end

% save user input fuzzy value pair for future usage
if isempty(fuzzyParameter) && isempty(fuzzyValue)
    fuzzySearch = 0;
else
    fuzzySearch = 1;
end

if fuzzySearch
    HTMLattic('AtticData', 'fuzzyParameter', fuzzyParameter);
    HTMLattic('AtticData', 'fuzzyValue', fuzzyValue);
else
    HTMLattic('AtticData', 'fuzzyParameter', '');
    HTMLattic('AtticData', 'fuzzyValue', '');
end

%  Start timer
overtimeCtl('start');  



% calculate full collection of objects
fullObjectCollection = getAllObjectsofModel(model);

% calculate full collection of stateflow objects
fullsfObjectCollection = getAllsfObjectsofModel(model);

switch ButtonClicked
    case 'NewSearch'
        model = HTMLattic('AtticData', 'model');
        SearchConfigWizard(model);
        return
    case 'SearchStateflow'
        HTMLattic('AtticData', 'ShowFullName', ShowFullName);
        HTMLattic('AtticData', 'CaseSensitive', CaseSensitive);
        HTMLattic('AtticData', 'Grammar', Grammar);

        [positiveArgumentsArray, negativeArgumentsArray] = UserInput2argumetlist(USER_INPUT);
        % issue search 
        foundObjects = findsfSystem(model, CaseSensitive, Grammar, positiveArgumentsArray{:});
          % search for negative group
          foundNObjects=[];
          for i=1:2:length(negativeArgumentsArray)
              foundNObjects{i} = findsfSystem(model, CaseSensitive, Grammar, negativeArgumentsArray{i:i+1});
          end
          foundNObjSum=[];
          for i=1:length(foundNObjects)
              foundNObjSum = union(foundNObjSum, foundNObjects{i});
          end
          foundNObjSum = setdiff(fullsfObjectCollection, foundNObjSum);
        foundObjects = intersect(foundObjects, foundNObjSum);
        
        % save foundObjects into HTML attic
        %savefoundsfObjects(foundObjects);
        savefoundObjects(foundObjects, [], []);
        CreateUpdatePage(foundObjects, [], []);
        browser(HTMLattic('AtticData', 'UpdatePage'));              
    case 'textSearchButton'
        HTMLattic('AtticData', 'ShowFullName', ShowFullName);
        [foundObjects, foundParameters, origValue, newValue] = ...
            fuzzyTextfindnReplace(fuzzyValue, fuzzyReplaceValue, CaseSensitive, PreserveCase, ...
            Grammar, SearchParamValue, SearchSignalName,fullObjectCollection(:));
        savefoundObjects(foundObjects, [], []);
        HTMLattic('AtticData', 'TextSearchfoundParameters', foundParameters);
        HTMLattic('AtticData', 'TextSearchorigValue', origValue);
        HTMLattic('AtticData', 'TextSearchnewValue', newValue);
        CreateTextSearchUpdatePage(foundObjects, foundParameters, origValue, newValue);
        browser(HTMLattic('AtticData', 'TextSearchUpdatePage'));
    case {'Search' 'paramSearchButton' 'frequentFindTask'}
        if strcmp(ButtonClicked, 'frequentFindTask')
            CaseSensitive = 1;
            SearchBlock = 1;
            SearchInport = 1;
            SearchOutport = 1;
            ShowFullName = 1;
        end
        
        HTMLattic('AtticData', 'CaseSensitive', CaseSensitive);
        HTMLattic('AtticData', 'Grammar', Grammar);
        HTMLattic('AtticData', 'ShowDialogParam', ShowDialogParam);
        HTMLattic('AtticData', 'SearchAnnotation', SearchAnnotation);
        HTMLattic('AtticData', 'SearchSignal', SearchSignal);
        HTMLattic('AtticData', 'SearchBlock', SearchBlock);
        HTMLattic('AtticData', 'SearchInport', SearchInport);
        HTMLattic('AtticData', 'SearchOutport', SearchOutport);
        HTMLattic('AtticData', 'ShowFullName', ShowFullName);
        
        HTMLattic('AtticData', 'updateLog', []); % clean up
        
        %argumentsArray = UserInput2argumetlist(USER_INPUT);
        % Search algorithm:
        %   A.B.(-C).(-D) => A.B.(-(C+D))
        % parse input arguments into "positive" and "negative" groups
        [positiveArgumentsArray, negativeArgumentsArray] = UserInput2argumetlist(USER_INPUT);
        % issue search 
        % now begin search for "positive" group  
        %%%[foundObjects, foundParameters]= findSystem(model, CaseSensitive, Grammar, SearchAnnotation, SearchSignal, SearchBlock, fuzzySearch, fuzzyParameter, fuzzyValue, positiveArgumentsArray{:});
        foundObjects = findSystem(model, CaseSensitive, Grammar, SearchAnnotation, SearchSignal, SearchBlock, SearchInport, SearchOutport, positiveArgumentsArray{:});
          % search for negative group
          foundNObjects=[];
          for i=1:2:length(negativeArgumentsArray)
              foundNObjects{i} = findSystem(model, CaseSensitive, Grammar, SearchAnnotation, SearchSignal, SearchBlock, SearchInport, SearchOutport, negativeArgumentsArray{i:i+1});
          end
          foundNObjSum=[];
          for i=1:length(foundNObjects)
              foundNObjSum = union(foundNObjSum, foundNObjects{i});
          end
          foundNObjSum = setdiff(fullObjectCollection, foundNObjSum);
        foundObjects = intersect(foundObjects, foundNObjSum);
        
        if strcmp(ButtonClicked, 'frequentFindTask')
            if ~isempty(foundObjects)
                fuzzySearch = 0;  % don't do fuzzysearch in case foundObjects empty
            end
            [foundObjects, foundParameters] = fuzzyfindSystem(fuzzySearch, fuzzyParameter, fuzzyValue, 2, foundObjects(:));
        else
            [foundObjects, foundParameters] = fuzzyfindSystem(fuzzySearch, fuzzyParameter, fuzzyValue, 0, foundObjects(:));
        end
            
        % process search for dialog prompts, in fact, it's a subset of fuzzy
        % Search
        foundDialogParameters = [];
        if ~isempty(DialogPrompt)
            [foundObjects, foundDialogParameters] = fuzzyfindSystem(1, '', DialogPrompt, 1, foundObjects(:));
        end
        
        % save foundObjects into HTML attic
        savefoundObjects(foundObjects, foundParameters, foundDialogParameters);
        if strcmp(ButtonClicked, 'Search') || strcmp(ButtonClicked, 'frequentFindTask')
            CreateSearchResultPage(foundObjects, foundParameters, foundDialogParameters);
            browser(HTMLattic('AtticData', 'SearchResultPage'));
        else
            CreateParameterSearchResultPage(foundObjects, foundParameters, foundDialogParameters);
            browser(HTMLattic('AtticData', 'ParameterSearchResultPage'));
        end
    case 'ShowParamValue'
        lastfoundObjects=[];
        for i=1:length(lastfoundObjectsStruct)
            if lastfoundObjectsStruct(i).checked % minus user unchecked objects
                lastfoundObjects(length(lastfoundObjects)+1) = lastfoundObjectsStruct(i).handle;
            end
        end
        foundDialogParameters = HTMLattic('AtticData', 'FOUND_DIALOG_PARAMETERS');
        CreateSearchResultPage(lastfoundObjects, [], foundDialogParameters);
        browser(HTMLattic('AtticData', 'SearchResultPage'));      
    case 'GotoUpdatePage'
        lastfoundObjects=[];
        for i=1:length(lastfoundObjectsStruct)
            if lastfoundObjectsStruct(i).checked % minus user unchecked objects
                lastfoundObjects(length(lastfoundObjects)+1) = lastfoundObjectsStruct(i).handle;
            end
        end
        [foundObjects, foundParameters] = fuzzyfindSystem(fuzzySearch, fuzzyParameter, fuzzyValue, 0, lastfoundObjects(:));
        % process search for dialog prompts, in fact, it's a subset of fuzzy
        % Search
        foundDialogParameters = [];
        if ~isempty(DialogPrompt)
            [foundObjects, foundDialogParameters] = fuzzyfindSystem(1, '', DialogPrompt, 1, foundObjects(:));
        end
        % save foundObjects into HTML attic
        savefoundObjects(foundObjects, foundParameters, foundDialogParameters);

        %foundDialogParameters = HTMLattic('AtticData', 'FOUND_DIALOG_PARAMETERS');
        %CreateUpdatePage(lastfoundObjects, [], foundDialogParameters);
        CreateUpdatePage(foundObjects, [], foundDialogParameters);
        browser(HTMLattic('AtticData', 'UpdatePage'));              
    case {'ReSearch' 'ReSearch2'}
        if strcmpi(ButtonClicked, 'ReSearch')
            HTMLattic('AtticData', 'CaseSensitive', CaseSensitive);
            HTMLattic('AtticData', 'Grammar', Grammar);
            HTMLattic('AtticData', 'ShowDialogParam', ShowDialogParam);
            HTMLattic('AtticData', 'SearchAnnotation', SearchAnnotation);
            HTMLattic('AtticData', 'SearchSignal', SearchSignal);
            HTMLattic('AtticData', 'SearchBlock', SearchBlock);
            HTMLattic('AtticData', 'SearchInport', SearchInport);
            HTMLattic('AtticData', 'SearchOutport', SearchOutport);
            HTMLattic('AtticData', 'ShowFullName', ShowFullName);
        else
            CaseSensitive    = HTMLattic('AtticData', 'CaseSensitive');
            Grammar          = HTMLattic('AtticData', 'Grammar');
            ShowDialogParam  = HTMLattic('AtticData', 'ShowDialogParam');
            SearchAnnotation = HTMLattic('AtticData', 'SearchAnnotation');
            SearchSignal     = HTMLattic('AtticData', 'SearchSignal');
            SearchBlock      = HTMLattic('AtticData', 'SearchBlock');
            SearchInport       = HTMLattic('AtticData', 'SearchInport');
            SearchOutport       = HTMLattic('AtticData', 'SearchOutport');
            ShowFullName     = HTMLattic('AtticData', 'ShowFullName');
        end

        % check if model opened and open it if not
        %try
        %    get_param(model, 'name');
        %catch
        %    open_system(model);
        %    warndlg('Due to re-open closed model, the search result may be incorrect. To get best results, we suggest you restart search.');
        %end
        %%argumentsArray = UserInput2argumetlist(USER_INPUT);
        [positiveArgumentsArray, negativeArgumentsArray] = UserInput2argumetlist(USER_INPUT);
        % issue search 
        foundObjects = findSystem(model, CaseSensitive, Grammar, SearchAnnotation, SearchSignal, SearchBlock, SearchInport, SearchOutport, positiveArgumentsArray{:});
          % search for negative group
          foundNObjects=[];
          for i=1:2:length(negativeArgumentsArray)
              foundNObjects{i} = findSystem(model, CaseSensitive, Grammar, SearchAnnotation, SearchSignal, SearchBlock, SearchInport, SearchOutport, negativeArgumentsArray{i:i+1});
          end
          foundNObjSum=[];
          for i=1:length(foundNObjects)
              foundNObjSum = union(foundNObjSum, foundNObjects{i});
          end
          foundNObjSum = setdiff(fullObjectCollection, foundNObjSum);
        foundObjects = intersect(foundObjects, foundNObjSum);
        
        [foundObjects, foundParameters] = fuzzyfindSystem(0, '', '', 0, foundObjects(:));
        %%[foundObjects, foundParameters]= findSystem(model, CaseSensitive, Grammar, SearchAnnotation, SearchSignal, SearchBlock, 0, '', '', argumentsArray{:});
        switch ActionScope
            case 'withinResult'
                % calculate common area with last search result
                %lastfoundObjectsStruct = HTMLattic('AtticData', 'FOUND_OBJECTS');
                lastfoundObjects=[];
                for i=1:length(lastfoundObjectsStruct)
                    if lastfoundObjectsStruct(i).checked % minus user unchecked objects
                        lastfoundObjects(length(lastfoundObjects)+1) = lastfoundObjectsStruct(i).handle;
                    end
                end
                foundObjects = intersect(foundObjects, lastfoundObjects);
            case 'withinModel'
                % do nothing
            otherwise
                error('Not understandable action scope. Please re-start search by SearchConfigWizard.');
                return
        end
        %HTMLattic('AtticData', 'errorLog', '');
        %errorLog = updatefoundObjects(foundObjects, USER_INPUT);
        %HTMLattic('AtticData', 'errorLog', errorLog);
        foundDialogParameters = HTMLattic('AtticData', 'FOUND_DIALOG_PARAMETERS');
        % save foundObjects into HTML attic
        savefoundObjects(foundObjects, foundParameters, foundDialogParameters);
        CreateSearchResultPage(foundObjects, [], foundDialogParameters);
        browser(HTMLattic('AtticData', 'SearchResultPage'));      
    case {'Update' 'TextupdateButton'}
        % get check foundObjects
        %lastfoundObjects=[];
        for i=1:length(lastfoundObjectsStruct)
            if lastfoundObjectsStruct(i).checked % minus user unchecked objects
                lastfoundObjects(i) = lastfoundObjectsStruct(i).handle;
            else
                lastfoundObjects(i) = -1;
            end
        end
        % delete empty elements
        lastfoundObjects(lastfoundObjects(:)==-1)=[];
        %[foundObjects, foundParameters] = fuzzyfindSystem(fuzzySearch, fuzzyParameter, fuzzyValue, 0, lastfoundObjects(:));
        %% process search for dialog prompts, in fact, it's a subset of fuzzy
        %% Search
        %foundDialogParameters = [];
        %if ~isempty(DialogPrompt)
        %    [foundObjects, foundDialogParameters] = fuzzyfindSystem(1, '', DialogPrompt, 1, foundObjects(:));
        %end
        % save foundObjects into HTML attic
        %savefoundObjects(foundObjects, foundParameters, foundDialogParameters);        

        % save foundObjects into HTML attic
        foundObjects = lastfoundObjects;
        foundParameters = HTMLattic('AtticData', 'FOUND_PARAMETERS');
        foundDialogParameters = HTMLattic('AtticData', 'FOUND_DIALOG_PARAMETERS');
        savefoundObjects(foundObjects, foundParameters, foundDialogParameters);        
        
        HTMLattic('AtticData', 'errorLog', '');
        if strcmpi(ButtonClicked, 'Update')
            errorLog = updatefoundObjects(foundObjects, USER_INPUT);
        else
            % update for Simulink Text S&R 
            updateLog = [];
            errorLog = '';
            TextSearchfoundParameters = HTMLattic('AtticData', 'TextSearchfoundParameters');
            origValue = HTMLattic('AtticData', 'TextSearchorigValue');
            newValue = HTMLattic('AtticData', 'TextSearchnewValue');
            for i=1:length(lastfoundObjectsStruct)
                LogforCurrentObj = [];
                currentLog = [];
                if lastfoundObjectsStruct(i).checked % minus user unchecked objects
                    try
                        currentLog.NA = 0; % not Not Applicable
                        currentLog.ParamName = TextSearchfoundParameters{i};
                        currentLog.oldValue = unifygetparam(lastfoundObjectsStruct(i).handle, TextSearchfoundParameters{i});
                        currentLog.setValue = newValue{i};
                        unifysetparam(lastfoundObjectsStruct(i).handle, TextSearchfoundParameters{i}, newValue{i});
                        currentLog.newValue = unifygetparam(lastfoundObjectsStruct(i).handle, TextSearchfoundParameters{i});
                        LogforCurrentObj{end+1} = currentLog;
                        updateLog{end+1}.obj = lastfoundObjectsStruct(i).handle;
                        updateLog{end}.log = LogforCurrentObj;        
                    catch
                        errorLog = [errorLog, sprintf('\n'), lasterr];
                    end
                end
            end
            HTMLattic('AtticData', 'updateLog', updateLog);
        end
        HTMLattic('AtticData', 'errorLog', errorLog);
        if strcmpi(ButtonClicked, 'Update')
            CreateUpdateResultPage;
        else
            [pathstr filename extension]=fileparts(HTMLattic('AtticData', 'SimulinkTextSearch'));
            CreateUpdateResultPage([filename extension]);
        end
        browser(HTMLattic('AtticData', 'UpdateResultPage'));              
    case 'ContinueDoUpdate'
        foundObjects = HTMLattic('AtticData', 'FOUND_OBJECTS');
        foundDialogParameters = HTMLattic('AtticData', 'FOUND_DIALOG_PARAMETERS');
        CreateUpdatePage(foundObjects, [], foundDialogParameters);
        browser(HTMLattic('AtticData', 'UpdatePage'));                      
    case 'Undo'
        errorLog = undoUpdates;
        HTMLattic('AtticData', 'errorLog', errorLog);
        CreateUpdateResultPage;
        browser(HTMLattic('AtticData', 'UpdateResultPage'));                      
    case 'frequentTask'
        % frequent task is applied to all objects by default
        %foundObjects = findSystem(model, 0, 'ContainsWord', 0, 0, 1, 0, 0, 'BlockType', ''); %find all blocks
        foundObjects = findSystem(model, 0, 'ContainsWord', 0, 0, 1, 0, 1); %find all blocks and output ports
        % save foundObjects into HTML attic
        savefoundObjects(foundObjects, [], []);        
        HTMLattic('AtticData', 'ShowFullName', 1);
        HTMLattic('AtticData', 'errorLog', '');
        errorLog = updatefoundObjects(foundObjects, USER_INPUT);
        HTMLattic('AtticData', 'errorLog', errorLog);
        CreateUpdateResultPage;
        browser(HTMLattic('AtticData', 'UpdateResultPage'));              
    otherwise
        error('Unexpected button clicked. Please re-start search by SearchConfigWizard.');
        return
end


% close timer/dialog
overtimeCtl('close');

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
            % when user say "param isnot value", limit the search inside objects has this param 
            positiveArgumentsArray{length(positiveArgumentsArray)+1} = USER_INPUT(i).Property;
            positiveArgumentsArray{length(positiveArgumentsArray)+1} = '';
        end
    end
end

% save found objects into HTML attic
function savefoundObjects(foundObjects, foundParameters, foundDialogParameters)
FOUND_OBJECTS = [];
for i=1:length(foundObjects)
    if isa(foundObjects(i), 'Stateflow.Data')
        FOUND_OBJECTS(i).handle = foundObjects(i).handle;
        FOUND_OBJECTS(i).checked = 1; % init to true
        FOUND_OBJECTS(i).fullname = foundObjects(i).getFullName;
        FOUND_OBJECTS(i).name = foundObjects(i).name;
    else
        FOUND_OBJECTS(i).handle = get_param(foundObjects(i), 'handle');
        FOUND_OBJECTS(i).checked = 1; % init to true
        FOUND_OBJECTS(i).fullname = getfullname(foundObjects(i));
        FOUND_OBJECTS(i).name = get_param(foundObjects(i),'name');
    end
end
HTMLattic('AtticData', 'FOUND_OBJECTS', FOUND_OBJECTS);        
HTMLattic('AtticData', 'FOUND_PARAMETERS', foundParameters);
HTMLattic('AtticData', 'FOUND_DIALOG_PARAMETERS', foundDialogParameters);

% save found sf objects into HTML attic
function savefoundsfObjects(foundObjects)
FOUND_OBJECTS = [];
for i=1:length(foundObjects)
    FOUND_OBJECTS(i).handle = foundObjects(i).handle;
    FOUND_OBJECTS(i).checked = 1; % init to true
    FOUND_OBJECTS(i).fullname = foundObjects(i).getFullName;
    FOUND_OBJECTS(i).name = foundObjects(i).name;
end
HTMLattic('AtticData', 'FOUND_OBJECTS', FOUND_OBJECTS);        

% update object property based on user input
function errorLog = updatefoundObjects(foundObjects, USER_INPUT)
updateLog=[];
errorLog='';
for i=1:length(foundObjects)
    LogforCurrentObj=[];
    %fp = get_param(foundObjects(i), 'ObjectParameters');
    for j=1:length(USER_INPUT)
        currentLog=[]; 
        if isfield(USER_INPUT(j), 'Property') && isfield(USER_INPUT(j), 'NewValue') && isfield(USER_INPUT(j), 'paramChecked')
            if ~isempty(USER_INPUT(j).Property) && ~isempty(USER_INPUT(j).NewValue) && ~isempty(USER_INPUT(j).paramChecked)
                currentLog.ParamName = USER_INPUT(j).Property; % always log param name
                %if isfield(fp, USER_INPUT(j).Property) && USER_INPUT(j).paramChecked
                if (isprop(foundObjects(i), USER_INPUT(j).Property) || ~isempty(strfind(USER_INPUT(j).Property, '_')))&& USER_INPUT(j).paramChecked
                    currentLog.NA = 0; % not Not Applicable
                    currentLog.oldValue = unifygetparam(foundObjects(i), USER_INPUT(j).Property);
                    currentLog.setValue = USER_INPUT(j).NewValue;
                    try
                        if ~isfield(USER_INPUT(j), 'Value')
                            unifysetparam(foundObjects(i), USER_INPUT(j).Property, USER_INPUT(j).NewValue);
                        elseif isempty(USER_INPUT(j).Value)
                            unifysetparam(foundObjects(i), USER_INPUT(j).Property, USER_INPUT(j).NewValue);
                        else
                            currentValue = unifygetparam(foundObjects(i), USER_INPUT(j).Property);
                            if USER_INPUT(j).Value == currentValue
                                unifysetparam(foundObjects(i), USER_INPUT(j).Property, USER_INPUT(j).NewValue);
                            end
                        end
                    catch
                        errorLog = [errorLog, sprintf('\n'), lasterr];
                    end
                    currentLog.newValue = unifygetparam(foundObjects(i), USER_INPUT(j).Property);
                else
                    currentLog.NA = 1; % Not Applicable
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
                unifysetparam(obj, currentLog{j}.ParamName, currentLog{j}.oldValue);
            catch
                errorLog = [errorLog, sprintf('\n'), lasterr];
            end
            newLog.newValue = unifygetparam(obj, currentLog{j}.ParamName);
        end
        LogforCurrentObj{length(LogforCurrentObj)+1} = newLog;
    end
    updateLog{i}.obj = obj;
    updateLog{i}.log = LogforCurrentObj;
end
% save into HTML attic
HTMLattic('AtticData', 'updateLog', updateLog);
    
    


% to get the collection of handles of all objects belong to a model
function objects = getAllObjectsofModel(model)
objects = [];
objects = find_system(model, 'FindAll', 'on');
for i=1:length(objects)
    % make sure get handles
    objects(i) = get_param(objects(i), 'handle');
end

% to get the collection of handles of all sf data objects belong to a model
function objects = getAllsfObjectsofModel(model)
objects = [];
sfBlocks = find_system(model, 'MaskType', 'Stateflow');
for i=1:length(sfBlocks)
    blkHandle = get_param(sfBlocks{i}, 'handle');
    subsystemObj=get_param(blkHandle, 'Object');
    chartObj = subsystemObj.getHierarchicalChildren;
    objects = [objects, chartObj.find('-isa', 'Stateflow.Data')];
end
objects = objects(:);

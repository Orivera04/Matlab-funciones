function SearchConfigWizard(varargin)
% Search and configure a model for user

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:16 $

try
    if ~usejava('swing')
        error('This tool requires Java to run.');
    end
    
    if nargin==0
        model=HTMLattic('AtticData', 'model');
        if isempty(model)
            usage;
            return
        end
    else
        model = varargin{1};
    end
    % open system if it's not opened yet.
    try 
        get_param(model, 'handle');
    catch
        open_system(model); 
    end

    
    % clean up attic for new start
    HTMLattic('clean');
    
    % record command root directory
    cmdRoot = fileparts(which('SearchConfigWizard'));
    HTMLattic('AtticData', 'cmdRoot', cmdRoot);
    
    HTMLattic('AtticData', 'model', model);
    createStartInSystemTemplate;
    
    HTMLattic('AtticData', 'FrequentTaskPage', [getModelAssistantWorkDir filesep 'frequent_task.html']);
    CreateFrequentTaskPage;
    
    HTMLattic('AtticData', 'Browser', 'java'); % use new java browser
    %HTMLattic('AtticData', 'Browser', 'helpbrowser'); % use default help browser
    
    HTMLattic('AtticData', 'TimeOut', 5); % timeout settings for search;
    TimeOut = HTMLattic('AtticData', 'TimeOut');
    overtimeCtl('setup', TimeOut);
    
    HTMLattic('AtticData', 'QuickSearch', 1);  % turn on quick search engine
    HTMLattic('AtticData', 'HideNoPromptDialogParameter', 1);  % hide dialog parameters without prompts
    
    HTMLattic('AtticData', 'model', model);
    HTMLattic('AtticData', 'SearchResultPage', [getModelAssistantWorkDir filesep 'SearchResultPage.html']);
    HTMLattic('AtticData', 'UpdatePage', [getModelAssistantWorkDir filesep 'UpdatePage.html']);
    HTMLattic('AtticData', 'UpdateResultPage', [getModelAssistantWorkDir filesep 'UpdateResultPage.html']);
    HTMLattic('AtticData', 'ParameterSearchResultPage', [getModelAssistantWorkDir filesep 'ParameterSearchResultPage.html']);

    HTMLattic('AtticData', 'StartPage', [getModelAssistantWorkDir filesep 'Start.html']);
    StartPage = HTMLattic('AtticData', 'StartPage');
    f=fopen(StartPage, 'w');
    line = createHTMLSource('startPage');
    fprintf(f, '%s', line);
    fclose(f);
    
    HTMLattic('AtticData', 'paramSearchPage1', [getModelAssistantWorkDir filesep 'parameter_search1.html']);
    paramSearchPage = HTMLattic('AtticData', 'paramSearchPage1');
    f=fopen(paramSearchPage, 'w');
    line = createHTMLSource('paramSearchPage1');
    fprintf(f, '%s', line);
    fclose(f);

    HTMLattic('AtticData', 'paramSearchPage2', [getModelAssistantWorkDir filesep 'parameter_search2.html']);
    paramSearchPage = HTMLattic('AtticData', 'paramSearchPage2');
    f=fopen(paramSearchPage, 'w');
    line = createHTMLSource('paramSearchPage2');
    fprintf(f, '%s', line);
    fclose(f);
    
    HTMLattic('AtticData', 'StateflowPage', [getModelAssistantWorkDir filesep 'Stateflow.html']);
    StateflowPage = HTMLattic('AtticData', 'StateflowPage');
    f=fopen(StateflowPage, 'w');
    line = createHTMLSource('stateflowPage');
    fprintf(f, '%s', line);
    fclose(f);
    
    HTMLattic('AtticData', 'TextSearchUpdatePage', [getModelAssistantWorkDir filesep 'SimulinkTextSearchUpdate.html']);
    HTMLattic('AtticData', 'SimulinkTextSearch', [getModelAssistantWorkDir filesep 'SimulinkTextSearch.html']);
    SimulinkTextSearchPage = HTMLattic('AtticData', 'SimulinkTextSearch');
    f=fopen(SimulinkTextSearchPage, 'w');
    line = createHTMLSource('SimulinkTextSearch');
    fprintf(f, '%s', line);
    fclose(f);

    browser(StartPage);
catch
    error(lasterr);
    usage;
end

return

function usage
disp('SearchConfigWizard: Start new search on current system.');
disp('SearchConfigWizard(modelName): Search and configure model, using temp directory as working directory.');
disp('SearchConfigWizard(modelName, d:\workingDir):   using given full name directory as working directory.');
disp('SearchConfigWizard(modelName, workingDir):      using current_dir/workingDir as working directory.');
return


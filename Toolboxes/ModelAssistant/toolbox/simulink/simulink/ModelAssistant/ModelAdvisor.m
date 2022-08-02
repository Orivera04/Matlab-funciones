function ModelAdvisor(varargin)
% Model configure advisor for user

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
    
    %% use space to replace carriage return
    %model = strrep(model, sprintf('\n'), ' ');
    HTMLattic('AtticData', 'model', model);
    createStartInSystemTemplate;

    
    % addpath for fixpt detective utility
    addpath([HTMLattic('AtticData', 'cmdRoot') filesep 'fixpt']);
    
    HTMLattic('AtticData', 'Browser', 'java'); % use new java browser
    %HTMLattic('AtticData', 'Browser', 'helpbrowser'); % use default help browser
    HTMLattic('AtticData', 'ShowFullName', 1); % show full name of objects
    
    HTMLattic('AtticData', 'model', model);
   
    HTMLattic('AtticData', 'AdvisorTemplatePage', [HTMLattic('AtticData', 'cmdRoot') filesep 'model_advisor_template.html']);
    HTMLattic('AtticData', 'AdvisorStartPage', [getModelAssistantWorkDir filesep 'model_advisor.html']);
    
    HTMLattic('AtticData', 'DetailConfigureTemplatePage', [HTMLattic('AtticData', 'cmdRoot') filesep 'model_detail_config_template.html']);
    HTMLattic('AtticData', 'DetailConfigurePage', [getModelAssistantWorkDir filesep 'model_detail_config.html']);
    
    HTMLattic('AtticData', 'DiagnoseTemplatePage', [HTMLattic('AtticData', 'cmdRoot') filesep 'model_diagnose_template.html']);
    HTMLattic('AtticData', 'DiagnoseStartPage', [getModelAssistantWorkDir filesep 'model_diagnose.html']);
    HTMLattic('AtticData', 'DiagnoseResultPage', [getModelAssistantWorkDir filesep 'model_diagnose_result.html'])
    HTMLattic('AtticData', 'UpdateResultPage', [getModelAssistantWorkDir filesep 'model_update_result.html'])
    
    createAdvisorStartPage;
    %createDetailConfigurePage;
    createDiagnoseStartPage; 
    if nargin==1
        % show start page
        browser(HTMLattic('AtticData', 'AdvisorStartPage'));
    end
catch
    error(lasterr);
    usage;
end

return

% end of main function

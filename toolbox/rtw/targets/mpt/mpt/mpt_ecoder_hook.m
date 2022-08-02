function s = mpt_ecoder_hook(hook, modelName)
%MPT_ECODER_HOOK: Used by the Module Packaging Tool to hook
%  cleanly into Real-Time Workshop build process from make_ecoder_hook.
%

%   Steve Toeppe
%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.2.4.8 $
%   $Date: 2004/04/15 00:27:28 $
  
% Assert that the target is not Model Reference Sim Target
modelRefTargetType = get_param(modelName, 'ModelReferenceTargetType');
if strcmp(modelRefTargetType,'SIM')
  assertMsg = 'Assertion: This hook file should not be called for Model Reference Sim Target';
  error(assertMsg);
end

simulationMode = get_param(modelName,'SimulationMode');
if strcmp(simulationMode,'normal') == 1
    switch hook
        case 'entry'
            [errStatus,errMsg] = error_checker(1, modelName, 'editvalid');
            if errStatus == 0
                error(['Error', errMsg]);
            end
            ec_apply_tune_display_rules(modelName);
            ec_apply_name_rules(modelName);
            ec_scope_listener_attach(modelName);
            ec_symbol_db;
            ec_symbol_db_reg;
            ec_create_type_obj;
        case 'before_tlc'

            templateList=[];

            modelReferenceTargetType = get_param(modelName, 'ModelReferenceTargetType');
            if strcmp(modelReferenceTargetType,'NONE') == 1
                init_mpm_from_rtw(modelName,templateList);
            end
        case 'after_tlc'
            ec_deapply_name_rules(modelName);
            ec_deapply_tune_display_rules(modelName);

        case 'before_make'
        case 'after_make'
        case 'exit'
            cleanup_memory;

        otherwise
    end

end


function cleanup_memory


% clear global  dataObjectUsage
% clear global  ecMPTGlobalBuffer
% clear global  ecMasterDisplayTuneRuleList
% clear global  ecMasterNamingRuleList
% clear global  ecac;

% clear global  mmpt_option_mpm_options
% clear global  mpmResult
% clear global  mpt_symbol_mapping
% clear global  mpt_symbol_mapping_list
% clear global  symbolTemplateDB

% clear global  userDTInfo
% clear global  userTypes



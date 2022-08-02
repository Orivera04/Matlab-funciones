function status = mpt_config_set(modelName,PropName,value)
%MPT_CONFIG_SET sets the MPT configuration for code geneartion
%
%   STATUS = MPT_CONFIG_SET(MODELNAME, PROPNAME, VALUE)
%   This API allows users to set MPT configuration through m script.
%   It sets the named property to the specified value.
%
%   INPUTS:
%           modelName :  Name of model from which code is generated
%           PropName  :  the name of a property to be specified
%           value     :  the value to be specified for the named property
%
%   OUTPUTS:
%           status    :  the status of setting property,
%                        1-success; 0-unsuccess
%
%   Valid properties and valid values are as follows:
%   (1) Set File Templates
%       "values" are .tlc files in the work directory or the Matlab path.
%       Properties:                     values:
%       cFunctionTemplate               cfile_template.tlc (default)
%       globalTemplate                  global_c_template.tlc (defalt)
%       globalIncludeTemplate           global_h_template.tlc (defalt)
%       filePrototypeTemplate           function_prototype_template.tlc (defalt)
%       typeDefTemplate                 type_definition_template.tlc (default)
%   (2) Set Naming Rules
%       Properties:                     values:
%       DefineApproach                  Name Creation Script/Force Case/None
%       DefineCaseType                  Upper/Lower/No Change
%       DefineNameCreateMFunction       m function name (user provided)
%       VariableApproach                Name Creation Script/Force Case/None
%       VariableCaseType                Upper/Lower/No Change
%       VariableNameCreateMFunction     m function name (user provided)
%       ParameterApproach               Name Creation Script/Force Case/None
%       ParameterCaseType               Upper/Lower/No Change
%       ParameterNameCreateMFunction    m function name (user provided)
%   (3) Set Global Data
%       Properties:                     values:
%       globalFileFlag                  0 - Define In C Source File
%                                       1 - Define in Separate Single C File
%       globalHFileFlag                 0 - Reference in C Source File
%                                       1 - Reference in Separate Single H File
%       globalFileName                  global.c (default)
%       globalExternFileName            global.h  (default)
%       MachineVarFile                  0 - in C Source File
%                                       1 - in Separate Machine Variable File
%       MachineVarFileName              empty (default) or user provided
%       moduleOwner                     empty (default) or user provided
%   (4) Set Additional Options
%       Properties:                     values:
%       CustomCommentEnable              0/1
%       IncludeFileEnclosure          #include "header.h" / #include <header.h>
%       StateflowThreshold               5 (default)
%       generatePrototypeHeaderFile      0/1
%       externalHeaderFile               empty (default) or user provided
%   %    genInternalProtoHeaderFile
%   %    internalHeaderFile
%       InternalApproach                Direct Inclusion/Single Headers/Individual Headers
%       StateflowCentric                0/1
%       useBaseERTTemplate              0/1
%
%  Examples
%  status = mpt_config_set(modelName,'cFunctionTemplate','cfile_template.tlc')
%  status = mpt_config_set(modelName,'CustomCommentEnable',0)
%
%  See also mpt_config_get

%  Linghui Zhang
%  Copyright 2002-2003 The MathWorks, Inc.
%  $Revision: 1.1.4.9 $
%  $Date: 2004/04/15 00:27:26 $

  
status = 1;
try
    switch(PropName)
        case {'DataDefinitionFile', 'DataReferenceFile', ...
                'GlobalDataDefinition', 'GlobalDataReference', ...
                'ModuleNamingRule','ModuleName',...
                'CustomCommentsFcn','EnableCustomComments',...
                'DefineNamingRule','DefineNamingFcn',...
                'ParamNamingRule','ParamNamingFcn',...
                'SignalNamingRule','SignalNamingFcn',...
                'SourceCodeTemplate','HeaderCodeTemplate',...
                'SourceDataTemplate','HeaderDataTemplate',...
                'InitialValueSource','SignalDisplayLevel',...
                'ParamTuneLevel','GlobalDataDefinition',...
                'DataDefinitionFile','GlobalDataReference',...
                'DataReferenceFile','IncludeFileDelimiter'}
            h=getActiveConfigSet(modelName);

            if strcmp(get_param(h,'IsERTTarget'),'on')
                set_param(h,PropName,value);
            else
                status = 0;
            end
            
            % Set File Templates
        case {'cFunctionTemplate','globalTemplate','globalIncludeTemplate',...
                'filePrototypeTemplate','typeDefTemplate'}
            try
                set_template_info(modelName,PropName, value);
            catch
                status = 0;
                disp(lasterr);
            end

            % Set Naming Rules
        case {'DefineApproach','DefineCaseType','DefineNameCreateMFunction',...
                'VariableApproach','VariableCaseType','VariableNameCreateMFunction',...
                'ParameterApproach','ParameterCaseType','ParameterNameCreateMFunction'}
            set_name_rules(modelName,PropName, value);

            % Set Global Data and part of Additional Options
        case {'globalFileFlag','globalHFileFlag','globalFileName','globalExternFileName',...
                'MachineVarFile','MachineVarFileName','moduleOwner',...
                'generatePrototypeHeaderFile','externalHeaderFile'} % the last two for Additional Options
            set_scope_info(modelName,PropName, value);

            % Set Additional Options
        case {'IncludeFileEnclosure','CustomCommentEnable','StateflowThreshold',...
                'StateflowCentric','useBaseERTTemplate','InternalApproach','AccessMethodFile',...
                'PostProcessEnable','EditPostProcess','CustomCommentScript','PragmaEnable','PragmaScript'}   %The last one in MPT Function Manager
            set_miscellaneous_options(modelName,PropName, value);
            %     case {'genInternalProtoHeaderFile','internalHeaderFile'}
        otherwise
            status = 0;
            disp(['"',PropName,'" is invalid']);

    end
catch
    status = 0;
end

  






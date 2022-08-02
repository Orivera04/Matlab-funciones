function [value,status] = mpt_config_get(modelName,PropName)
%MPT_CONFIG_GET gets the MPT configuration
%   [VALUE,STATUS] = MPT_CONFIG_GET(MODELNAME, PROPNAME)
%   This API allows users to get MPT configuration through m script. It
%   gets value corresponding to the named property.
%
%   INPUTS:
%           modelName :  Name of model from which code is generated
%           PropName  :  the name of a property to be specified
%
%   OUTPUTS:
%           status    :  the status of getting property,
%                        1-success; 0-unsuccess
%           value     :  the value corresponding to the named property
%  Examples
%  [value,status] = mpt_config_get(modelName,'cFunctionTemplate')
%  [value,status] = mpt_config_get(modelName,'CustomCommentEnable')
%
%  See also mpt_config_set for the proper properties.

%  Linghui Zhang
%  Copyright 2002-2004 The MathWorks, Inc.
%  $Revision: 1.1.4.11 $
%  $Date: 2004/04/15 00:27:25 $

status = 1;
value = [];
try
    switch(PropName)
        case {'DataDefinitionFile', 'DataReferenceFile', ...
                'GlobalDataDefinition', 'GlobalDataReference', ...
                'ModuleNamingRule','ModuleName',...
                'CustomCommentsFcn','EnableCustomComments',...
                'DefineNamingRule','DefineNamingFcn',...
                'ParamNamingRule','ParamNamingFcn',...
                'SignalNamingRule','SignalNamingFcn',...
                'ERTSrcFileBannerTemplate','ERTHdrFileBannerTemplate',...
                'ERTDataSrcFileTemplate','ERTDataHdrFileTemplate',...
                'InitialValueSource','SignalDisplayLevel',...
                'ParamTuneLevel','GlobalDataDefinition',...
                'DataDefinitionFile','GlobalDataReference',...
                'DataReferenceFile','IncludeFileDelimiter'}
            h=getActiveConfigSet(modelName);
            if strcmp(get_param(h,'IsERTTarget'),'on')
                value = get_param(h,PropName);
            else
                status = 0;
            end

        case {'cFunctionTemplate','globalTemplate','globalIncludeTemplate',...
                'filePrototypeTemplate','typeDefTemplate'}
            templateInfo = get_template_info(modelName);
            str = ['templateInfo.',PropName];
            value = eval(str);
            % Get Naming Rules
        case {'DefineApproach','DefineCaseType','DefineNameCreateMFunction',...
                'VariableApproach','VariableCaseType','VariableNameCreateMFunction',...
                'ParameterApproach','ParameterCaseType','ParameterNameCreateMFunction'}
            nameRules = get_name_rules(modelName);
            str = ['nameRules.',PropName];
            value = eval(str);
            % Get Global Data and part of Additional Options
        case {'globalFileFlag','globalHFileFlag','globalFileName','globalExternFileName',...
                'MachineVarFile','MachineVarFileName','moduleOwner',...
                'generatePrototypeHeaderFile','externalHeaderFile'} % these two for Additional Options
            scopeInfo = get_scope_info(modelName);
            str = ['scopeInfo.',PropName];
            value = eval(str);

            % Get Additional Options
        case {'IncludeFileEnclosure','CustomCommentEnable','StateflowThreshold',...
                'StateflowCentric','useBaseERTTemplate','InternalApproach',...
                'PostProcessEnable','EditPostProcess','CustomCommentScript',...
                'PragmaEnable','PragmaScript','AccessMethodFile'}
            miscOptions = get_misc_options(modelName);
            str = ['miscOptions.',PropName];
            value = eval(str);
        otherwise
            status = 0;
            disp(['"',PropName,'" is invalid']);
    end
catch
    status = 0;
end


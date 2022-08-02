function ec_apply_name_rules(modelName )
%EC_APPLY_NAME_RULES will set data objects alias files to a user specified
%name based upon rules.

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $
%   $Date: 2004/04/15 00:26:38 $

%The ecMasterNamingRuleList variable is created at this point in the code
%generation cycle (entry hook).

ecMasterNamingRuleList = [];
rtwprivate('rtwattic', 'AtticData', 'ecMasterNamingRuleList', ecMasterNamingRuleList);
try
    modelws = get_param(modelName, 'ModelWorkspace');
    wList = modelws.whos;
    modelwsList=[];
    for i=1:length(wList)
        modelwsList{i}=wList(i).name
    end

    %get user configured naming rule information
    %Custom
    %LowerCase
    %UpperCase
    %None
    [defineNamingRule,status] = mpt_config_get(modelName,'DefineNamingRule');
    [paramNamingRule,status] = mpt_config_get(modelName,'ParamNamingRule');
    [signalNamingRule,status] = mpt_config_get(modelName,'SignalNamingRule');


    opFlag = strcmp(defineNamingRule,'None') & strcmp(paramNamingRule,'None') & ...
        strcmp(signalNamingRule,'None');

    if opFlag == 0
        [defineNamingFcn,status] = mpt_config_get(modelName,'DefineNamingFcn');
        [paramNamingFcn,status] = mpt_config_get(modelName,'ParamNamingFcn');
        [signalNamingFcn,status] = mpt_config_get(modelName,'SignalNamingFcn');
        %Establish useful information for object rules. THis is done only once to
        %save on execution time.
        infoRecord.modelName = modelName;
        moduleNamingRule = mpt_config_get(modelName,'ModuleNamingRule');
        %UserSpecified
        %SameAsModel
        %Unspecified
        moduleOwner = mpt_config_get(modelName,'ModuleName');
        switch(moduleNamingRule)
            case 'Unspecified'
                moduleNameFlag = 0;
                moduleOwner = '';
            case 'UserSpecified'
                moduleNameFlag = 1;
            case 'SameAsModel'
                moduleNameFlag = 1;
                moduleOwner = modelName;
            otherwise
                moduleNameFlag = 0;
                moduleOwner = '';
        end
        infoRecord.moduleNameFlag = moduleNameFlag;
        infoRecord.moduleOwner = moduleOwner;

        list = evalin('base','whos');

        for i=1:length(list)
            try
                name = list(i).name;
                if ismember(name,modelwsList) == 0
                    obj = evalin('base',name);
                    if isa(obj,'Simulink.Signal')
                        wSignal=1;
                        approach = signalNamingRule;
                        nameCreateScript = signalNamingFcn;
                        SimulinkDerived=1;
                    elseif  isa(obj,'Simulink.Parameter')
                        result = ec_get_placement_rules(name);
                        if strcmp(result.mode,'#Define') == 0
                            wSignal=0;
                            approach = paramNamingRule;
                            nameCreateScript = paramNamingFcn;
                            SimulinkDerived=1;
                        else
                            wSignal=0;
                            approach = defineNamingRule;
                            nameCreateScript = defineNamingFcn;
                            SimulinkDerived=1;
                        end

                    else
                        SimulinkDerived=0;
                        nameCreateScript = '';
                    end
                    %Check for auto case. The alias is not supported for auto.
                    if (SimulinkDerived == 1) & (strcmp(obj.RTWInfo.StorageClass,'Auto') == 0)
                        package = (isa(obj,'mpt.Signal')) |  (isa(obj,'mpt.Parameter'));
                        if package == 1
                            namingRuleOverride = get_data_info(name,'NamingRuleOverride');
                        else
                            namingRuleOverride = 0;
                        end

                        cmd = [name,'.RTWInfo.Alias = '];

                        nameCreateScript = strtok(nameCreateScript,'.');

                        try

                            object.originalName = name;
                            updateFlag = 1;
                            switch(approach)
                                case 'Custom'
                                    revisedName = eval([nameCreateScript,'(''',name,''',infoRecord);']);
                                case 'LowerCase'
                                    revisedName = lower(name);
                                case 'UpperCase'
                                    revisedName = upper(name);
                                case 'None'
                                    updateFlag = 0;
                                otherwise
                                    updateFlag = 0;
                            end
                            if updateFlag == 1
                                if namingRuleOverride == 0
                                    if package == 1
                                        if strcmp(revisedName,name) == 0
                                            set_data_info(name,'Alias',revisedName,modelName);
                                            ecMasterNamingRuleList{end+1}=name;
                                        else
                                            set_data_info(name,'Alias',[],modelName);
                                        end
                                    else
                                        cmd = [cmd,'''',revisedName,'''',';'];
                                        evalin('base',cmd);
                                        ecMasterNamingRuleList{end+1}=name;
                                    end
                                end
                            end %if updateFlag
                        catch
                        end %try/catch
                    end % if auto
                end
            catch
                errorFound=1;
            end

        end %for
    end

catch
end
rtwprivate('rtwattic', 'AtticData', 'ecMasterNamingRuleList', ecMasterNamingRuleList);

function ec_apply_tune_display_rules(modelName )
%EC_APPLY_TUNE_DISPLAY_RULES will adjust for tune and display level
%setting.

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $
%   $Date: 2004/04/15 00:26:39 $

%The ecMasterDisplayTuneRuleList variable is created at this point in the code
%generation cycle (entry hook). 
ecMasterDisplayTuneRuleList = [];
rtwprivate('rtwattic', 'AtticData', 'ecMasterDisplayTuneRuleList', ecMasterDisplayTuneRuleList);
try
    modelws = get_param(modelName, 'ModelWorkspace');
    wList = modelws.whos;
    modelwsList=[];
    for i=1:length(wList)
        modelwsList{i}=wList(i).name
    end
    [paramTuneLevel,status] = mpt_config_get(modelName,'ParamTuneLevel');
    [signalDisplayLevel,status] = mpt_config_get(modelName,'SignalDisplayLevel');
    signalFlag = 0;
    paramFlag = 0;
    if isempty(paramTuneLevel) == 0
        if ischar(paramTuneLevel)
            paramTuneLevelValue = str2num(paramTuneLevel);
            if isempty(paramTuneLevelValue) == 1
                paramFlag = 1;
            end
        else
            paramTuneLevelValue = paramTuneLevel;
        end
    else
        paramFlag = 1;
    end
    if isempty(signalDisplayLevel) == 0
        if ischar(signalDisplayLevel)
            signalDisplayLevelValue = str2num(signalDisplayLevel);
            if isempty(signalDisplayLevelValue) == 1
                signalFlag = 1;
            end
        else
            signalDisplayLevelValue = signalDisplayLevel;
        end
    else
        signalFlag = 1;
    end
    %Basic rules
    %There is a persistence level in the data object.
    %There is a model instance parameter tune level and signal display level
    %Display and Tune level rules only apply to MPT derived data objects.

    %Parameters Rule:
    %If the object persistence level <=  model tune level value, the parameter
    %custom storage class will remain unchanged and will be tunable.
    %If the object persistence level >  model tune level value, the parameter
    %custom storage class will be set to #DEFINE and will not be tunable.
    %If either the object persistence level or model tune level should be empty
    %or not available, the custom storage class will not be altered.

    %Signal Rule:
    %If the object persistence level <=  model display level value, the signal
    %custom storage class will remain unchanged.
    %If the object persistence level >  model dispaly level value, the signal
    %storage class will be set to Auto. Setting to Auto will permit RTW to
    %determine how to best handle the particular data object. If expresssion
    %folding is turned on, the objective is to permit elimination of the
    %intermediate value and save on RAM. This aspect is completely dependent
    %upon the model structure and RTW settings.
    %If either the object persistence level or model signal level should be empty
    %or not available, the custom storage class will not be altered.


    if (paramFlag == 0) | (signalFlag == 0)
        list = evalin('base','whos');

        for i=1:length(list)
            try
                name = list(i).name;
                if ismember(name,modelwsList) == 0
                    obj = evalin('base',name);

                    %only mpt objects are supported


                    %Tune level does not apply to the following cases
                    %       #DEFINE
                    %       GetSet
                    %       Importation

                    if isa(obj,'mpt.Signal')
                        %Display level does not apply to the following cases:
                        %       Importation
                        %       GetSet

                        if signalFlag == 0
                            baseStorageClass = get_data_info(name,'BASESTORAGECLASS');
                            if strcmp(baseStorageClass,'Custom') == 1
                                result = ec_get_placement_rules(name);
                                switch(result.mode)
                                    case {'None','#Define','Include'}
                                    case 'Data'
                                        persistenceLevel = get_data_info(name,'PERSISTENCELEVEL');
                                        if persistenceLevel > signalDisplayLevelValue
                                            set_data_info(name,'BASESTORAGECLASS','Auto');
                                            ecMasterDisplayTuneRuleList{end+1}=name;
                                        end
                                    otherwise
                                end
                            end
                        end
                    elseif  isa(obj,'mpt.Parameter')

                        if paramFlag == 0
                            baseStorageClass = get_data_info(name,'BASESTORAGECLASS');
                            if strcmp(baseStorageClass,'Custom') == 1
                                result = ec_get_placement_rules(name);
                                switch(result.mode)
                                    case {'None','#Define','Include'}
                                    case 'Data'
                                        persistenceLevel = get_data_info(name,'PERSISTENCELEVEL');
                                        if persistenceLevel > paramTuneLevelValue
                                            set_data_info(name,'BASESTORAGECLASS','Auto');
                                            ecMasterDisplayTuneRuleList{end+1}=name;
                                        end
                                    otherwise
                                end
                            end
                        end

                    else
                        %nothing.
                    end
                end
            catch
                errorFound=1;
            end
        end %for
    end
catch
end
rtwprivate('rtwattic', 'AtticData', 'ecMasterDisplayTuneRuleList', ecMasterDisplayTuneRuleList);

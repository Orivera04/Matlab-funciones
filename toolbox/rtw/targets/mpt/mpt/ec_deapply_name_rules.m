function ec_deapply_name_rules(modelName )
%EC_DEAPPLY_NAME_RULES clear alias field of SDOs that were previously
%renamed.


%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/15 00:26:41 $

%The ecMasterNamingRuleList contains a list of data object names that were
%previoulsy "renamed" at an earlier stage of the code generation cycle.

ecMasterNamingRuleList = rtwprivate('rtwattic', 'AtticData', 'ecMasterNamingRuleList');

%for each item that had name rules applied previously
%  reset the alias to empty
%  handle both Simulink and mpt objects
%end
for i=1:length(ecMasterNamingRuleList)
    name = ecMasterNamingRuleList{i};
        obj = evalin('base',name);
    %     elem=[];
    %     elem.name = list{i}.name;
    package = (isa(obj,'mpt.Signal')) |  (isa(obj,'mpt.Parameter'));
    cmd = [name,'.RTWInfo.Alias = '];
    revisedName = '';
    try
        if package == 1
            set_data_info(name,'Alias',revisedName,modelName);
        else
            cmd = [cmd,'''',revisedName,'''',';'];
            evalin('base',cmd);
            ecMasterNamingRuleList{end+1}=name;
        end

    catch
    end
end


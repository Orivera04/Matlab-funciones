function [codeGenList, protoGenList, globalGenList, machineGenList, typeGenList,tableGenList, result]   = mpt_external_mpack(modelName,scopeInfo)

% Copyright 2002 The MathWorks, Inc.

codeGenList=[];
protoGenList=[];
globalGenList=[];
machineGenList=[];
typeGenList=[];
tableGenList=[];
result = mpt_get_registration('externalMPack');
if isempty(result) == 0
    if isfield(result,'mPackName') == 1
        for i=1:length(result.mPackName)
            [codeGenList, protoGenList, globalGenList, machineGenList, typeGenList, tableGenList, result]  = eval(result.mPackName{i});
        end
    end
end
function result = stateflowsettings(methodName,modelName,codeFlag,codeFlagValue)
% call it with
% settings('get'/'set',modelName,'databitsets/statebitsets',1/0)
%

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:17 $

  result = [];
  switch(methodName)
   case 'get',
    result = get_code_flag(modelName,codeFlag);
   case 'set'
    result = set_code_flag(modelName,codeFlag,codeFlagValue);
  end
  
function result = get_code_flag(modelName,codeFlag)
  result = [];
  machineId = sf('find','all','machine.name',modelName);
  if(isempty(machineId))
    return;
  end
  targetId = sf('Private','acquire_target',machineId,'rtw');
  result = sf('Private','target_code_flags','get',targetId,codeFlag);
  
function result = set_code_flag(modelName,codeFlag,flagValue)
  
  machineId = sf('find','all','machine.name',modelName);
  if(isempty(machineId))
    return;
  end
  targetId = sf('Private','acquire_target',machineId,'rtw');
  sf('Private','target_code_flags','set',targetId,codeFlag,flagValue);
  result = flagValue;

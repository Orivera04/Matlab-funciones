function set_scope_info(modelName,scopeCat, scopeValue)
%SET_SCOPE_INFO Sets the global scopeInfo.
%
%  SET_SCOPE_INFO(MODELNAME, SCOPECAT, SCOPEVALUE)
%        It is used to set the global scope information.
%
%  INPUTS:  
%        modelName:  name of model
%        scopeCat:      scope category
%        scopeValue:   value of scope category
%
%  OUTPUT:
%        none 

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.14.4.1 $
%  $Date: 2004/04/15 00:28:51 $

global scopeInfo;

switch(scopeCat)
case {'globalFileFlag','globalHFileFlag','includeGlobalFileName','includeEnclosure',...
            'moduleOwner','machineGlobal','machineGlobalH','generatePrototypeHeaderFile','genInternalProtoHeaderFile','MachineVarFile','MachineVarFileName'}
  do_in_global([modelName,'_mpm_options'],'GlobalData.set_scope_data',scopeCat,scopeValue);
case {'globalFileName','globalExternFileName','internalHeaderFile','externalHeaderFile'}
    do_in_global([modelName,'_mpm_options'],'GlobalData.set_scope_data',scopeCat,scopeValue);
otherwise
    disp('set_scope_info:  Invalid  category');
end

function symtab = createFunctionClass(ccsver,cc,si)
% SDK 2.11: has no si.inputvars (inputnames) & si.returntype (type)

% Copyright 2004 The MathWorks, Inc.

symtab = ccs.function( ...
    'procsubfamily',si.procsubfamily, ...
    'name'         ,si.name, ...
    'address'      ,si.address, ...
    'filename'     ,si.filename, ...
    'uclass'       ,si.uclass, ...
    'islibfunc'    ,si.islibfunc, ...
    'variables'    ,si.funcvar, ...
    'inputnames'   ,[], ...
    'type'         ,'', ...
    'stackallocation', si.stackallocation, ...
    'funcdecl'     ,si.funcdecl, ...
    'timeout'      ,cc.timeout, ...
    'link'         ,cc, ...
    'funcinfo'     ,si.funcinfo);

% [EOF] createFunctionClass.m
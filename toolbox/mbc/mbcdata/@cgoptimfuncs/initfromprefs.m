function obj = initfromprefs(obj)
%INITFROMPREFS Grab data from preferences
%
%  OBJ = INITFROMPREFS(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:57 $ 

P = mbcprefs('mbc');
optimprefs = getpref(P, 'Optimization');
funcs = optimprefs.Functions;
if ~isempty(funcs)
    obj.FunctionNames = funcs;
    obj = locatefunctions(obj);
end
function obj = saveobj(obj)
%SAVEOBJ  Save time actions for cgconstant
%
%  OBJ = SAVEOBJ(OBJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:08:22 $

% Make sure the nominal value is set to the current value
obj = setnomvalue(obj, getvalue(obj));
obj.cgvalue = saveobj(obj.cgvalue);
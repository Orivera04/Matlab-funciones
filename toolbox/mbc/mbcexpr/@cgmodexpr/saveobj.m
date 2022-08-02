function obj=saveobj(obj)
%SAVEOBJ  Save-time actions
%
%  M = SAVEOBJ(M)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:25 $

obj.model = saveobj(obj.model);
obj.cgexpr = saveobj(obj.cgexpr);
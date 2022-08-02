function obj = reordervariable(obj, index)
%REORDERVARIABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:12:10 $

obj.variables = obj.variables(index);
obj = updatevariable(obj);

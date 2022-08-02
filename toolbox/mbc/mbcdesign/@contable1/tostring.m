function ch=tostring(obj,fact)
%TOSTRING  Create string representation of constraint
%
%  STR=TOSTRING(CON,FACTORS)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 06:59:21 $

if obj.le
   ch= sprintf('%s(%s) <= %smax',fact{obj.factors([2 1 2])});
else
   ch= sprintf('%s(%s) >= %smin',fact{obj.factors([2 1 2])});
end
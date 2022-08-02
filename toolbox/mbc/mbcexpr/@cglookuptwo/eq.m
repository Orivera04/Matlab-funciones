function iseq = eq(LT1,LT2)
% Eq method for LookupTwo objects
% iseq = eq(LT1,LT2)
% LT1 == LT2

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:32 $
LT1v = LT1.Values;
LT2v = LT2.Values;
iseq = 0;
if all(size(LT1v) == size(LT2v))
   NaN1 = isnan(LT1v);
   NaN2 = isnan(LT2v);
   if isequal(NaN1,NaN2)
      if isequal(LT1v(~NaN1),LT2v(~NaN1))
         iseq = 1;
      end
   end
end


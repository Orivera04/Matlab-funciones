function isL = isLinear(TS);
% TWOSTAGE/ISLINEAR true if all global models are linear

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:45 $

isL= 1;
i=1;
while i<=length(TS.Global) & isL
   isL= isL & numNLParams(TS.Global{i})==0;
   i=i+1;
end
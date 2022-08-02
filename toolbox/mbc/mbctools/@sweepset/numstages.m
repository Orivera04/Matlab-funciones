function ns=numstages(S);
%SWEEPSET/NUMSTAGES number of stages in data
%
% ns=numstages(S);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:06:40 $

s= size(S);
if s(3)==s(1)
    ns= 1;
else
    ns= 2;
end
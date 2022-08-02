function c=costFunc(c,costFunc);
%COSTFUNC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:05 $

if nargin==1
   c= c.costFunc;
else
   c.costFunc= costFunc;
end   
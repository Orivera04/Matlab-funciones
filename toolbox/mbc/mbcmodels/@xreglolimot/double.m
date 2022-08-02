function b= double(m);
%XREGLOLIMOT/DOUBLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:50:33 $

if size(m.betamodels{1},1)*length(m.betamodels{1})~=size(m.xregrbf,1)
   % make sure parameters are the right size
   m= update(m);
end
b= double(m.xregrbf);

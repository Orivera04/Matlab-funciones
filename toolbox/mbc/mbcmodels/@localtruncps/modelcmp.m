function cmp= modelcmp(m1,m2);
% TRUNCPS/MODELCMP

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:09 $

cmp= length(m1.knots) == length(m2.knots);
cmp= cmp & m1.order == m2.order;
if cmp
   cmp= all(getstatus(m1)==getstatus(m2));
end
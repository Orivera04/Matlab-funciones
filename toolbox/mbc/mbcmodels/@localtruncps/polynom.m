function poly= polynom(ts)
% TRUNCPS/POLYNOM

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:10 $

beta= double(ts.xreglinear);
poly= localpoly(beta(1:ts.order),[],[]);
tsstat= getstatus(ts.xreglinear);
poly= set(poly,'status',tsstat(1:ts.order));
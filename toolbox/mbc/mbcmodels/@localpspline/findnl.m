function [nl,f]= findnl(m,dG)
% localpspline/FINDLN - this returns the index to the nonlinear parameter

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:10 $

nl= 1;
f=find(dG(:,nl));
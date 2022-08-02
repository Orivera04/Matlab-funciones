function [nl,f]= findnl(m,dG)
% LOGISTIC/FINDLN - this returns the index to the nonlinear parameter

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:07 $

rfuser= get(m,'feat.index');
np= numParams(m);

f= find(rfuser>np);
nl= 1;


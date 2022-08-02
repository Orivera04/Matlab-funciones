function [param,LB,UB,OK]=initial(u,X,Y)
%USERDEFINED/INITIAL
%[param,minbound,maxbound,OK] = initial(L3,X,Y)
%  Returns starting values and optimisation bounds
%param = initial(L3)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:42:14 $


[LB,UB]= constraints(u.userdefined);

J= CalcJacob(u,X);
[Q,R,OK]= qrdecomp(u.userdefined,J);
param= rand(size(u,1),1);


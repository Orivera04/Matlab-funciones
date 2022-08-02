function [C,Ceq]= optConstr(X,des);
%OPTCONSTR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:18 $

C= optConstr(des.constraints,X);
Ceq=[];
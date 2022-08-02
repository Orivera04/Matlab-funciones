function [n,A,b]= numConstraints(des);
%NUMCONSTRAINTS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:17 $

n= length(des.constraints);
if nargout>1 & ~isempty(des.constraints)
   [A,b]= linearConstr(des.constraints);
else
   A=[];
   b=[];
end
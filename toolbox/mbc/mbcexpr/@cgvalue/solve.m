function [pexpr, rhsexpr, problem, PtrsCreated] = solve(s,exprptr, ptr)
%SOLVE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:16:22 $

% [pexpr, rhsexpr, problem, PtrCreated] = solve(s,exprptr, ptr)
% solves  s = exprptr.info for ptr.info
% the pointer must be in the left hand side,
% therefore must have s = ptr.info 

if isequal(s,ptr.info)
   pexpr  = ptr.info; 
   rhsexpr = exprptr;
   problem = 0;
   PtrsCreated = [];
else
   problem = 'The pointer does not appear in the expression.';
   pexpr  = []; 
   rhsexpr = exprptr;
   PtrsCreated = [];
end   
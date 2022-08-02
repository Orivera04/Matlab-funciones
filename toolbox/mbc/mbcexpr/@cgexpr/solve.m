function [pexpr, rhsexpr, problem, PtrsCreated] = solve(e,exprptr, ptr)
%SOLVE Solve the expression
%
% [pexpr, rhsexpr, problem, PtrsCreated] = SOLVE(e,exprptr, ptr)
%
% This is the default solve that should be overloaded. Rearranges the
% equation e = exprptr.info to make the expression pointed to by ptr the
% subject of the equation.  No specific solve is defined, so leave the
% equation in the form e = exprptr.info  and return a problem to indicate
% that pexpr isn't the item pointed to by ptr.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:51 $

pexpr = e;
rhsexpr = exprptr;
problem = 'Solve is not defined for this type of expression.';
PtrsCreated = [];
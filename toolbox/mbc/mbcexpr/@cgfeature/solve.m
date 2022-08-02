function [pexpr, tableexpr, problem, PtrsCreated] = solve(SF,exprptr,p)
%SOLVE
%
% [pexpr, tableexpr, problem] = solve(SF,p)
%
% rearrange the subfeature SF, where 
%       SF.eqexpr approximates SF.modexpr
% to make the value pointed to by p the subject of the equation, that is,
%       pexpr approximates tableexpr 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:53 $

%expression on the right hand side
rhsexpr = SF.modelexpr;


if isempty(rhsexpr)
   problem = 'The SubFeature has no model associated with it.';
   lhsexpr = SF.eqexpr;
   tableexpr = [];
   pexpr = [];
   PtrsCreated= [];
   return
end   


if isempty(exprptr)
   exprptr = rhsexpr;
end   

% can only set a subfeature equal to its model expression 
if ~isequal(double(exprptr), double(rhsexpr))
   warning('The rhsexpr and the modelexpr do not match.');
end

% expression on the left hand side (must involve p)
lhsexpr = SF.eqexpr;

if isequal(double(lhsexpr), double(p))% when there is a single table in the feature
   pexpr = p.info;
   tableexpr = rhsexpr;
   problem = 0;
   PtrsCreated = [];
else
   % dig into lhsexpr until a single table or variable is isolated
   % pexpr is the final expression that just contains p
   [pexpr, tableexpr, problem, PtrsCreated] = solve(lhsexpr.info, rhsexpr,p);
end



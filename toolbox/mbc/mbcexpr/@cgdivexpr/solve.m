function [pexpr, rhsexpr, problem, PtrsCreated] = solve(d,exprptr, ptr)
%SOLVE
%
% [pexpr, rhsexpr, problem, PtrsCreated] = solve(d,exprptr, ptr)
% d is a divexpr, and exprptr is the pointer to an expression. Ptr points to the 
% expression that we want to be the subject of the equation. 

% Set the divexpr equal to exprptr.info, and solve the resulting 
% equation for the expression contained in divexpr that is
% pointed to by p. 
% If the operation is successful, then  problem = 0 and pexpr = ptr.info = rhsexpr.info.
% If we can solve part of the expression, but then get stuck on a recursive solve, then 
% problem returns a message string, and the equation is in the form pexpr = rhsexpr.info, where 
% ptr appears in pexpr.
% If we cannot solve d because ptr appears more than once in d, 
% then return rhsexpr = exprptr and pexpr = d. 
% If we cannot solve s because ptr doesn't appear in d, 
% then return rhsexpr = exprptr and pexpr = []. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:44 $

numptrfound = 0;

inputs = getinputs(d);
top = inputs(1:d.NTop);
if d.NBottom
    bottom = inputs(d.NTop+1:end);
end

% pointers to the expressions in the top that do not involve p
topnop = [];
for i=1:d.NTop
    if top(i)==ptr  % have found the pointer isolated in left (top) of the divexpr
       found = 'isolatedtop';
       pexpr = top(i).info; % pointer to expression containing ptr 
       numptrfound = numptrfound + 1; 
    else
       % get pointers in the expressions on the top of the divexpr
       t_ptrs = top(i).getptrs;
       if isempty(t_ptrs) || ~any(t_ptrs == ptr) % pointer is not in top(i)
           topnop = [topnop top(i)];
       else % pointer is contained in an expression in the top of the divexpr
           found = 'buriedtop';
           pexpr = top(i).info; % pointer to expression containing ptr 
           numptrfound = numptrfound + 1; 
       end
    end
end

% pointers to the expressions in the bottom that do not involve p
bottomnop = [];
for i=1:d.NBottom
    if  bottom(i)==ptr  % have found the pointer isolated in the bottom of the divexpr
        found = 'isolatedbottom';
        pexpr = bottom(i).info; % pointer to expression containing ptr 
        numptrfound = numptrfound + 1; 
    else
       % get pointers in the expressions on the bottom of the divexpr
        b_ptrs = bottom(i).getptrs;
        if isempty(b_ptrs) || ~any(b_ptrs == ptr)
            bottomnop = [bottomnop bottom(i)];
        else
            found = 'buriedbottom';
            pexpr = bottom(i).info;% pointer to expression containing ptr
            numptrfound = numptrfound + 1;
        end
    end
end

if isequal(numptrfound,0) 
   problem = 'The pointer does not appear in the divide expression.';
   rhsexpr = exprptr;
   pexpr = [];
   PtrsCreated = [];
   return
elseif numptrfound > 1;
   problem = 'The pointer appears more that once in the expression.';
   rhsexpr = exprptr;
   pexpr = d;
   PtrsCreated = [];
   return
end


switch found
case 'isolatedtop'
   % form rhsexpr = cgexpr*bottomnop/topnop 
   rhsexpr = xregpointer(cgdivexpr('rhsexpr',[exprptr bottomnop],topnop));
   PtrsCreated = rhsexpr;
   problem = 0;
case 'isolatedbottom'
   % form rhsexpr = topnop/(bottomnop*cgexpr) 
   rhsexpr = xregpointer(cgdivexpr('rhsexpr',topnop,[exprptr bottomnop]));
   PtrsCreated = rhsexpr;
   problem = 0;
case 'buriedtop'
   % form rhsexpr = cgexpr*bottomnop/topnop 
   rhsexprtmp = xregpointer(cgdivexpr('rhsexpr',[exprptr bottomnop],topnop));
   % dig deeper
   [pexpr,rhsexpr,problem, PtrsCreated] = solve(pexpr,rhsexprtmp,ptr);
   PtrsCreated = [PtrsCreated rhsexprtmp];
case 'buriedbottom'
   % form rhsexpr =  topnop/(bottomnop*cgexpr) 
   rhsexprtmp = xregpointer(cgdivexpr('rhsexpr',topnop,[exprptr bottomnop]));
   % dig deeper
   [pexpr,rhsexpr,problem, PtrsCreated] = solve(pexpr,rhsexprtmp,ptr);
   PtrsCreated = [PtrsCreated rhsexprtmp];
end

function [pexpr, rhsexpr, problem, PtrsCreated] = solve(s,exprptr, ptr)
% cgsubexpr\solve
% [pexpr, rhsexpr, problem, PtrsCreated] = solve(s,cgexpr, ptr)
% s is a subexpr, and exprptr is the pointer to an expression. Ptr points to the 
% expression that we want to be the subject of the equation. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:54 $

% Set s equal to exprptr.info, and solve the resulting 
% equation for the expression contained in s that is
% pointed to by p. 
% If the operation is successful, then  problem = 0 and pexpr = ptr.info = rhsexpr.info.
% If we can solve part of the expression, but then get stuck on a recursive solve, then 
% problem returns a message string, and the equation is in the form pexpr = rhsexpr.info, where 
% ptr appears in pexpr.
% If we cannot solve s because ptr appears more than once in s, 
% then return rhsexpr = exprptr and pexpr = s. 
% If we cannot solve s because ptr doesn't appear in s, 
% then return rhsexpr = exprptr and pexpr = []. 

numptrfound = 0;

inputs = getinputs(s);
left = inputs(1:s.NLeft);
if s.NRight
    right = inputs(s.NLeft+1:end);
end

% pointers to the expressions in the left that do not involve p
leftnop = [];
for i=1:s.NLeft
    if left(i)==ptr  % have found the pointer isolated in left of the subexpr
       found = 'isolatedleft';
       pexpr = left(i).info; % pointer to expression containing ptr 
       numptrfound = numptrfound + 1; 
    else
       % get pointers in the expressions on the left of the subexpr
       l_ptrs = left(i).getptrs;
       if isempty(l_ptrs) || ~any(l_ptrs == ptr) % pointer is not in left(i)
           leftnop = [leftnop left(i)];
       else % pointer is contained in an expression in the left of the subexpr
           found = 'buriedleft';
           pexpr = left(i).info; % pointer to expression containing ptr 
           numptrfound = numptrfound + 1; 
       end
    end
end

% pointers to the expressions in the right that do not involve p
rightnop = [];
for i=1:s.NRight
    if right(i)==ptr  % have found the pointer isolated in the right of the subexpr
        found = 'isolatedright';
        pexpr = right(i).info; % pointer to expression containing ptr 
        numptrfound = numptrfound + 1; 
    else
       % get pointers in the expressions on the right of the subexpr
        r_ptrs = right(i).getptrs;
        if isempty(r_ptrs) || ~any(r_ptrs == ptr)
            rightnop = [rightnop right(i)];
        else
            found = 'buriedright';
            pexpr = right(i).info;% pointer to expression containing ptr
            numptrfound = numptrfound + 1;
        end
    end
end

if isequal(numptrfound,0) 
   problem = 'The pointer does not occur in the subtract expression.';
   rhsexpr = exprptr;
   pexpr = [];
   PtrsCreated = [];
   return
elseif numptrfound > 1;
   problem = 'The pointer appears more than once in the expression.';
   rhsexpr = exprptr;
   pexpr = s;
   PtrsCreated = [];
   return
end


switch found
case 'isolatedleft'
   % form rhsexpr = cgexpr + rightnop - leftnop
   rhsexpr = xregpointer(cgsubexpr('rhsexpr',[exprptr rightnop],leftnop));
   PtrsCreated = rhsexpr;
   problem = 0;
case 'isolatedright'
   % form rhsexpr = leftnop - cgexpr - rightnop 
   rhsexpr = xregpointer(cgsubexpr('rhsexpr',leftnop,[exprptr rightnop]));
   PtrsCreated = rhsexpr;
   problem = 0;
case 'buriedleft'
   % form rhsexpr = cgexpr + rightnop - leftnop
   rhsexprtmp = xregpointer(cgsubexpr('rhsexpr',[exprptr rightnop],leftnop));
   % dig deeper
   [pexpr, rhsexpr,problem, PtrsCreated] = solve(pexpr,rhsexprtmp,ptr);
   PtrsCreated = [PtrsCreated rhsexprtmp];
case 'buriedright'
   % form rhsexpr = leftnop - cgexpr - rightnop 
   rhsexprtmp = xregpointer(cgsubexpr('rhsexpr',leftnop,[exprptr rightnop]));
   % dig deeper
   [pexpr, rhsexpr,problem, PtrsCreated] = solve(pexpr,rhsexprtmp,ptr);
   PtrsCreated = [PtrsCreated rhsexprtmp];
end

function [A,b] = pcgcomp(GroupA, AtoBmin, AtoBmax, GroupB)
%PCGCOMP Linear inequalities for asset group-to-group comparison constraints.
%   This function specifies that the ratio of allocations in one group to 
%   allocations in another group is at least AtoBmin to one, and at most AtoBmax
%   to one.  Comparisons can be made between an arbitrary number, NGROUPS, of 
%   group pairs made up as subsets of the NASSETS available investments.
% 
%   [A,b] = pcgcomp(GroupA, AtoBmin, AtoBmax, GroupB) 
% 
%   Inputs:
%     GroupA, GroupB : NGROUPS by NASSETS specifications of groups to
%     compare.  Each row specifies which assets are in one group:
%     Group(i,j) = 1 if group i contains asset j, otherwise Group(i,j) = 0;
%
%     AtoBmin, AtoBmax : scalar or NGROUPS long vectors of minimum and 
%     maximum ratios of allocations in group A to allocations in group B.
%     The entry NaN indicates no constraint between the two groups in 
%     that direction.  Scalar bounds are applied to all the group pairs.
%     For each of the NGROUPS group pairs:
%     GroupA total >= GroubB total * AtoBmin
%     GroupA total <= GroubB total * AtoBmax
% 
%   Outputs:
%     Matrix A and vector b such that A*Pwts' <= b enforces the constraints,
%     where Pwts is a 1 by NASSETS vector of asset allocations.
%
%     Alternate Usage:  If called with fewer than 2 output arguments, 
%     returns A and b concatenated together: Cons = [A, b];
%     Cons = pcgcomp(GroupA, AtoBmin, AtoBmax, GroupB)
% 
%   See also PORTOPT, PCALIMS, PCPVAL, PCGLIMS, PORTCONS.
% 

%   Author(s): J. Akao, M. Reyes-Kattar, 03/11/98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8.2.1 $   $ Date: 1998/01/30 13:45:34 $

%----------------------------------------------------------------------------
% Process arguments and defaults
% GroupA  [NumGroups by NumAssets]
% GroupB  [NumGroups by NumAssets]
% AtoBmin   [NumGroups by 1]
% AtoBmax   [NumGroups by 1]
% NumGroups [scalar]
% NumAssets [scalar]
%----------------------------------------------------------------------------
if nargin<4, 
  error('Must specify GroupA, AtoBmax, AtoBmin, and GroupB');
end

% get and check sizes
[NumGroups, NumAssets] = size(GroupA);
if (any( size(GroupB)~= [NumGroups, NumAssets] ))
  error('GroupA and GroupB must be NumGroups by NumAssets');
end
if (~all( GroupA(:)==0 | GroupA(:)==1 ))
  error('Specify asset inclusion into Groups with values 0 and 1');
end
if (~all( GroupB(:)==0 | GroupB(:)==1 ))
  error('Specify asset inclusion into Groups with values 0 and 1');
end

% change to column vectors
AtoBmax = AtoBmax(:);
AtoBmin = AtoBmin(:);

% Get the expand scalar arguments
if length(AtoBmin)==1,
  AtoBmin = AtoBmin(ones(NumGroups,1));
elseif length(AtoBmin)~= NumGroups,
  error('Incompatible number of groups specified: AtoBmin, AtoBmax');
end

if length(AtoBmax)==1,
  AtoBmax = AtoBmax(ones(NumGroups,1));
elseif length(AtoBmax)~= NumGroups,
  error('Incompatible number of groups specified: AtoBmin, AtoBmax');
end

%----------------------------------------------------------------------------
% build inequalities
%----------------------------------------------------------------------------

% A >= B*X, B*X - A <= 0
MatMin = [ GroupB.*AtoBmin(:,ones(1,NumAssets)) - GroupA ];
  
% A <= B*X, A - B*X <= 0
MatMax = [ GroupA - GroupB.*AtoBmax(:,ones(1,NumAssets)) ];
  
% Restrict to specified equations
MaskMax = ~isnan(AtoBmax);
MaskMin = ~isnan(AtoBmin);

A = [MatMin(MaskMin,:) ;
     MatMax(MaskMax,:) ];
b = [zeros(sum(MaskMin),1) ;   
     zeros(sum(MaskMax),1) ];

%----------------------------------------------------------------------------
% Concatenation feature 
%----------------------------------------------------------------------------
if nargout<2,
  A = [A b];
end

%----------------------------------------------------------------------------
% end of function PCGCOMP
%----------------------------------------------------------------------------



function [A,b] = pcglims(Groups, GroupMin, GroupMax)
%PCGLIMS Linear inequalities for asset group min and max allocation.
%   This function specifies minimum and maximum allocations to groups of 
%   assets.  Bounds can be specified for an arbitrary number of groups,  
%   NGROUPS, made up as subsets of the NASSETS investments. 
% 
%   [A,b] = pcglims(Groups, GroupMin, GroupMax) 
%
%   Inputs:
%     Groups : NGROUPS by NASSETS specifications of which assets belong to
%     each group.  Every group is a row: Group(i,j) = 1 if group i contains
%     asset j, otherwise Group(i,j) = 0.
%
%     GroupMin, GroupMax : scalar or NGROUPS long vector of minimum and
%     maximum combined allocations in each group.  The entry NaN indicates 
%     no constraint for that asset.  Scalar bounds are applied to all the
%     groups. 
%
%   Outputs:
%     Matrix A and vector b such that A*Pwts' <= b enforces the constraints,
%     where Pwts is a 1 by NASSETS vector of asset allocations.
%
%     Alternate Usage:  If called with fewer than 2 output arguments, 
%     returns A and b concatenated together: Cons = [A, b];
%     Cons = pcglims(Groups, GroupMin, GroupMax)
% 
%   See also PORTOPT, PCPVAL, PCALIMS, PCGCOMP, PORTCONS.
%

%   Author(s): J. Akao, M. Reyes-Kattar, 03/20/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.7 $   $ Date: 1998/01/30 13:45:34 $

%----------------------------------------------------------------------------
% Process arguments and defaults
% Groups   [NumGroups by NumAssets]
% GroupMin [NumGroups by 1]
% GroupMax [NumGroups by 1]
% NumGroups [scalar]
% NumAssets [scalar]
%----------------------------------------------------------------------------

if (nargin<3)
  error('must specify Groups, GroupMin, and GroupMax');
end

[NumGroups, NumAssets] = size(Groups);
% Limit groups to 0/1 
if (~all( Groups(:)==0 | Groups(:)==1 ))
  error('Specify asset inclusion into Groups with values 0 and 1');
end

% change min and max values to column vectors
GroupMin = GroupMin(:);
GroupMax = GroupMax(:);

% expand scalar arguments
if length(GroupMin)==1,
  GroupMin = GroupMin(ones(NumGroups,1));
elseif length(GroupMin)~= NumGroups,
  error('Incompatible number of group bounds specified: Groups, GroupMin');
end

if length(GroupMax)==1,
  GroupMax = GroupMax(ones(NumGroups,1));
elseif length(GroupMax)~= NumGroups,
  error('Incompatible number of group bounds specified: Groups, GroupMin');
end


%----------------------------------------------------------------------------
% build inequalities
%----------------------------------------------------------------------------

% Build all the max/min equations
A = [-Groups;     Groups];
b = [-GroupMin; GroupMax];

% Remove equations which are not specified
Mask = isnan(b);
A(Mask,:) = [];
b(Mask)   = [];

%----------------------------------------------------------------------------
% Concatenation feature 
%----------------------------------------------------------------------------
if nargout<2,
  A = [A b];
end

%----------------------------------------------------------------------------
% end of function PCGLIMS
%----------------------------------------------------------------------------

function g= evalConstraints(U,val,varargin);
% xregusermod/EVALCONSTRAINTS evaluate all parameter constraints
%
% g= evalConstraints(U,b0);
%  all(g<=0) if feasible
% this is intended for determining if the parameters b0 are feasible at 
% bounds and linear constraints are included in the calculation

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:04 $

[LB,UB,A,b,nl]=constraints(U);

g= [];
if ~isempty(LB)
   g= [g;LB-val];
end

if ~isempty(UB)
   g= [g;val-UB];
end

if ~isempty(A)
   g= [g;A*val-b];
end

if nl>0
   g= [g; nlconstraints(val,U,varargin{:})];
end

function pointconstraints = getPointCon(sumst)
%GETPOINTCON Get the labels for the point constraints
%
%  PTCONLABELS = GETPOINTCON(SUMST) returns the labels of the 'point'
%  constraints in the optimization in SUMST. PTCONLABELS is a 1-by-Number
%  of point constraints cell array. 
%
%  See also CGSUMSTORE/GETLINCON

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:55:36 $

os = sumst.os;
constraints = get(os, 'nonlinearconstraints');
sumconstraints = get(os, 'constraintsums');
if ~isempty(sumconstraints)
    suminds = strmatch(sumconstraints, constraints);
else
    suminds = [];
end
ptinds = setdiff(1:length(constraints), suminds);
pointconstraints = constraints(ptinds);


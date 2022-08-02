function [nzt, wtso, wtsc] = getNonZeroWtPts(sumst)
%GETNONZEROWTPTS Get operating points that have non zero weights
%  [NZT, WTSO, WTSC] = GETNONZEROWTPTS(SUMST) returns indices of the
%  points that have at least one objective or constraint with a non-zero
%  weight at that point. The weights for each objective sum are returned in
%  the NZT-by-NOBJSUM matrix WTSO. The weights for each constraint sum are
%  returned in the NZT-by-NCONSUM matrix WTSC.
%
%  This function is designed to be used with sum optimizations only. If
%  this is called with a 'point' optimization, NZT, WTSO and WTSC will return
%  empty
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:55:35 $

os = sumst.os;
nzt = [];
optim = get(os, 'cgoptim');
objs = get(optim, 'objectivefuncs');
wtso = [];
for i = 1:length(objs)
    if objs(i).issum
        wtso = [wtso objs(i).get('weights')];
    end
end

% find where the constraints have non-zero weights
cons = get(optim, 'constraints');
wtsc = [];
for i = 1:length(cons)
    if cons(i).issum & ~cons(i).islinear
        wtsc = [wtsc cons(i).get('weights')];
    end
end

% find out if for each operating point, there are non-zero weights for
% either the sum constraints or the sum objectives
wts = [wtso, wtsc];
nonindflag = any(wts,2);
nzt = find(nonindflag);

if ~isempty(wtso) & ~isempty(nzt)
    wtso = wtso(nzt, :);
end

if ~isempty(wtsc) & ~isempty(nzt)
    wtsc = wtsc(nzt, :);
end

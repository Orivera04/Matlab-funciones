function [N, ok] = history_reset(N,I)
%HISTORY_RESET
%
%  [N, OK] = HISTORY_RESET(N, IDX)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:11:44 $

% Resets the LookupTwo to the version stored in version I in the memory field.

M = N.Memory;
thisDate = M{I}.Date;
V = M{I}.Values;
if isfield(M{I},'Vlocks')
    vlocks = M{I}.VLocks;
    if isempty(vlocks)
        vlocks = zeros(size(V));
    end
else
    vlocks = zeros(size(V));
end

ok = true;
if issizelocked(N)
    if ~all(size(V)==size(N.Values))
        ok = false;
    end
end
if ok
    N.Values = V;
    N.VLocks = vlocks;
    N = clearExtrapolationMask(N);
    
    n = length(M);
    
    N.Memory{n+1}.Values = V;
    N.Memory{n+1}.VLocks = vlocks;
    N.Memory{n+1}.Information = ['Reset to values at ',thisDate];
    N.Memory{n+1}.Data = [];
    N.Memory{n+1}.Date = datestr(now,0);
end
return
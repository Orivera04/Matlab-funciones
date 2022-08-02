function [N, ok] = history_reset(N,I)
%HISTORY_RESET
%
%  [N, OK] = HISTORY_RESET(N, IDX)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:13:59 $

% Resets the normaliser to the version stored in version I in the memory field.

M = N.Memory;
thisDate = M{I}.Date;
BP = M{I}.Breakpoints;
V = M{I}.Values;
if isfield(M{I},'Vlocks')
    vlocks = M{I}.VLocks;
    if isempty(vlocks)
        vlocks = zeros(size(V));
    end
else
    vlocks = zeros(size(V));
end
if isfield(M{I},'BPlocks')
    vlocks = M{I}.BPLocks;
    if isempty(bplocks)
        bplocks = zeros(size(V));
    end
else
    bplocks = zeros(size(V));
end
ok = true;
if issizelocked(N)
    if ~all(size(V)==size(N.Values))
        ok = false;
    end
end
if ok
    N.Breakpoints = BP;
    N.Values = V;
    N.BPLocks = bplocks;
    N.VLocks = vlocks;
    
    n = length(M);
    
    N.Memory{n+1}.Breakpoints = BP;
    N.Memory{n+1}.Values = V;
    N.Memory{n+1}.BPLocks = bplocks;
    N.Memory{n+1}.VLocks = vlocks;
    N.Memory{n+1}.Information = ['Reset to values at ',thisDate];
    N.Memory{n+1}.Data = [];
    N.Memory{n+1}.Date = datestr(now,0);
end
return
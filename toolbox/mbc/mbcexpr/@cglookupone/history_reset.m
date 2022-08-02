function [N, ok] = history_reset(N,I)
%HISTORY_RESET
%
%  [N, OK] = HISTORY_RESET(N, IDX)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:12:23 $

% Resets the cglookupone to the version stored in version I in the memory field.

M = get(N,'memory');

V = M{I}.Values;

if isfield(M{I},'Vlocks')
    vlocks = M{I}.VLocks;
    if isempty(vlocks)
        vlocks = zeros(size(V));
    end
else
    vlocks = zeros(size(V));
end

% A cglookupone is supposed to have it's breakpoints and values in synch, however because of the change to cglookupone and it 
% now being a special case of normfunction, we have a problem in that half the history is in the normaliser and half is in the 
% normfunction

ok = true;
if issizelocked(N)
    if ~all(size(V)==size(N.Values))
        ok = false;
    end
end
if ok
    BP = get(N,'breakpoints');
    if ~isequal(size(BP(:)),size(V(:)))
        BP = [0:length(V)-1];
    end
    
    
    N = set(N,'values',V);
    N = set(N,'vlocks',vlocks);
    N = clearExtrapolationMask(N);
    
    
    n = length(M);
    
    M{n+1}.Values = V;
    M{n+1}.VLocks = vlocks;
    M{n+1}.Breakpoints = BP;
    M{n+1}.Information = 'Reset from history viewer';
    M{n+1}.Data = [];
    M{n+1}.Date = datestr(now,0);
    
    N = set(N,'memory',M);
end
return

function flags = getFlags
%SWEEPSETFILTER/GETFLAGS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $ 

persistent pFlags

if isempty(pFlags)
    pFlags = struct('APPLY_DATA', 1, ...
        'APPLY_VARS', 2, ...
        'APPLY_FILT', 3, ...
        'APPLY_TEST', 4, ...
        'APPLY_SFILT',5, ...
        'APPLY_REOR', 6, ...
        'APPLY_DERIVED', 7);
end

flags = pFlags;

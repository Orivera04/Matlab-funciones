function bits = xregbitset(toSet)
% SWEEPSETFILTER/XREGBITSET
%
%  Not Required yet

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:12:01 $

A = bitset(0, toSet);
bits = 0;
for i = 1:length(A)
    bits = bitor(bits, A(i));
end
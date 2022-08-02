function p = nextpow2(n)
%NEXTPOW2 Next power of two.
%	NEXTPOW2(N) returns the first P such that 2^P >= abs(N).  It is
%	often useful for finding the nearest power of two sequence
%	length for FFT operations.
%	NEXTPOW2(X), if X is a vector, is the same as NEXTPOW2(LENGTH(X)).
%
%   	See also LOG2.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if length(n) > 1
    n = length(n);
end

[f,p] = log2(abs(n));

% Check if n is an exact power of 2.
if f == 0.5
    p = p-1;
end

% Check for infinities and NaNs
k = ~finite(f);
p(k) = f(k);

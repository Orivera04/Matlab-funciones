function x = mvl2dec(s)
%MVL2DEC Convert multi-valued logic to decimal.
%   MVL2DEC(L) converts multi-valued logic string L to decimal.
%   If L contains any character other than '0' or '1', NaN is returned.
%   L must be a vector.
%
%   Example
%       mvl2dec('010111') returns 23
%       mvl2dec('UUUUUU') returns NaN
%
%   See also BIN2DEC, DEC2BIN.

%   Copyright 2003 The MathWorks, Inc. 
%   $Revision: 1.1 $  $Date: 2003/10/23 19:08:12 $

if ~isstr(s), error('Input must be a string.'); end
if isempty(s), x = []; return, end
[m,n] = size(s);
if m > 1 && n > 1, error('Input must be a vector'); end
n = length(s);
if n>52, error('Multi-valued logic string must be 52 bits or less.'); end

s=s(:)';  % convert to a row vector
v = s - '0'; % Convert to numbers
if any(v>1) || any(v<0),
    x = NaN;  % Chars other than 0, 1 produce NaN for result
else
    x = sum(v .* pow2(n-1:-1:0));
end

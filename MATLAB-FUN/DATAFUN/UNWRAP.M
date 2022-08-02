function q = unwrap(p, cutoff)
%UNWRAP Unwrap phase angle in radians.
%	UNWRAP(P) unwraps radian phases P by changing absolute
%	jumps greater than pi to their 2*pi complement.  It
%	unwraps columnwise with matrices.
%
%	UNWRAP(P,TOL) uses a jump tolerance of TOL rather
%	than the default TOL = pi.
%
%	See also ANGLE, ABS.

%	Original: J.N. Little, 4-1-87.
%	Revised:  C R. Denham, 4-29-90.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2, cutoff = pi; end   % Original UNWRAP used pi*170/180.

[m, n] = size(p); oldm = m;
if m == 1, p = p(:); [m, n] = size(p); end   % Column orientation.

pmin = min(p); pmin = pmin(ones(m, 1), :);   % To force REM to behave.
p = rem(p - pmin, 2 .* pi) + pmin;           % Phases modulo 2*pi.

b = [p(1, :); diff(p)];                      % Differentiate phases.
c = -(b > cutoff); d = (b < -cutoff);        % Locations of jumps.
e = (c + d) .* 2 .* pi;                      % Array of 2*pi jumps.
f = cumsum(e);                               % Integrate to get corrections.

q = p + f;                                   % Phases + corrections.
if oldm == 1, q = q.'; end                   % Reorient.

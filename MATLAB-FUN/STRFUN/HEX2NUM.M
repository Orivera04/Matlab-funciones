function x = hex2num(s)
%HEX2NUM IEEE hexadecimal to double precision number conversion.
%	HEX2NUM(S), where S is a 16 character string containing
%	a hexadecimal number, returns the IEEE double precision
%	floating point number it represents.  Fewer than 16
%	characters are padded on the right with zeros.
%
%	For example, HEX2NUM('400921fb54442d18') returns Pi.
%	             HEX2NUM('bff') returns -1.
%
%	NaNs, infinities and denorms are handled correctly.  See
%	also FORMAT HEX.

%	C.B. Moler 12-18-87, 1-5-88, 9-17-91.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if ~isstr(s)
    error('Input to hex2num must be a string.')
end

% Convert characters to numeric digits.
% More than 16 characters are truncated.
d = zeros(1,16);
d(1:length(s)) = abs(lower(s)) - '0';
d = d + ('0'+10-'a').*(d>10);
neg = d(1) > 7;
if neg, d(1) = d(1)-8; end
if any(d > 15) | any(d < 0)
    error('Input string to hex2num should have just 0-9, a-f, or A-F.')
end

% Floating point exponent.
e = 16*(16*(d(1)-4) + d(2)) + d(3) + 1;

% Floating point fraction.
f = 0;
for i = 16:-1:4, f = (f + d(i))/16; end

% Scale the fraction by 2 to the exponent.
if e > 1023
   if f == 0, x = inf; else, x = NaN; end
elseif e < -1022
   x = pow2(f,-1022);
else
   x = pow2(1 + f, e);
end
if neg, x = -x; end

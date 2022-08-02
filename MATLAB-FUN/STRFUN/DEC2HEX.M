function h = dec2hex(d)
%DEC2HEX Decimal to hexadecimal number conversion.
%	DEC2HEX(D) returns decimal integer D in hexadecimal form.
%	For example, DEC2HEX(2748) returns 'ABC'.
%
%	See also HEX2DEC, HEX2NUM.

%	Author: L. Shure
%	Copyright (c) 1984-94 by The MathWorks, Inc.

if any(d ~= round(d))
	error('Requires integer argument.')
end
h = sprintf('%X',d);

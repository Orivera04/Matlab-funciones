function s = int2str(n)
%INT2STR Integer to string conversion.
%	S = INT2STR(N)  converts the integer valued scalar number  N
%       into a string representation.
%
%	See also NUM2STR, SPRINTF, FPRINTF.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

s = sprintf('%.0f',n);

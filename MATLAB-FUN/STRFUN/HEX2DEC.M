function d = hex2dec(h)
%HEX2DEC Hexadecimal to decimal number conversion.
%	HEX2DEC(D) returns hexadecimal number D in decimal form.
%	For example, HEX2DEC('12B') and HEX2DEC('12b') both return 299.
%
%	See also DEC2HEX, HEX2NUM.

%	Author: L. Shure, Revised: 12-23-91, CBM.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

[m,n]=size(h);
p = flipud(cumprod([1; 16*ones(n-1,1)]));
for i=1:n
    if (h(i) > 96)
        h(i) = h(i) - 87;
    elseif (h(i) > 64)
        h(i) = h(i) - 55;
    else
        h(i) = h(i) - 48;
    end
end
d = h*p;

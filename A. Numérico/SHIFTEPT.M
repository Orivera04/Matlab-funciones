function s = shiftept(s)
%SHIFTEPT Shift decimal point in any Maple E-notation numbers.
%	SHIFTEPT('1234.0E10') is '1.234e13'.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.6 $  $Date: 1994/01/24 22:37:09 $

for k = fliplr(find(s == 'E'))
   l = length(s);
   if k < 3, break; end
   if s(k-2) ~= '.', break; end
   f = max(find(s(1:k-3) < '0' | s(1:k-3) > '9'));
   if isempty(f), f = 1; else, f = f+1; end
   e = min(find(s(k+2:l) < '0' | s(k+2:l) > '9'));
   if isempty(e), e = l; else, e = e+k; end
   if f < k-3
      s = [s(1:f) '.' s(f+1:k-3) 'e'  ...
          int2str(eval(s(k+1:e))-f+k-3) s(e+1:l)];
   else
      s(k) = 'e';
   end
end

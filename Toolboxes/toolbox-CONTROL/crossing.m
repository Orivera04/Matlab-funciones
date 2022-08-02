 function [INDEX] = crossing(DATA,VALUE);
% CROSSING = Fractional Index interpolation for a value in a data set
%
%function [INDEX] = crossing(DATA,VALUE);
%
% RETURNS : The INDEX (with linear interpolation) of the position(s)
%           where the DATA cross(es)/hits this VALUE.
%
% SEE ALSO : crosses
 DATA = DATA(:);
 INDEX = find(DATA == VALUE);
 a = find(DATA >= VALUE);
 nd = length(DATA); na = length(a);
 if (na > 0) & (na < nd),
   c = find(diff(a) > 1);
   c = [a(c); a(1+c)-1];
   if (a(1) ~= 1), c = [a(1)-1; c]; end;
   if (a(na) ~= nd), c = [c; a(na)]; end;
   c = c(find(DATA(c) ~= VALUE));
   c = c(find(DATA(1+c) ~= VALUE));
   if ~ isempty(c),
     R = (VALUE-DATA(c))./(DATA(1+c)-DATA(c));
     INDEX = sort([INDEX; c+R]);
   end;
 end;

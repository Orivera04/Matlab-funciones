function  pos = position(handles)
%  Synopsis
%
%
%  Description
%
%
%  Example
%
%
%  See Also

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:35:55 $

minx = realmax;
miny = realmax;
maxx = -realmax;
maxy = -realmax;

l = length(handles);

for k = 1:l
   p = get(handles{k},'Position');

   p(3:4) = p(1:2) + p(3:4);
   
   if p(1) < minx; minx = p(1); end;
   if p(2) < miny; miny = p(2); end;
   if p(3) > maxx; maxx = p(3); end;
   if p(4) > maxy; maxy = p(4); end;
end;

w = maxx - minx;
h = maxy - miny;

pos = [minx miny w h];



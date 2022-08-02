function total=pathlen(p,distmatrix);
%PATHLEN Calculate current path length for traveling salesman problem.
% 	This is a helper function for the function TRAVEL.
% 	This function calculates the total length of the current path
% 	p in the traveling salesman problem.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

npts = length(p);
total = 0;
for count=1:(npts-1),
    total = total + distmatrix(p(count),p(count+1));
end;
total = total + distmatrix(p(1),p(npts));

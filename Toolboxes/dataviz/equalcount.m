function breakpoint = equalcount(x,intervals,overlap)
%  determine sets of values which slice x into equal count intervals
%  breakpoint = equalcount(x,intervals,overlap)
%  intervals  number of intervals
%  0<=desired_overlap<1
%  breakpoint = [upperValue; lowerValue]

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

k = intervals;  % number of intervals
f = overlap;    %  target overlap
r = length(x)/(k*(1-f)+f);   %  target points per interval

%  determine indices for end points
jj = (1:k)';
lowerIndex = round(1+(jj-1)*(1-f)*r);
upperIndex = round(r+(jj-1)*(1-f)*r);
lowerIndex(1) = 1;
upperIndex(end) = length(x);

x = sort(x);

%  determine end point values
lowerValue = x(lowerIndex);
upperValue = x(upperIndex);
breakpoint = [upperValue(:).'; lowerValue(:).'];

function qqplot(A,B,line)
% make a qq (quantile - quantile) plot of data
% with optional quartile - quartile line
% qqplot(A,B,line)
%  A and B are data vectors
%  line can be any argument

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

maxPoints = 1000;
A = sort(A);
B = sort(B);
na = length(A);
nb = length(B);

%  resample to get the same number of points for both vectors
if min(na,nb)>maxPoints
   n = maxPoints;
elseif na==nb
   n = na;
elseif na<nb
   n = na;
   B = interp1(linspace(0,1,nb),B,linspace(0,1,n));
else
   n = nb;
   A = interp1(linspace(0,1,na),A,linspace(0,1,n));
end

%  plot the quantiles with optional line through the quartiles
if nargin>2
   q1 = round(n/4);
   q2 = round(3*n/4);
   slope = (B(q2)-B(q1))/(A(q2)-A(q1));
   intercept = B(q1)-slope*A(q1);
   y = slope*[A(1) A(n)]+intercept;
   plot(A,B,'o',[A(1) A(n)],[A(1) A(n)],':',[A(1) A(n)],y,'--')
else
   plot(A,B,'o',[A(1) A(n)],[A(1) A(n)],':')
end

xlabel(inputname(1))
ylabel(inputname(2))

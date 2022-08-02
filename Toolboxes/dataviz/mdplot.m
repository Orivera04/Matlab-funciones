function mdplot(A,B,line)
% make a Tukey mean difference plot of data
% with optional quartile - quartile line
% mdplot(A,B,line)
%  A and B are data vectors
%  line can be any argument

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

maxPoints = 1000;
A = sort(A);
B = sort(B);
na = length(A);
nb = length(B);

%  resample if needed to get the same number of points for both vectors
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
A = A(:);
B = B(:);

%  form means
M = (A+B)/2;
%  form differences
D = B-A;

%  plot mean, difference points with optional line through quartiles
if nargin>2
   q1 = round(n/4);
   q2 = round(3*n/4);
   slope = (D(q2)-D(q1))/(M(q2)-M(q1));
   intercept = D(q1)-slope*M(q1);
   y = slope*[M(1) M(n)]+intercept;
   plot(M,D,'o',[M(1) M(n)],[0 0],':',[M(1) M(n)],y,'--')
else
   plot(M,D,'o',[M(1) M(n)],[0 0],':')
end

xlabel('Mean')
ylabel('Difference')

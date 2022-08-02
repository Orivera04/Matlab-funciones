function normqqplot(x);
%  plot quantiles of data vs quantiles of normal distribution
%  normqqplot(x)
%  does no labelling
%         See also QQPLOT

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

x = sort(x);
n = length(x);
%  calculate fractional scale for this number of quantiles
f = ((1:n)-0.5)/n;
%  get  normal distribution quantiles
normalQ = sqrt(2)*erfinv(2*f-1);
%  calculate quartile - quartile line
q1 = round(n/4);
q2 = round(3*n/4);
slope = (x(q2)-x(q1))/(normalQ(q2)-normalQ(q1));
intercept = x(q1)-slope*normalQ(q1);
y = slope*[normalQ(1) normalQ(n)]+intercept;
%  make plot
plot(normalQ,x,'o',[normalQ(1) normalQ(n)],y,'k--')


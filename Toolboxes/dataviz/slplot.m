function slplot(A,B)
% make spread - location plot for 2 data sets
% slplot(A,B)
%  A and B are treated as data vectors

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

A = A(:);
B = B(:);

%  calculate locations
medianA = median(A);
medianB = median(B);
%  and spreads
absResA = abs(A-medianA);
absResB = abs(B-medianB);
%  and median absolute deviations of spreads
madA = median(absResA);
madB = median(absResB);
nA = length(A);
nB = length(B);

%  use jitter to avoid overplotting locations
hg = plot(jitter(repmat(medianA,nA,1)),sqrt(absResA),'o',...
   jitter(repmat(medianB,nB,1)),sqrt(absResB),'o');
hold on
%  plot trend line
plot([medianA medianB],[sqrt(madA) sqrt(madB)],'k--')
hold off
ylabel('Square Root Absolute Residual')
xlabel('Jittered Median')
legend(hg,char({inputname(1); inputname(2)}),0)

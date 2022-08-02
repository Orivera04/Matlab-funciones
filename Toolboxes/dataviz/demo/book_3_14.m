%  book_3_14.m
%  calls slplotr

load ganglion

x = Area;
y = CPratio;
pow = 2;

%  calculate fit and residuals
fitx= x;
p = polyfit(x,y,pow);
fity = polyval(p,fitx);
residual = y(:)-fity(:);

alpha = 2;
lambda = 1;

%  spread location plot for residuals
slplotr(fity,residual,alpha,lambda)
xlabel('Fitted CPratio')
ylabel('Sqrt Abs Residual CP Ratio')
title('Ganglion')
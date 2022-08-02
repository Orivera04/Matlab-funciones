%  book_3_18.m
%  calls slplotr

load ganglion

x = Area;
y = CPratio;
pow = 1;
y = log2(y);

fitx= x;
p = polyfit(x,y,pow);
fity = polyval(p,fitx);
residual = y(:)-fity(:);
alpha = 2;
lambda = 1;

%  spread location plot for residuals
slplotr(fity,residual,alpha,lambda)
xlabel('Fitted log_2 CPratio')
ylabel('Sqrt Abs Residual log_2 CP Ratio')
title('Ganglion')
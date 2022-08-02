%  book_3_17.m
%  calls rdplot

load ganglion

x = Area;
y = CPratio;
pow = 1;
y = log2(y);

fitx= x;
p = polyfit(x,y,pow);
fity = polyval(p,fitx);
residual = y(:)-fity(:);
alpha = 1;
lambda = 1;

rdplot(x,residual,alpha,lambda)
xlabel('Area (mm^2)')
ylabel('Residual log_2 CP Ratio')
title('Ganglion')
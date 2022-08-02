%  book_3_20.m
%  calls normalqqplot

load ganglion

x = Area;
y = CPratio;
pow = 1;
y = log2(y);

fitx= x;
p = polyfit(x,y,pow);
fity = polyval(p,fitx);
residual = y(:)-fity(:);

normalqqplot(residual,'Residual Log_2 CP Ratio')
title('Ganglion')
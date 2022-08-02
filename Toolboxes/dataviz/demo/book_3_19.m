%  book_3_19.m
%  calls rfplot

load ganglion

x = Area;
y = CPratio;
pow = 1;
y = log2(y);

fitx= x;
p = polyfit(x,y,pow);
fity = polyval(p,fitx);
residual = y(:)-fity(:);

%  resdiual fit plot
rfplot(fity,residual,'Residual Log_2 CP Ratio')

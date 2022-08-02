%  book_3_16.m
%  fit after log transform

load ganglion

x = Area;
y = CPratio;
pow = 1;
y = log2(y);

fitx= linspace(min(x),max(x),50);
p = polyfit(x,y,pow);
fity = polyval(p,fitx);

hg = plot(x,y,'o',fitx,fity,'g-');
xlabel('Area (mm^2)')
ylabel('log_2 CP Ratio')
title('Ganglion')

%  book_3_5.m

load ganglion

%  compare first and second degree fits
pow1 = 1;
pow2 = 2;
x= linspace(min(Area),max(Area),50);
p = polyfit(Area,CPratio,pow2);
y = polyval(p,x);
p = polyfit(Area,CPratio,pow1);
y1 = polyval(p,x);

hg = plot(Area,CPratio,'o',x,y1,'r--',x,y,'b-');
xlabel('Area (mm^2)')
ylabel('CP Ratio')
title('Ganglion')
legend(hg(2:3),[int2str(pow1); int2str(pow2)],4)
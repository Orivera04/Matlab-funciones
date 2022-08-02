%  book_3_13.m

load ganglion

%  make second degree fit
p = polyfit(Area,CPratio,2);
y = polyval(p,Area);
residual = CPratio(:)-y(:);

alpha = 1;
lambda = 1;

rdplot(Area,residual,alpha,lambda)
xlabel('Area (mm^2)')
ylabel('Residual CP Ratio')
title('Ganglion')
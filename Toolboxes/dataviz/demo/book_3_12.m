%  book_3_12.m
%  calls rdplot

load ganglion

%  make first degree fit
p = polyfit(Area,CPratio,1);
y = polyval(p,Area);
%  calculate residuals
residual = CPratio(:)-y(:);

alpha = 1;
lambda = 1;

rdplot(Area,residual,alpha,lambda)
xlabel('Area (mm^2)')
ylabel('Residual CP Ratio')
title('Ganglion')
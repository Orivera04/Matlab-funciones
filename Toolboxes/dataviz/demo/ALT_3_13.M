%  alt_3_13.m
%  calls polyfitr2
%  plot rsquared for fits over a range of degrees

load ganglion

pow1 = 1;
pow2 = 4;
powers = pow1:pow2;

r2 = polyfitr2(Area,CPratio,powers);

plot(powers,r2,'-o')
xlabel('Fit Order')
ylabel('R^2')
title('Ganglion')
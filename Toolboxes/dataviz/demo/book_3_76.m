%  book_3_76.m
%  calls seasonaloess

load carbondioxide

period = 12;
%  loess parameters for seasonal fit
elShort = 25;
lambdaShort = 1;

seasonalPart = seasonaloess(Year,CO2,period,elShort,lambdaShort);

nonseasonalPart = CO2(:)-seasonalPart(:);

plot(Year,nonseasonalPart);
xlabel('Year')
ylabel('CO2 (ppm)')
%  make a little space around points
ax = axis;
ax(1) = min(Year)-1;
ax(2) = max(Year)+1;
axis(ax)
axis square

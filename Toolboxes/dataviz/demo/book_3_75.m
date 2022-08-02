%  book_3_75.m
%  calls seasonaloess, cycleplot

load carbondioxide

timeLabel = ['J'; 'F'; 'M'; 'A'; 'M'; 'J'; 'J'; 'A'; 'S'; 'O'; 'N'; 'D'];
period = 12;

%  loess parameters for seasonal fit
elShort = 25;
lambdaShort = 1;

seasonalPart = seasonaloess(Year,CO2,period,elShort,lambdaShort);

cycleplot(seasonalPart,period)

xlabel('Month')
ylabel('CO_2 (ppm)')
set(gca,'XTickLabel',timeLabel)


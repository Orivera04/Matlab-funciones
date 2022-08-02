%(mm1602.m plot)
y = [1998 1998 1999*ones(1,12)]';
m = [11 12 (1:12)]';
s = [1.1 1.3 1.2 1.4 1.6 1.5 1.7 1.6 1.8 1.3 1.9 1.7 1.6 1.95]';
bar(datenum(y,m,1),s)
datetick('x','mmmyy')
ylabel('$ Million')
title('Figure 16.2: Monthly Sales')

%  book_3_73.m

load carbondioxide

plot(Year,CO2)
xlabel('Year')
ylabel('CO2 (ppm)')
axis square
%  make just a little room around points
axis tight
ax = axis;
ax(1) = ax(1)-1;
ax(2) = ax(2)+1;
ax(3) = ax(3)-5;
ax(4) = ax(4)+5;
axis(ax)
title('Carbondioxide')
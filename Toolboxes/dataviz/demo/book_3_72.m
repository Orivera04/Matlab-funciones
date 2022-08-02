%  book_3_72.m
%  calls bank45

load carbondioxide

plot(Year,CO2)
xlabel('Year')
ylabel('CO2 (ppm)')
bank45(Year,CO2)
%  make just a little room around points
axis tight
ax = axis;
ax(1) = ax(1)-1;
ax(2) = ax(2)+1;
ax(3) = ax(3)-10;
ax(4) = ax(4)+10;
axis(ax)
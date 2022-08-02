%  alt_3_6
%  calls bank45
%  polyfit does not work well for this data

load melanoma

x = Year;
y = Incidence;

%  Used scaled Year.
offsetX = x-x(1);

pow1 = 3;
pow2 = 11;
fitX= linspace(min(x),max(x),50);
offsetFitX = fitX-x(1);

p = polyfit(offsetX,y,pow2);
fity = polyval(p,offsetFitX);
p = polyfit(offsetX,y,pow1);
fity1 = polyval(p,offsetFitX);

hg = plot(x,y,'o',fitX,fity1,'r--',fitX,fity,'g-');
xlabel('Year')
ylabel('Incidence')
title('Melanoma')
%legend(hg(2:3),char({int2str(pow1); int2str(pow2)}),4)

bank45(x,y)
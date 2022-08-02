%  alt_3_6
%  calls loess, bank45

load melanoma

x = Year;
y = Incidence;

%  Used scaled Year.
offsetX = x-x(1);

alpha = 0.25;
lambda = 2;
fitX= linspace(min(x),max(x),50);
offsetFitX = fitX-x(1);
fity = loess(offsetX,y,offsetFitX,alpha,lambda);

hg = plot(x,y,'o',fitX,fity,'g-');
xlabel('Year')
ylabel('Incidence')
title('Melanoma')

bank45(x,y)
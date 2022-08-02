%  alt_3_53.m

load playfair

hg = plot(1:22,Diameter,'o',1:22,sqrt(Population),'+');
xlabel('Data Index')
title('Playfair')
legend(hg,{'Diameter'; 'sqrt(Population)'},2)


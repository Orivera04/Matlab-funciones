delete(gcf)

a=1;
b = ones(1,15)/15;
x = (1:0.1:10).^2;
x = x+5*(rand(size(x))-0.5);
ab = 1:length(x);
plot(ab,x,'ro');
hold on
y0 = filter(b,a,x);

y = conv(x,b);
plot(-6:length(y)-7,y,'g+')
plot(ab-7,y0,'b^')
set(gca,'fonts',14);
legend('\bforiginal', 'conv', 'filter',2) 
title('\bfmoyenne glissante')

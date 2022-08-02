x = linspace(0,1,11);
xx = linspace(0,1,100);
y = randn(1,11);
plot(x,y,'r+')
hold on
for i= 1:3:11
  p=polyfit(x,y,i);
  plot(xx,polyval(p, xx));
end;
title('\bfapprox. de degrés 1,4,7,10 de 11 points','fonts',14);


% Exercicios Propostos 03
function r2 = exercicios_propostos_03 (x,y)
coef=polyfit(x,y,1);
xm=mean(x);
ym=mean(y);
yp=polyval(coef,x);
sqr=(coef(1)^2)*sum((x-xm).^2);
sqt=sum((y-ym).^2)
r2=sqr/sqt;
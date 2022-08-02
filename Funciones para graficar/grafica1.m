%Gráfica de una función de una variable
x=0:0.1:5;
y=input('Introduzca la función f: ');
ecua=char(y);
z=eval(y);
plot(x,z)
title(['f(x)=',ecua])
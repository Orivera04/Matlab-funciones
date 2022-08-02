%Gráfica de una función de una variable
x=0:0.1:4;
w=input('Introducir la función f: ');
y=eval(w);
z=char(w);
plot(x,y);
title(['f(x) = ',z])


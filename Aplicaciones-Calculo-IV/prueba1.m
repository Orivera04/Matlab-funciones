x=0:0.1:3;
y=input('Introducir la fución: ');
w=vectorize(y)
v=eval(w);
plot(x,v)
title(strcat('y=',y))
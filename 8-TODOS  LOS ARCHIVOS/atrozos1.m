%Función definida a trozos
t1=-2:.1:2;
t2=2.1:.1:4.9;
t3=5:.1:8;

f1=ones(size(t1));
f2=zeros(size(t2));
f3=t3.*sin(4*pi*t3);

t=[t1 t2 t3];
f=[f1 f2 f3];

plot(t,f)
title('Multi-part function f(t)')

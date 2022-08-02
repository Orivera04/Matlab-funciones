%Gráfica de una función periódica

clear all;
clc;
minab=input('Dar extremo izq. del intervalo [a,b]: ');
maxab=input('Dar extremo der. del intervalo [a,b]: ');
xmin=input('Dar xmin del período T: ');
xmax=input('Dar xmax del período T: ');
T=xmax-xmin;
h=input('Dar el paso h: ');
ymin=input('Dar el valor mínimo de y en la gráfica: ');
ymax=input('Dar el valor máximo de y en la gráfica: ');
plot([minab maxab],[0 0],'r');
plot([0 0],[ymin ymax],'r');
axis([minab maxab ymin ymax]);
disp('No. de períodos en que se va a graficar la función: '); 
n=(maxab-minab)/T
x=xmin:h:xmax;
fun=input('f(x)=');
f=inline(fun);
plot(x,f(x));
hold on;
for i=1:n-1
x=x+T;
tr=x-i*T;
plot(x,f(tr))
end
shg;
grid on
hold off

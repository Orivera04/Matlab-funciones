%Ecuación de la circunferencia forma centro-radio

%Dar coordenadas del centro y radio
h=input('h= ');
k=input('k= ');
r=input('r= ');

%Construir ecuación
syms x y
ec=char('x-h)^2 + (y-k)^2=r^2');
ecua=eval(ec);



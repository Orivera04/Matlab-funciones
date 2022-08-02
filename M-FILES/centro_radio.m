%Ecuación de la circunferencia forma centro-radio

%Dar coordenadas del centro y radio
h=input('h= ');
k=input('k= ');
r=input('r= ');
rc=r^2;
rcuad=num2str(rc);
%Construir ecuación
syms x y 
par1=(x-h)^2 + (y-k)^2;
pretty(par1),fprintf('\b = %s\n',rcuad);



% Dibuja una caja
n=input('Dame el ancho de la caja: ');
m=input('Dame el largo de la caja: ');
p=input('Dame la altura de la caja: ');
npar=linspace(0,n,30);
mpar=linspace(0,m,30);
ppar=linspace(0,p,30);
long=length(npar);
% Dibujo de lados derecho e izquierdo.
[x,z]=meshgrid(mpar,ppar);
y=zeros(long);
mesh(x,y,z);
hold on;
y=n*ones(long);
mesh(x,y,z);
% Dibujo de lados anterior y posterior
[y,z]=meshgrid(npar,ppar);
x=zeros(long);
mesh(x,y,z);
x=m*ones(long);
mesh(x,y,z);
% FIN



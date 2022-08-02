% Dibuja varias graficas 3D
disp('Esta es la grafica de un paraboloide');
[x,y]=meshgrid(-2:0.1:2,-2:0.1:2);
z=x.^2+y.^2;
mesh(x,y,z);
disp('Presione una tecla para ver otra grafica');
pause;
disp('Este es otro paraboloide');
z=4-x.^2-y.^2;
mesh(x,y,z);
disp('Presione una tecla');
pause;
disp('Este es un paraboloide hiperbolico');
z=x.^2-y.^2;
mesh(x,y,z)
disp('Presione una tecla');
pause;
disp('Esto es un elipsoide');
[x,y,z]=ellipsoid(0,0,0,2,5,8);
mesh(x,y,z);
disp('Presione una tecla');
pause;
disp('Este es un cono eliptico');
z=sqrt(x.^2+y.^2);
mesh(x,y,z)
% FIN
function Heun

% Esta funcion implementa el Metodo de Heun para aproximar 
% la solucion de la ecuacion diferencial  y' = f(x,y) 
% con condicion inicial y(x0)= y0 y tamano de paso h

clc;
clear all;
syms x y fxy;

encabezado=sprintf('\nMetodo de Heun o Euler mejorado');
disp(encabezado);
disp('---------------------------------------');
fxy=input('\nIntroduzca la ecuacion diferencial en terminos de x o y \ny luego presione enter:\n\n');
h=input('\nIntroduzca el tamano de paso h :\n');
x0=input('\nIntroduzca el valor inicial del intervalo en x :\n');
xf=input('\nIntroduzca el valor final del intervalo en x :\n');
y0=input('\nIntroduzca el valor inicial y0 :\n');

nciclos=(xf-x0)/h;
coord_x(1)=x0+h;
coord_y_temp(1)=y0+h*evaluar_fc(x0,y0,fxy);
coord_y(1)=y0+(h*(evaluar_fc(x0,y0,fxy)+evaluar_fc(coord_x(1),coord_y_temp(1),fxy)))/2;

for k=2:nciclos
    
    coord_x(k)=coord_x(k-1)+h;
    coord_y_temp(k)=coord_y(k-1)+h*evaluar_fc(coord_x(k-1),coord_y(k-1),fxy);
    coord_y(k)=coord_y(k-1)+(h*(evaluar_fc(coord_x(k-1),coord_y(k-1),fxy)+...
               evaluar_fc(coord_x(k),coord_y_temp(k),fxy)))/2;
end

clc;
titulo=sprintf('\nMetodo de Euler mejorado con h=%.4f',h);
disp(titulo);
disp('---------------------------------------');
disp('      n       xn       yn');
disp('---------------------------------------');
cond_inicial=sprintf('\t  %d \t %.2f \t %.6f',0,x0,y0);
disp(cond_inicial);

for paso=1:nciclos
    
    resultados=sprintf('\t  %d \t %.2f \t %.6f',paso,coord_x(paso),coord_y(paso));
    disp(resultados);
    resultados=[];
end 

disp('_______________________________________');



function valor_retornado=evaluar_fc(coord_x,coord_y,fxy)

x=coord_x;
y=coord_y;
valor_retornado=subs(fxy);



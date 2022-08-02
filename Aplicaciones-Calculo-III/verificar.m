%Determinar si un punto (xo,yo) pertenece a una recta L

%Dar los coeficientes de la ecuación
A=input('Dar el coeficiente A: ');
B=input('Dar el coeficiente B: ');
C=input('Dar el coeficiente C: ');

%Dar el punto xo,yo
xo=input('Dar xo: ');
yo=input('Dar yo: ');
 
%Evaluar LI en el pto xo,yo
syms x y
LI=eval('A*x+B*y+C');
val=subs(LI,{x,y},{xo,yo})
if val==0
    disp(['El punto (',num2str(xo),',',num2str(yo),') pertenece a la recta L'])
else
    disp(['El punto (',num2str(xo),',',num2str(yo),') no pertenece a la recta L'])
end
%Programa para graficar una recta tangente a una circuenferncia
%en un punto dado de lam misma.

%Gráfica de las tangentes.
syms x y t
r=input('Dar el radio de la circunferencia. r= ');
x=r*cos(t);
y=r*sin(t);
xder=diff(x,t);
yder=diff(y,t);
axis([-5 5 -5 5]);
axis equal;
t0=input('Dar valor inicial del ángulo: ');
h=input('Dar el incremento del ángulo: ');
angulo=t0;
hold on;
while angulo < 2*pi
    m=subs(yder,t,angulo)/subs(xder,t,angulo);
    x0=r*cos(angulo);
    y0=r*sin(angulo);
    x1=r*cos(angulo+h);
    y1=y0 + m*(x1-x0);
     if angulo == pi
         line([-r -r],[0 1])
       continue 
      end 
    line([x0 x1],[y0 y1])
    
    angulo=angulo+h
  
end

%Dibujo de la circunferencia
s=0:0.1:2*pi;
x=r*cos(s);
y=r*sin(s);
plot(x,y);
hold off


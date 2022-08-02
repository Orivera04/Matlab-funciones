% Producto escalar y vectorial de vectores

clear

u=input('Introduce un vector u de dimensión 3: ');
v=input('Introduce el otro vector v: ');

disp('La longitud de los vectores es, respectivamente: ');
norm(u)
norm(v)

disp('El producto escalar es: ');
u'*v

disp('El ángulo entre los vectores en grados es: ');
180/pi*subspace(u,v)

disp ('El producto vectorial es: ');

p=pvect(u,v)

clf

% Ahora dibujamos el producto vectorial

hold on
plot3 ([0 u(1)],[0 u(2)],[0 u(3)],'b');
text (u(1)+.1,u(2)+.1,u(3)+.1,'u');
plot3 ([0 v(1)],[0 v(2)],[0 v(3)],'b');
text (v(1)+.1,v(2)+.1,v(3)+.1,'v');
plot3 ([0 p(1)],[0 p(2)],[0 p(3)],'k');
text (p(1)+.1,p(2)+.1,p(3)+.1,'p');
hold off
grid
view(3)


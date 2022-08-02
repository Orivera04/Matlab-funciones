fonc = inline( '[ y(2);-t*y(2)-y(1)];','t','y');
[t,y] = ode45(fonc, linspace(0,10,500) , [0,1]);
plot(t,y)
fonc = inline( '[ y(2);-t*y(2)-y(1)];','t','y');
odeset('OutputFcn',@odephas2,'Refine',100);
ode45(fonc, [0 100] , [0,1]);

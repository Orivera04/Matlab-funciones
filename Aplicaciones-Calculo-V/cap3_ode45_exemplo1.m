% cap3_ode45_exemplo1 ()
function cap3_ode45_exemplo1( )
Tinicial=0;
Tfinal=1000;
CondInic=[0 0];
[t,y]=ode45('cap3_fbungie1',[Tinicial Tfinal],CondInic);
subplot(2,1,1)
plot(t,-y(:,1));
title('Deslocamento')
subplot(2,1,2)
plot(t,y(:,2));
title('Velocidade')
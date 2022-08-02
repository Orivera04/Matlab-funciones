% cap3_ode45_exemplo2 ()
function cap3_ode45_exemplo2(m,k,b)
Tinicial=0;
Tfinal=1000;
CondInic=[0 0];
[t,y]=ode45('cap3_fbungie2',[Tinicial Tfinal],CondInic,[],m,k,b);
subplot(2,1,1)
plot(t,-y(:,1));
title('Deslocamento')
subplot(2,1,2)
plot(t,y(:,2));
title('Velocidade')

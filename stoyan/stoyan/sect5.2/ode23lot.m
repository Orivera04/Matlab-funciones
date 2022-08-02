% © Molnarka Gy''oz''o 1998; program a Differencialegyenletek 
                           % numerikus megoldasa reszhez
[t,y]=ode23('yprlot',[0,100],[2,7]);
plot(t,y(:,1),'o',t,y(:,2),'x')
title('Lotka-Volterra modell')
xlabel('ido')
ylabel('egyedszam')
text(63,270,'x - ragadozo')
text(63,250,'o - aldozat')
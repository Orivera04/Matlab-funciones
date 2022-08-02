% © Molnarka Gy''oz''o 1998; program a Differencialegyenletek 
                           % numerikus megoldasa c. reszhez
for i=1:100
   p(i)=0.1+0.1*i;
   [t1,y1]=ode45('csilla',[0,12],[1,2],options,2,p(i),3);
   t(i) = t1(length(t1));
end
plot(p,t)
title('A csillapitott rezgomozgas kiterese kilendules utan 1
erteket vesz fel')
xlabel('csillapitasi tenyezo')
ylabel('ido')
text(6,2.6,'tomeg = 3')
text(6,2.7,'rugoallando = 2')
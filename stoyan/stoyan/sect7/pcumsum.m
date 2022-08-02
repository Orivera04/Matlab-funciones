% © Gergo Lajos 1998; program a Grafika c. reszhez
 n=input('Adja meg a lepesek szamat');
 x=cumsum(rand(1,n)-0.5);
 y=cumsum(rand(1,n)-0.5);
 z=cumsum(rand(1,n)-0.5);
 plot3(x,y,z);
 text(x(1),y(1),z(1),'Kezdet');
 text(x(n),y(n),z(n),'Veg');
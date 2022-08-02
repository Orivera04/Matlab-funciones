% © Gergo Lajos 1998; program a Grafika c. reszhez
%Itt az interaktiv rajzolo program:
n=figure;
disp('Rajzoljunk egy szep abrat');
disp('az eger bal gombjaval kattintson a kezdopontra');
disp('ha kesz a rajz, nyomja meg az eger jobb gombjat');
[x,y,t]=ginput(1);
plot(x,y,'o');
xx=x;yy=y;
hold; axis([0 1 0 1]);
while t~=3
[x,y,t]=ginput(1);
plot(x,y,'o');
xx=[xx,x]; yy=[yy,y];
end
clf; line(xx,yy);
disp('kattintson az abrara, ha keszen van');
waitforbuttonpress;
delete(n);
syms x
num = 3*x^2 + 6*x -1;
denom = x^2 + x - 3;
f = num/denom;
ezplot(f);
hold on;
fprima=diff(f);
crit=solve(fprima);
pc1=double(crit(1));
pc2=double(crit(2));
yminloc=subs(f,x,pc1);
ymaxloc=subs(f,x,pc2);
plot(pc1,yminloc,'ro');
plot(pc2,ymaxloc,'go');
hold off;
title('Máximo Local y Mínimo Local de (3*x^2 + 6*x -1)/(x^2 + x - 3)');
syms x
num = 3*x^2 + 6*x -1;
denom = x^2 + x - 3;
f = num/denom;
ahor=limit(f,x,inf);
aver=solve(denom);
ezplot(f);
hold on;
ah=double(ahor);
plot([-2*pi,2*pi],[ah,ah,],'g');
av1=double(aver(1));
av2=double(aver(2));
plot([av1,av1],[-5,10],'r')
plot([av2,av2],[-5,10],'r')
hold off
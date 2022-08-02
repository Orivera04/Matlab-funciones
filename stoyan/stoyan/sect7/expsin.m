% © Gergo Lajos 1998; program a Grafika c. reszhez
a=0;
b=5;
n=100;
x=linspace(a,b,n);
a1=sin(x).^2;
a2=x.*sin(x).^2;
a3=exp(x).*sin(x).^2;
plot(x,a1,x,a2,x,a3);
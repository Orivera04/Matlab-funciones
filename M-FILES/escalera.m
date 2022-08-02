function f=escalera(x)
a=min(x);
b=max(x);

x1=a:b-1;
x2=a+1:b;
y=1:b-1;
plot([x1;x2],[y;y],'k')
axis([0 b+1 0 b+1])
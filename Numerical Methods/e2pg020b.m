x=2:.04:4;
y=f101(x);
plot(x,y);
xlabel('x'); ylabel('y');
figure(2)
fplot('f101',[2 4])
xlabel('x'); ylabel('y');

%programa para graficar funciones con marcas
x=(0:0.4:10)';
y=sin(x).*exp(-0.4*x);
plot(x,y,'+')
xlabel('x'); ylabel('y')
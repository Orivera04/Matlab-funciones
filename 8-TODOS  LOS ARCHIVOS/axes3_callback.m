function axes3_callback( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','axes3'); % Objeto axes3
axes(obj);  % Configura eixo corrente
x=-2*pi:0.1:2*pi;
plot(x,sin(x)-x.*cos(x))

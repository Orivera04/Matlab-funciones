function axes2_callback( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','axes2'); % Objeto axes2
axes(obj);  % Configura eixo corrente
x=-2*pi:0.1:2*pi;
plot(x,sin(x)+x.*cos(x))

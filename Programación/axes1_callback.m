function axes1_callback( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','axes1'); % Objeto axes1
axes(obj);  % Configura eixo corrente
x=-2*pi:0.1:2*pi;
plot(x,x*sin(x))

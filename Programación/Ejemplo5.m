figure(1) % desplegamos ventana 1
clf % borramos todo
x=linspace(0,5,100);
f=inline('exp(-n*x).*cos(x)'); % definimos funciones (vectorizadas)
hold on % solapamiento de graficas
y=f(1/3,x);
plot(x,y,'k--','linewidth',2)
y=f(1,x);
plot(x,y,'r-.','linewidth',2)
y=f(3,x);
plot(x,y,':','color',[0.0,0.0,0.5],'linewidth',2)
y=f(9,x);
plot(x,y,'-','color',[0.0,0.3,0.0],'linewidth',2)
grid on % desplegamos la red
axis([-0.5,6,-0.25,0.5]) % rango de los graficos
xlabel('Eje OX','fontname', 'Comic Sans Ms', 'Fontsize',12)
ylabel('Eje OY','fontname', 'Comic Sans Ms', 'Fontsize',12)
whitebg([1 1 1]); % color de fondo
title('Algunas graficas de funciones',...
'Fontsize',16,'Fontname','Times new roman','color',[0.0,0.0,0.5])
legend('exp(-x/3).*cos(x/3)', 'exp(-x).*cos(x)',...
'exp(-3x)*cos(3x)', 'exp(-9x).*cos(9x)');
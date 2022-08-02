%Gráfica animada de una trayectoria circular
x = 0;
y = 0;
dt = pi/40;
p = plot(x, y, '*', 'EraseMode', 'none'); % 'xor' muestra solo el punto actual.                                          % ' none' shows all points
axis equal;
axis([-4 4 -3 3]);
title('Elipse animada')
for t = 0:dt:2*pi;
    x = 3*cos(t) ;
    y = 2*sin(t) ;
    set(p, 'XData', x, 'YData', y) 
    drawnow
    pause(0.05)
end
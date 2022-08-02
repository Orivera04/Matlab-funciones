%Gráfica animada de una trayectoria circular
x = 0;
y = 0;
dt = pi/40;
p = plot(x, y, '*', 'EraseMode', 'none'); % 'xor' muestra solo el punto actual.                                          % ' none' shows all points
axis square;
axis([-2 2 -8 8]);
for t = -2:dt:2;
    x = t ;
    y = t.^3 ;
    set(p, 'XData', x, 'YData', y) 
    drawnow
    pause(0.05)
end
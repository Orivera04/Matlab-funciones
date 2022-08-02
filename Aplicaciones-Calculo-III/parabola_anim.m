%Gráfica animada de una trayectoria circular
x = 0;
y = 0;
dt = pi/40;
p = plot(x, y, 'o', 'EraseMode', 'none'); % 'xor' muestra solo el punto actual.                                          % ' none' shows all points
axis square;
axis([0 5  0 20]);
for t = 0:dt:4;
    x = t ;
    y = t.^2 ;
    set(p, 'XData', x, 'YData', y) 
    drawnow
    pause(0.05)
end
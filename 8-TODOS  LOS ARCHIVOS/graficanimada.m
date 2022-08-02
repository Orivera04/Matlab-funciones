axis([-2 2 -2 2])% animated sine graph
x = 0;
y = 0;
dt = pi/40;
p = plot(x, y, 'o', 'EraseMode', 'none'); % 'xor' shows only current point                                          % ' none' shows all points
axis equal;
axis([-2 2 -2 2]);
for t = 0:dt:2*pi;
    x = cos(t) ;
    y = sin(t) ;
    set(p, 'XData', x, 'YData', y) 
    drawnow
    pause(0.05)
end
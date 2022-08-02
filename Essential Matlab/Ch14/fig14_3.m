%see fig14_3b for version that can be printed!

A = [ -8/3 0 0; 0 -10 10; 0 28 -1 ];
y = [35 -10 -7]';
h = 0.01;
p = plot3(y(1),y(2),y(3), 'o', 'markersize', 2, ...
    'EraseMode','none'); % Set EraseMode to none
axis([0 50 -25 25 -25 25])
hold on
for i=1:2000
    A(1,3) = y(2);
    A(3,1) = -y(2);
    ydot = A*y;
    y = y + h*ydot;
    % Change coordinates
    set(p,'XData',y(1),'YData',y(2),'ZData',y(3)) 
    set(p,'color', [0 0 0])
    drawnow 
    %i=i+1;
end
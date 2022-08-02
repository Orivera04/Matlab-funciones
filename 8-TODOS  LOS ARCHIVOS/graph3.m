
% Script file graph3.

% Graphs of two ellipses

%                x(t) = 3 + 6cos(t), y(t) = -2 + 9sin(t)

% and

%                x(t) = 7 + 2cos(t), y(t) = 8 + 6sin(t.)


t = 0:pi/100:2*pi;
x1 = 3 + 6*cos(t);
y1 = -2 + 9*sin(t);
x2 = 7 + 2*cos(t);
y2 = 8 + 6*sin(t);
h1 = plot(x1,y1,'r',x2,y2,'b');
set(h1,'LineWidth',1.25)
axis('square')
xlabel('x')
h = get(gca,'xlabel');
set(h,'FontSize',12)
set(gca,'XTick',-4:10)
ylabel('y')
h = get(gca,'ylabel');
set(h,'FontSize',12)
set(gca,'YTick',-12:2:14)
title('Graphs of (x-3)^2/36+(y+2)^2/81 = 1 and (x-7)^2/4+(y-8)^2/36 = 1.')
h = get(gca,'Title');
set(h,'FontSize',12)
grid

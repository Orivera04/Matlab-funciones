rv = linspace(.3,1,50);
thv = linspace(pi/4,5*pi/4,50);
[r,th]=meshgrid(rv,thv);
x = r.*cos(th);
y = r.*sin(th);
z = peaks(50)+10*x;
i = edgeindex(x);

% Axis is square so font size must be adjusted
set(0,'defaultaxesfontsize',20*12.5/15.9)
close all

clf
patch(x(i),y(i),'y')
hold on
h = plt([-1 1],[-1 1],'.');
set(h,'Color',get(gcf,'color'))
axis equal tight
undo
plotzero

print -deps annularregion

close
clf
patch(x(i),y(i),'y')
hold on
h = plt([-1 1],[-1 1],'.');
set(h,'Color',get(gcf,'color'))
axis equal tight
undo
plotzero

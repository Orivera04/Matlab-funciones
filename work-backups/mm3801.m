x = (1:10).';   % sample data
y = cos(pi*x);

yo = -.2;      % inverse interpolation point
xol = [x(1); x(end)];
yol = [yo; yo];

plot(x,y,xol,yol)
xlabel X
ylabel Y
set(gca,'Ytick',[-1 yo 0 1])
title('Figure 38.1: Inverse Interpolation')

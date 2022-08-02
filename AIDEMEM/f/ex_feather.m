t = linspace(0,40,19); x=sin(t); y = cos(t);
subplot(2,2,1); feather(x,y); axis square
subplot(2,2,2); compass(x,y);axis square
subplot(2,2,3); quiver(x,y,t,t,1);axis square
subplot(2,2,4); quiver(x,y,0);axis square
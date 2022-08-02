x = 0.1:0.4:pi-0.2; 
y = sin(x); 
subplot(1,2,1)
xi=linspace(0,pi,100);
yi=spline(x,y,xi);
plot(x,y,'r+',xi,yi,'b-'); 
axis tight
title('\bfsplines cubiques', 'fonts',14);xi=linspace(0,pi,100);
subplot(1,2,2)
yi=interp1(x,y,xi,'spline');
plot(x,y,'r+',xi,yi,'b-'); 
title('\bfinterp1 : ''spline''', 'fonts',14);
axis tight
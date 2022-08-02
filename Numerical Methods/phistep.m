% PHISTEP  Illustrate fixed point iteration.

f = @(x) sqrt(1 + x);
xmin = -1;
xmax = 4;
xstart = 0;

x = xstart;
y = f(x);
n = 1;
while (x(n) ~= y(n)) & (n < 256) & (max(abs(y)) < 100)
   n = n+1;
   x(n) = y(n-1);
   y(n) = f(x(n));
end

t = sort([xmin:(xmax-xmin)/256:xmax x]);
h = plot(t,t,'-', t,f(t),'-');

x = [x; x];
y = [x(1) y(1:n-1); y];
h = [h; line(x(:),y(:),'color','black')];
h = [h; line(x(end),y(end),'marker','o','color','red')];
axis([1.59 1.62 1.5925 1.6225])
axis square
text(x(1,5)-.0002,y(1,5)-.001,'x_5')
text(x(1,6)-.0002,y(1,6)-.001,'x_6')
text(x(1,5)-.0002,y(1,6)+.001,'y_5')
text(x(1,6)-.0002,y(1,7)+.001,'y_6')

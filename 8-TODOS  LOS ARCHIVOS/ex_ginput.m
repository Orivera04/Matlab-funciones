axis([0 100, 0 100]); axis manual; hold on
x=[]; y=[]; i=1;
while 1
  [x(i) y(i) b] = ginput(1);
  if b == 2 break; end; 
  plot(x(i), y(i),'r+');
  i=i+1;
end;
xi = linspace(min(x), max(x),200);
yi = interp1(x,y,xi,'spline');
plot(xi,yi);

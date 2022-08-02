p = [1 2 5 -1]; %polynôme x^3+2x^2+5x-1
x = polyval(p, -5:5);
dx1 = diff(x)
dx2 = diff(x,2)
dx3 = diff(x,3)
dx4 = diff(x,4) 

x = -0.05:0.01:0.0;
y = exp(x)
dy1 = diff(y)/0.01
dy2 = diff(y,2)/(0.01^2)


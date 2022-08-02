% function coil_a(n,u,w, p1,p2) plots a traditional coil symbol. 
% n: number of turns of the coil
% u: relative length of coil
% w: relative width of coil
% p1, p2: coordinate pairs of the starting and ending points
% Example: see L2_30 
% Copyright S. Nakamura, 1995
function dummy =  coil_a(n,u,w, p1,p2)
c = (p2(1)-p1(1))/2;  d = (p2(2)-p1(2))/2;
f = (p2(1)+p1(1))/2;  g = (p2(2)+p1(2))/2;

x = -1:0.01:1;
t =(x+1)*pi*(n+0.5); 
y = -w*sin(t);
x = x + 0.15*(1-cos(t)); a=x(1); b=x(length(x));
x = 2*(x-a)/(b-a) - 1;
x=[-1,u*x,1]; y=[0, y , 0];
xx = c*x - d*y + f;
yy = d*x + c*y + g;
plot(xx,yy)

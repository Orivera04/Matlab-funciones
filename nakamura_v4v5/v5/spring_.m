% spring_(n,u,w, p1,p2) draws a spring symbol.
% n: # of winding
% u: length of spring 
% w: width of spring 
% p1: coordinate pair for starting point
% p2: same for ending point
% Example>> p1 =[1,0];   p2=[2,0]; 
%           spring_(5,0.4, 0.2, p1,p2)
% Copyright S. Nakamura, 1995
function dummy =  spring_(n,u,w, p1,p2)
c = (p2(1)-p1(1))/2;  d = (p2(2)-p1(2))/2;
f = (p2(1)+p1(1))/2;  g = (p2(2)+p1(2))/2;
k = 2*n;
x = -1:0.02:1;
z=k*x*2;
y = w*cos(z).*cos(-x*pi/2);
x = x - 0.2*sin(z); 
x=[-1,u*x,1]; y=[0,y,0];
xx = c*x - d*y + f;
yy = d*x + c*y + g;
plot(xx,yy)

% function coil_b plots a coil symbol in a contemporary 
% style.   Arguments of coil_b are same as for
% coil_a.
% Copyright S. Nakamura
function dummy =  coil_b(n,u,w, p1,p2)
c = (p2(1)-p1(1))/2;  d = (p2(2)-p1(2))/2;
f = (p2(1)+p1(1))/2;  g = (p2(2)+p1(2))/2;
k = n*2;
Dx = 2/k/2;


x = -1:0.01:1;
z = k*acos(x);
y = w*sin(z);
x = x + 0.1*(1-cos(z)); %x = [-1,x,1];
x = [-1,-u, u*x,u,1];
y = [0,0,y,0,0];
xx = c*x - d*y + f;
 yy = d*x + c*y + g;
plot(xx,yy)

% resist_(n,u,w, p1,p2) plots a resistor symbol.
% n: # of turns 
% u: length 
% w: width 
% p1: coordinate pair for starting point
% p2: same for ending point
% Example>> p1 =[1,0]; p2=[2,0]; resist_(5, 0.4, 0.1, p1,p2)
% Copyright S. Nakamura, 1995
function dummy =  resist_(n,u,w, p1,p2)
c = (p2(1)-p1(1))/2;  d = (p2(2)-p1(2))/2;
f = (p2(1)+p1(1))/2;  g = (p2(2)+p1(2))/2;
 Dx = 1/(2*n);
x =u*[-1+Dx:2*Dx:1];
[m1,n1]=size(1:length(x));
y = w*[0, (-ones(1,n1-2)).^(1:n1-2),0];
x=[-1,x,1];
y=[0,y,0];
 xx = c*x - d*y + f;
 yy = d*x + c*y + g;
plot(xx,yy)


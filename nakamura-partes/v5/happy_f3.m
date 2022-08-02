function dummy=happy_f3

axis('square')
axis([-1.1,1.1,-1.0,1.2])
dt = pi/10;
t=0:dt:2*pi;
x=cos(t); y=sin(t);

plot( x,y)
hold on
for k=0.8:-0.2:0.05
plot(k*0.1*x-0.3+ 0.15*k,k*0.15*y+0.05+ 0.1*k)   % left eye
plot(k*0.1*x+0.3+ 0.15*k,k*0.15*y+0.05+ 0.1*k)   % right eye
end
plot([0,0.2,0],[0, -0.2,-0.2])
s1 = 3*pi/2-1.1*0.5;
s2 = 3*pi/2+1.1*0.5;
s = s1:dt:s2;
xs = 0.5*cos(s); ys = 0.5*sin(s);  % mouth
plot(xs,ys)
L=length(x)/2;   % hair
xh=x(1:L); yh=y(1:L);
for j=1:L
plot([xh(j),xh(j)*1.2],[yh(j),yh(j)*1.1]);
end
xlabel('Happy face #3')

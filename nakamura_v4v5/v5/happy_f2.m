function dummy=happy_f2

axis('square')
axis([-1.1,1.1,-1.0,1.2])
dt = pi/20;
t=0:dt:2*pi;
x=cos(t); y=sin(t);

plot( x,y)
hold on

for k=0.8:-0.1:0.05
plot(k*0.1*x-0.3,k*0.15*y+0.1)   % left eye
plot(k*0.1*x+0.3,k*0.15*y+0.1)   % right eye
end


s1 = 3*pi/2-1.1;
s2 = 3*pi/2+1.1;
s = s1:dt:s2;
xs = 0.5*cos(s); ys = 0.5*sin(s);  % mouth
plot(xs,ys)

for k=0.01:0.01:0.1
xnose=x*k; ynose=y*k-0.1;plot(xnose,ynose)  % nose
end



L=length(x)/2;

xh=x(2:L); yh=y(2:L);
plot(xh*1.1,yh*1.1);plot(xh*1.2,yh*1.2);
xlabel('Happy face #2')

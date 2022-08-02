function dummy=happy_f1

axis('square')
axis([-1.15,1.2,-1.1,1.25])
dt = pi/10;
t=0:dt:2*pi;
x=cos(t); y=sin(t);

plot( x,y)
hold on

k=0.8
J=length(x)
for j=1:J
plot([-0.3,k*0.1*x(j)-0.3],[0.1,k*0.15*y(j)+0.1])   % left eye
plot([+0.3,k*0.1*x(j)+0.3],[0.1,k*0.15*y(j)+0.1])   % left eye
%plot(k*0.1*x+0.3,k*0.15*y+0.1)   % right eye
end


s1 = 3*pi/2-1.1;
s2 = 3*pi/2+1.1;
s = s1:dt:s2;
xs = 0.5*cos(s); ys = 0.5*sin(s);  % mouth
plot(xs,ys)

k=0.1; xnose=x*k; ynose=y*k-0.1;plot(xnose,ynose)  % nose



xh=x/5-0.9; yh=y/5+0.4;plot(xh,yh)   % ahir
plot(x/5-0.7,y/5+0.7)
plot(x/5-0.6,y/5+0.85)
plot(x/5-0.2,y/5+1)
plot(x/5-0.0,y/5+0.9)
plot(x/5+0.2,y/5+0.95)
plot(x/5+0.4,y/5+0.9)
plot(x/5+0.8,y/5+0.7)
plot(x/5+0.99,y/5+0.5)
plot(x/5+0.95,y/5+0.3)
end 
xlabel('Happy face #1')




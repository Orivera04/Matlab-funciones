function dummy=happy_f4.m


axis('square')
axis([-1.1,1.1,-1.0,1.2])
dt = pi/40;
t=0:dt:2*pi;
x=cos(t); y=sin(t);

plot( x,y)
hold on
for j=5:40
plot([x(j)-0.1,x(j)+0.1], [y(j)-0.1, y(j)+0.2])
end
for k=0.8:0.8
plot(k*0.1*x-0.3,k*0.15*y+0.2)   % left eye
plot(k*0.1*x+0.3,k*0.15*y+0.2)   % right eye
end
s1 = 3*pi/2-1.5;
s2 = 3*pi/2+1.5;
s = s1:dt:s2;
xs = 0.5*cos(s); ys = 0.5*sin(s);  % mouth
plot(xs,ys)

for k=0.1:0.1
xnose=x*k; ynose=y*k-0.1;plot(xnose*0.5,ynose)  % nose
end
xlabel('Happy face #4')



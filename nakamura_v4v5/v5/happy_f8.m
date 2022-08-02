function dummy=happy_f8.m


axis('square')
axis([-1.3,1.3,-1.2,1.4])
dt = pi/40;
t=0:dt:2*pi;
x=cos(t); y=sin(t);

plot( x,y)
hold on
for j=1:40
plot([x(j)-0.2,x(j)+0.2], [y(j), y(j)]) %hair
plot([x(j)-0.2,x(j)+0.2], [y(j)-0.02, y(j)-0.02]) 
plot([x(j)-0.2,x(j)+0.2], [y(j)+0.02, y(j)+0.02]) 
end
for k=0.8:-0.1:0.1
plot(k*0.1*x-0.3,k*0.15*y+0.1)   % left eye
plot(k*0.1*x+0.3,k*0.15*y+0.1)   % right eye
end
s1 = 3*pi/2-1.1;
s2 = 3*pi/2+1.1;
s = s1:dt:s2;
xs = 0.5*cos(s); ys = 0.5*sin(s);  % mouth
plot(xs,ys)

for k=0.1:-0.025:0.025
xnose=x*k; ynose=y*k-0.1;plot(xnose*0.5,ynose)  % nose
end
xlabel('Happy face #8')



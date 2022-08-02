function dummy=happy_f7

axis('square')
axis([-1.1,1.1,-1.0,1.2])
dt = pi/20;
t=0:dt:2*pi;
x=cos(t); y=sin(t);
plot( x,y)
hold on
for j=3:20
plot([x(j),x(j)],[y(j),1.5])
end
xlabel('happy face #7')
for k=1.5:-0.5:0.5
plot(k*0.2*x-0.4,k*0.2*y+0.1)   % left eye
plot(k*0.2*x+0.4,k*0.2*y+0.1)   % right eye
end
s1 = -3*pi ;
s2 = 3*pi;
dt=pi/6;
s = s1:dt:s2;
xs = 0.2*cos(s); ys = 0.1*cos(s);  % mouth
plot(s/(3*pi*2),ys-0.5)
%for k=0.01:0.01:0.1
%xnose=x*k; ynose=y*k-0.1;plot(xnose,ynose)  % nose
%end
plot([0, -0.2,0],[-0.2,-0.2, -0.05]) %nose

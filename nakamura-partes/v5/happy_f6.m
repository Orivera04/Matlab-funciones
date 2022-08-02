function dummy=happy_f6


axis('square')
axis([-0.1,1.1,-1.0,1.5])
dt = pi/10;
t=0:dt:2*pi;
x=cos(t); y=sin(t);

plot( x,y)
hold on

plot(0.5*sin(t*2), 0.2*(cos(t*2)-1)+t*0.5 + 1)



for k=0.8:-0.2:0.2
plot(k*0.2*x-0.3,k*0.05*y+0.1)   % left eye
plot(k*0.2*x+0.3,k*0.05*y+0.1)   % right eye
end


s1 = 3*pi/2-0.5 ;
s2 = 3*pi/2+0.5;
s = s1:dt:s2;
xs = 0.5*cos(s); ys = 0.5*sin(s);  % mouth
plot(xs,ys)

%for k=0.01:0.01:0.1
%xnose=x*k; ynose=y*k-0.1;plot(xnose,ynose)  % nose
%end

plot([-0.05,0.05],[-0.2,-0.2]) %nose
xlabel('Happy face #6')
axis([-1 1 -1 2.5])

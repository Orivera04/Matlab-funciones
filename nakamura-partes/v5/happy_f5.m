function dummy=happy_f.5.m


axis('square')
axis([-1.5,1.5,-1.5,1.5])
dt = pi/10;
t=0:dt:2*pi;
x=cos(t); y=sin(t);

plot( x,y)
hold on
for j=3:9
text(x(j)*1.05-0.1,y(j)*1.05-0.05,'lllll')
end

for k=0.8:-0.2:0.2
plot(k*0.1*x-0.3,0.8*0.15*y+0.1)   % left eye
plot(k*0.1*x+0.3,0.8*0.15*y+0.1)   % right eye
end

s1 = 3*pi/2-0.9 ;
s2 = 3*pi/2+1.1;
s = s1:dt:s2;
xs = 0.5*cos(s); ys = 0.5*sin(s);  % mouth
plot(xs,ys)

%for k=0.01:0.01:0.1
%xnose=x*k; ynose=y*k-0.1;plot(xnose,ynose)  % nose
%end

text(-0.05,-0.2,'x') %nose
text(0.05,-0.2,'x')
xlabel('Happy face #5')

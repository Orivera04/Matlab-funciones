function dummy=happy_f9

axis('square')
axis([-1.1,1.1,-1.0,1.2])
dt = pi/20;
t=0:dt:2*pi;
x=cos(t); y=sin(t);

plot( x,y)
hold on
for m=-1:1
plot([+0,+0.1*m], [1,1+0.15])  % hair
end

for k=0.8:-0.1:0.05
plot(k*0.15*x-0.4,k*0.2*y+0.15)   % left eye
plot(k*0.15*x+0.4,k*0.2*y+0.15)   % right eye
end



s1 = 3*pi/2-1.1;
s2 = 3*pi/2+1.1;
s = s1:dt:s2;
xs = 0.6*cos(s); ys = 0.6*sin(s);  % mouth
plot(xs,ys)

for k=0.20:0.20
xnose=x*k; ynose=y*k-0.25;plot(xnose,ynose)  % nose
end

% nose hole
k=0.4;
plot(k*0.15*x-0.1,k*0.2*y-0.3)   % left 
plot(k*0.15*x+0.1,k*0.2*y-0.3)   % right 


for m=-1:1
plot([-0.1,-0.1+0.1*m], [-0.3,-0.3-0.1])
plot([+0.1,+0.1+0.1*m], [-0.3,-0.3-0.1])
end
xlabel('Happy face #9')

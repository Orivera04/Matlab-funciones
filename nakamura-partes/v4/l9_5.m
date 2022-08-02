% L9_5 same as f9_9 
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.9; List 9.5')

clear;clg
load car_.dat
x=car_(:,1)';
y=car_(:,2)';
axis([-0,20,-2,10])
subplot(2,1,1)
hold on
plot(x,y)
dth=pi/10;
th=0:dth:2*pi;
xt=1.2*cos(th);
yt=1.2*sin(th);
plot(xt+3.7, yt+0.45)
plot(xt+14.3, yt+0.45)
title('Plot of raw design profile')
axis([-0,20,-0.9,6.0]); axis('off')
%disp 'Hit return to prot the profile after smoothing'
pause(3)
subplot(2,1,2)
hold on
m = length(y); plot([-1 4], [-1 2], '.');  
x=[x(1),x,x(m)];
y=[y(1),y,y(m)];
m=length(x);
t = 0:0.25:1; t2=t.^2; t3=t.^3;
for i=2:m-2
   yb = 1/6*((1-t).^3*y(i-1) + (3*t3-6*t2+4)*y(i) + ...
        (-3*t3 + 3*t2 + 3*t + 1)*y(i+1) + t3*y(i+2) );
   xb = 1/6*((1-t).^3*x(i-1) + (3*t3-6*t2+4)*x(i) +  ...
        (-3*t3 + 3*t2 + 3*t + 1)*x(i+1) + t3*x(i+2) );
   plot(xb,yb)
end
plot(xt+3.7, yt+0.45)
plot(xt+14.3, yt+0.45)
title('Plot after b-spline fitting')
axis([-0,20,-0.9,6.0]); axis('off')




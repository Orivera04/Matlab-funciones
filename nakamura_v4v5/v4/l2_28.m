% L2_28 plots a happy face (See Fig.2.28)
%Copyright  S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.28')

clear, clf, hold off
dt = pi/20;
t=0:dt:2*pi;
x=cos(t); y=sin(t);
plot( x,y)        % face outline
hold on
for k=0.8:-0.05:0.05
   plot(k*0.1*x-0.3,k*0.15*y+0.1) %  left eye
   plot(k*0.1*x+0.3,k*0.15*y+0.1) % right eye
end
s1 = 3*pi/2-1.1;   % mouth
s2 = 3*pi/2+1.1;
s = s1:dt:s2;
xs = 0.5*cos(s); ys = 0.5*sin(s);
plot(xs,ys)        % mouth
hold off
disp 'HIT RETURN'
pause
axis('square')
axis('off')

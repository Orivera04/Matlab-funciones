subplot(2,2,1)
t = 0:pi/20:2*pi;
fill(cos(t),sin(t),'k', ...
     0.9*cos(t),0.9*sin(t),'y'), ...
     axis square
subplot(2,2,3)
t = 0:pi/20:4*pi;
fill(t,sin(t),'g')
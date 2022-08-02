subplot(2,2,1)
plot3(rand(1,10), rand(1,10), rand(1,10),'k'),title('(a)')
subplot(2,2,2)
t = 0:pi/50:10*pi;
plot3(exp(-0.02*t).*sin(t), exp(-0.02*t).*cos(t),t,'k'), ...
xlabel('x-axis'), ylabel('y-axis'), zlabel('z-axis'),title('(b)')
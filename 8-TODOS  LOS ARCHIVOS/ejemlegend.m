x = -pi:pi/20:pi;
plot(x,cos(x),'-r',x,sin(x),'-.b')
h = legend('cos','sin',2);
line([-3 0; 3 0], [0 -3; 0 3],'LineStyle','-');
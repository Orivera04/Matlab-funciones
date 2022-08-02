% cap5_plot3_exemplo
x=-5*pi:0.1:5*pi;
y=-5*pi:0.1:5*pi;
z=x+y;
subplot(1,2,1)
plot3(cos(x),sin(y),x+y)
title('Plot3')
subplot(1,2,2)
comet3(cos(x),sin(y),x+y)
title('Comet3')
x = linspace(0, 3*pi, 50);
y = x.*sin(x);
plot(x,y,'ro',x,y,'b-');
title('{\bf50 points entre 0 et 3}\pi', 'fonts', 14);
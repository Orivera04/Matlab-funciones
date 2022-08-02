% mm2701.m
t = linspace(0,10*pi);
plot3(sin(t),cos(t),t)
xlabel('sin(t)'), ylabel('cos(t)'), zlabel('t')
text(0,0,0,'Origin')
grid on
title('Figure 27.1: Helix')
v = axis
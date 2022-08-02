x = linspace(0,2*pi,30);
y = sin(x);
z = cos(x);
plot(x,y,x,z)
box off % turn off the axes box
xlabel('Independent Variable X') % label horizontal axis
ylabel('Dependent Variables Y and Z') % label vertical axis
title('Figure 25.5: Sine and Cosine Curves, No Box') % title the plot
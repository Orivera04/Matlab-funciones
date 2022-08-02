theta = linspace(0,5*pi,500);
z = linspace(0,10,500);
figure
comet3(z.*cos(theta), z.*sin(theta), z);
hold on



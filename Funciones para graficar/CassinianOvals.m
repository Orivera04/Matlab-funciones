%% Dave's Method :)

clc
close all
clear all

a = 2;
b = 1;
x = linspace(-3,3);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
[c,h] = contour(x,y,z,[0,0,5,10,15,20,25]);
%clabel(c,h,'manual')

%% Demonstration of Variables => a

clc
close all
clear all

a = 2;
b = 1;
x = linspace(-5,5);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
contour(x,y,z,[0,0,5,10,15,20,25])

figure

a = 3;
b = 1;
x = linspace(-5,5);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
contour(x,y,z,[0,0,5,10,15,20,25])

figure

a = 4;
b = 1;
x = linspace(-5,5);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
contour(x,y,z,[0,0,5,10,15,20,25])

figure

a = 5;
b = 1;
x = linspace(-5,5);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
contour(x,y,z,[0,0,5,10,15,20,25])

%% Demonstration of Variables => b

clc
close all
clear all

a = 2;
b = 1;
x = linspace(-5,5);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
contour(x,y,z,[0,0,5,10,15,20,25])

figure

a = 2;
b = 2;
x = linspace(-5,5);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
contour(x,y,z,[0,0,5,10,15,20,25])

figure

a = 2;
b = 3;
x = linspace(-5,5);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
contour(x,y,z,[0,0,5,10,15,20,25])

figure

a = 2;
b = 4;
x = linspace(-5,5);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
contour(x,y,z,[0,0,5,10,15,20,25])

%% As a Surface

clc
close all
clear all

a = 2;
b = 1;
x = linspace(-3,3,40);
y = x;
[x,y] = meshgrid(x,y);
z = ((x-a).^2+y.^2).*((x+a).^2+y.^2)-b^4;
mesh(x,y,z)
view(135,0)
xlabel('x-axis')
ylabel('y-axis')
zlabel('z-axis')

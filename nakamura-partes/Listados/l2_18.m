% L2_18 : Figure 2.18 
% Illustrates meshplot. Plots Figure 2.13.
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 2.13; List 2.18')

clear, clf
xa = -2:.2:2;
ya = -2:.2:2;
[x,y] = meshgrid(xa,ya);
z = x .* exp(-x.^2 - y.^2);
mesh(x,y,z)
title('This is a 3-D plot of  z = x * exp(-x^2 - y^2)')
xlabel('x'); ylabel('y'); zlabel('z');


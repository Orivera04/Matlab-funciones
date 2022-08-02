% L2_20 same as f2_15
% Plots an implicit function: see Figure 2.15.
% Copyright S. Nakamura, 1995
figure(1)
set(gcf, 'NumberTitle','off','Name', 'Figure 2.15; List 2.20')
clear, clf 
xm = -3:0.2:3;  ym = -2:0.2:1;
[x, y] = meshgrid(xm, ym);
f = y.^3 + exp(y) - tanh(x);
contour(x,y,f,[0,0])
xlabel('x'); ylabel('y')


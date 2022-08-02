% f9_4 same as L9_2   
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.4; List 9.2')

clear, clf
xx = ...
[-1.0000 -0.866 -0.5000 -0.0000  0.5000 0.8660 1.0000 ...
1.0000  1.0402  1.1500  1.3000  1.5400  1.8280  2.1736 ...
2.5883 3.0860];

yy = ...
[0.0000 -0.2500 -0.4330 -0.5000 -0.4330 -0.2500 -0.0000 ...
0.0000 0.1500 0.2598 0.3000 0.3000 0.3000 0.3000 ...
0.3000 0.3000];
s=1:length(xx);sp=1:length(xx)/100:length(xx);
xp=spline(s,xx,sp);
yp=spline(s,yy,sp);
xx;
yy;
plot(xp,yp); hold on
plot(xx,yy, 'o');xlabel('x'); ylabel('y');
axis([-1 3.5 -1 1])

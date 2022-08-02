% f9_1   
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 9.1')

clear, clf, hold off
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
%plot(xp,yp); hold on
plot(xx,yy, 'o');xlabel('x'); ylabel('y');
axis([-1 3.5 -1 1])
%print fig9d1.ps

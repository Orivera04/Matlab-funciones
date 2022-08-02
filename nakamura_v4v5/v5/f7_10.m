% f7_10 same as L7_3
% Roots of two-dimensional functions. Example 7.9
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 7.10;  List 7.3')

clear, clf, hold off
x1 = 0:0.1:2;
y1 = -2:0.1:2;
[x,y] = meshgrid(x1,y1);
f1 = f_f1(x,y) ;
f2 = f_f2(x,y) ;
contour(x,y,f1, [0.00, 0.00])
hold on
contour(x,y,f2, [0.00, 0.00])
xlabel('x'); ylabel('y')
%print x7n9.ps


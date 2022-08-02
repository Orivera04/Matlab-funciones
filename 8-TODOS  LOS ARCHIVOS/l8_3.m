% L8_3 same as f8_5   
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 8.5; List 8.3')

clc; clear; clf
data=[   0.1   0.61;
         0.4   0.92;
         0.5   0.99;
         0.7   1.52;
         0.7   1.47;
         0.9   2.03];
x = data(:,1);    y = data(:,2);
A(:,1)=ones(size(x));   A(:,2)=x;   A(:,3)=sin(x);  A(:,4)=exp(x);
c = A\y;
xx = 0:0.01:1;
g= c(1)*ones(size(xx)) + c(2)*xx + c(3)*sin(xx) + c(4)*exp(xx);
axis('square');
plot(x, y,'*', xx, g);  xlabel('x'); ylabel('y')
axis([0, 1, 0, 3])

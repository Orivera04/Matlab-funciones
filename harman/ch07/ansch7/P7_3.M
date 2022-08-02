% P7_3.M Fit a 2nd degree polynomial to data
%
x=[1 2 3 4];
y=[1.7 1.8 2.3 3.2];
plot(x,y,'o')
A1=[1 1 1 1];
A=[A1' x' x.^2'];
xlsq=A'*A \ A'*y'

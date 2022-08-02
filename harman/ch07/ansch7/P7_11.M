% P7_11.M Interpolate Bessel Function J(6.3)
x=[6.0 6.2 6.4 6.6 6.8];
y=[0.15065 0.20175 0.24331 0.27404 0.29301];
% Linear Least squares
A1=[1 1 1 1 1];
A=[A1' x'];
%
xlsq1=A'*A \ A' *y';
xlsq2=polyfit(x,y,1);
f=polyval(xlsq2,x);
%
Jest=xlsq1(1)+xlsq1(2)*6.3;
J=bessel(0,6.3);	% Exact
fprintf('Least-squares linear approximation at x=6.3:\n')
fprintf('Actual value %f  Estimate %f    ',J,Jest)
fprintf('Error %f\n\n',J-Jest)
%
error=y-f;
disp('       x         y        f*        y-f*')
table=[x' y' f' error'];
disp(table)
%
clf
subplot(2,1,1), plot(x,y,'o',x,f,'-')
title('Least-Squares Linear Approximation to J0(x)')
xlabel('x')
ylabel('J0(x)')
grid


% Quadratic fit
A=[A1' x' x.^2'];
%
xlsq1=A'*A \ A' *y';
xlsq2=polyfit(x,y,2);
f=polyval(xlsq2,x);
%
Jest=xlsq1(1)+xlsq1(2)*6.3+xlsq1(3)*(6.3)^2;
J=bessel(0,6.3);	% Exact
fprintf('Least-squares Quadratic approximation at x=6.3:\n')
fprintf('Actual value %f  Estimate %f    ',J,Jest)
fprintf('Error %f\n\n',J-Jest)
%
error=y-f;
disp('       x         y        f*        y-f*')
table=[x' y' f' error'];
disp(table)
%
% Increase resolution
X1=[6:.05:6.8];
cnt=1;
for i=6:.05:6.8
 f(cnt)=xlsq1(1)+xlsq1(2)*i +xlsq1(3)*i^2;
 cnt=cnt+1;
end
%
subplot(2,1,2), plot(x,y,'o',X1,f,'-')
title('Least-Squares Quadratic Approximation to J0(x)')
xlabel('x')
ylabel('J0(x)')
grid

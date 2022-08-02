function [c1,c2]=lfit(x,y)
% Fits y=b*x^a and y=b*exp(a*x)to data using least squares.
%
% Example call: [c1,c2]=lfit(x,y)
% x and y are vectors of data.
% Data transformed logarithmically
% Returns c1=[a b] for y=b*x^a and c1=[a b] for y=b*exp(a*x)
% and plots both estimated curves.
% WARNING Do not allow x or y to be zero.
%
X=log(x); Y=log(y);
fprintf('\n\')
% Case 1
v=polyfit(X,Y,1);
a1=v(1); B=v(2); b1=exp(B); c1=[a1 b1];
e1=y-b1*x.^a1; s1=e1*e1';
fprintf('\ny = %8.4f*x^(%8.4f): Sum of sq error = %8.4f\',b1,a1,s1)
fprintf('\n\')
% case 2
v=polyfit(x,Y,1);
a2=v(1); B=v(2); b2=exp(B); c2=[a2 b2];
e2=y-b2*exp(a2*x); s2=e2*e2';
fprintf('\ny = %8.4f*exp(%8.4f*x): Sum of sq error = %8.4f\',b2,a2,s2)
fprintf('\n\')
% Plotting
[m,n]=size(x);
r=x(n)-x(1); inc=r/100;
xp=[x(1):inc:x(n)];
yp1=b1*xp.^a1; yp2=b2*exp(a2*xp);
plot(x,y,'ko',xp,yp1,'k',xp,yp2,'k:')
xlabel('x')
ylabel('f(x)')
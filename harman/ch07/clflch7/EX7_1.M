% EX7_1.M Interpolate the function y=1/(1+x^2)
%  at N+1 points with an Nth degree polynomial,
%  then compare with straight-line interpolation.
%  Test case is N=10 over the interval x=[-5 5].
N=10;                   % Choose 10th degree polynomial
x=[-5:1:5];             % 11 points
y=1./(1+x.^2);         % Runge function
% Polynomial Fit Nth degree 
p=polyfit(x,y,N);       % p holds coefficients
xplot=[-5:.1:5];        % Define finer grid (101 points)
f=polyval(p,xplot);     % Evaluate at points xplot
% Straight Line interpolation
ystl=interp1(x,y,x,'linear');
% Plot
clf                     % Clear any figures
subplot(2,1,1), plot(x,y,'o',xplot,f,'-')
title('Polynomial Interpolation Figure 7.1')
axis([-6 6 -.5 2.5])    % Set axis limits 
subplot(2,1,2), plot(x,y,'o',x,ystl)
title('Straight Line Interpolation')
axis([-6 6 -.5 2.5])
%
% Modify the script to experiment with different numbers of data points and 
%   observe the change in the approximate curves.  
%
% CLPOLYDV.M  Compute derivatives of 
%	f(x)=2x^4-7x^3+5x^2-1 
% Compare diff and polyder results 
p=[2 -7 5 0 -1];            % Coefficients
pd=polyder(p)               % Polynomial derivative
xi=linspace(0,3,100);       % 0-3 for 100 points
yder=polyval(pd,xi);        % Evaluate at xi
%
% Derivative using diff
%
x=[0:.5:3];                 % Coarse interval
y=2*x.^4-7*x.^3+5*x.^2-1;
% Using diff with 6 points 
dely=diff(y)./diff(x);
xd=x(1:length(x)-1)
%
% More accurate diff using 100 points
yder99=2*xi.^4-7*xi.^3+5*xi.^2-1;
dely1=diff(yder99)./diff(xi);
xd1=xi(1:length(xi)-1)
%
clf                          % Clear any figures
plot(xi,yder,'-'),hold on    % Ployder
plot(xd1,dely1,'-.')         % diff 99 points
plot(xd,dely,'o')            % diff  6 points  
title('Derivative Approximations')
xlabel('x'),ylabel('Dy')
legend('polyder','diff 99pts','diff 6pts')
hold off

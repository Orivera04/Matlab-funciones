% P6_20 Log(10) of maximum error versus log(2) of stepsize
%  for ydot=y, 0 <= t <= 1.
%  Calls efunc.m to compute error in Euler method for each stepsize 
h=1;    % Initial stepsize
n=15;   % Number of stepsizes = n+1
a=0;    % Initial time
b=1;    % Final time
log2x=[];
error=[];
for I=0:n;
 erfun=efunc(a,b,h);   % Compute error at x=b 
 log2x=[log2x -I];     % log2 of step sizes = -I 
 error=[error erfun];  % Vector for plotting
 h=h/2;
end
semilogy(log2x,error)
xlabel('log2 of stepsize')
ylabel('log10 of error')
title('Error versus Stepsize')
grid
%
% Version 5 Defined log2x and error as empty initially

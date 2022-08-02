%CENSUS	Try to predict the US population in the year 2000.

%	C. Moler & B. Jones, 10/27/92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

clf reset
fig = gcf;
clc
echo on

% This example is older than MATLAB.  It started as an exercise in
% "Computer Methods for Mathematical Computations", by Forsythe,
% Malcolm and Moler, published by Prentice-Hall in 1977.
%
% Now, MATLAB and Handle Graphics make it much easier to vary the
% parameters and see the results, but the underlying mathematical
% principles are unchanged:

%    Using polynomials of even modest degree to predict
%    the future by extrapolating data is a risky business.

pause  % Press any key to continue after pauses.

clc

% Here is the US Census data from 1900 to 1990.

% Time interval
t = (1900:10:1990)';

% Population
p = [75.995 91.972 105.711 123.203 131.669 ...
     150.697 179.323 203.212 226.505 249.633]';

figure(fig);
plot(t,p,'go');
axis([1900 2010 0 400]);
title('Population of the U.S. 1900-1990');
ylabel('Millions');

pause % Press any key.

clc

% What is your guess for the population in the year 2000?
p

pause % Press any key.

clear A
clc

% Let's fit the data with a polynomial in t and use it to
% extrapolate to t = 2000.  The coefficients in the polynomial
% are obtained by solving a linear system of equations involving
% a 10-by-10 Vandermonde matrix, whose elements are powers of
% scaled time, A(i,j) = s(i)^(n-j);

n = length(t);
s = (t-1900)/10;
A(:,n) = ones(n,1);
for j = n-1:-1:1
   A(:,j) = s .* A(:,j+1);
end

pause  % Press any key.

clc

% The coefficients c for a polynomial of degree d that fits the
% data p are obtained by solving a linear system of equations
% involving the last d+1 columns of the Vandermonde matrix:
%    
%        A(:,n-d:n)*c ~= p
%
% If d is less than 9, there are more equations than unknowns and
% a least squares solution is appropriate.  If d is equal to 9, the
% equations can be solved exactly and the polynomial actually interpolates
% the data.  In either case, the system is solved with MATLAB's backslash
% operator.  Here are the coefficients for the cubic fit.

c = A(:,n-3:n)\p
pause  % Press any key.

clc

% Now we evaluate the polynomial at every year from 1900 to 2010,
% plot the results, and save the "handles" of the plots for later use.

v = (1900:2010)';
x = (v-1900)/10;
y = polyval(c,x);
z = polyval(c,10);

figure(fig);
hold on
yhandle = plot(v,y,'m-');
zhandle = plot(2000,z,'yx');
ztext = text(2000,z-10,num2str(z));
title('Polynomial fit, degree = 3')
hold off

pause  % Press any key.

clc

% Finally, we establish a vector of Handle Graphics buttons
% that allow the degree of the polynomial to be varied.
% The details are in the M-files buttonv.m and censusex.m.

d = 3;
buttons = buttonv([.18 .8], 0:9, d, 'censusex', ...
   'spline', 'exp', 'bounds', 'done');

% We also provide interpolation by a cubic spline, a least squares
% fit by an exponential in t and optional confidence bounds.  The
% confidence bounds account for statistical errors in the data,
% but assume the polynomial model is correct.

echo off

% Establish handle for bounds, but don't plot anything yet.
bounds = 0;
figure(fig);
hold on
boff = [NaN*y; NaN; NaN*y];
bhandle = plot([v; NaN; v], boff,'c');
offscale = 0;
hold off

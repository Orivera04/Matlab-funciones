function [tout, yout] = df35sol(FunFcn, t0, tfinal, y0, ymin, ymax, tol)
%DFSOLVE	Integrates a single ordinary differential equation using
%	4th and 5th order Runge-Kutta formulas.  See also ODE23 and
%	ODEDEMO.M.
%	[T,Y] = DFSOLVE('yprime', T0, Tfinal, Y0, YMIN, YMAX) integrates the system
%	of ordinary differential equations described by the M-file
%	YPRIME.M over the interval T0 to Tfinal and using initial
%	conditions Y0.
%	[T, Y] = ODE45(F, T0, Tfinal, Y0, TOL, 1) uses tolerance TOL
%	and displays status while the integration proceeds.
%
% INPUT:
% F     - String containing name of user-supplied problem description.
%         Call: yprime = fun(t,y) where F = 'fun'.
%         t      - Time (scalar).
%         y      - Solution column-vector.
%         yprime - Returned derivative column-vector; yprime(i) = dy(i)/dt.
% t0    - Initial value of t.
% tfinal- Final value of t.
% y0    - Initial value column-vector.
% ymin  - the minimum value of y which is interesting.
% ymax  - the maximum value of y which is interesting.
% tol   - The desired accuracy. (Default: tol = 1.e-6).
%
% OUTPUT:
% T  - Returned integration time points (column-vector).
% Y  - Returned solution, one solution per tout-value.
%
%   John C. Polking, 7/23/1992.
%
%   based on the routine ode45 writeen by:
%
%   C.B. Moler, 3-25-87.
%   Copyright (c) 1987 by the MathWorks, Inc.
%   All rights reserved.

itlim = 1000;

% The Fehlberg coefficients:
alpha = [1/4  3/8  12/13  1  1/2]';
beta  = [ [    1      0      0     0      0    0]/4
          [    3      9      0     0      0    0]/32
          [ 1932  -7200   7296     0      0    0]/2197
          [ 8341 -32832  29440  -845      0    0]/4104
          [-6080  41040 -28352  9295  -5643    0]/20520 ]';
gamma = [ [902880  0  3953664  3855735  -1371249  277020]/7618050
          [ -2090  0    22528    21970    -15048  -27360]/752400 ]';
pow = 1/5;
if nargin < 7, tol = 1.e-6; end

% Initialization
t = t0;
hmax = abs(tfinal - t)/20;

h = (tfinal - t)/100;
if (h>=0)
			 tstart = t0-h;
    sign = 1;
else
    tstart = tfinal;
    tfinal = t0-h;
    sign = -1;
end

y = y0;
f = zeros(1,6);
tout = t;
yout = y.';

l=0;

% The main loop
   while (t>tstart) & (t < tfinal) & (y > ymin) & (y < ymax) & (l < itlim)
      if (t + h > tfinal), h = tfinal - t; end
      if (t + h < tstart), h = tstart - t; end

      % Compute the slopes
      temp = feval(FunFcn,t,y);
      f(1) = temp;
      for j = 1:5
         temp = feval(FunFcn, t+alpha(j)*h, y+h*f*beta(:,j));
         f(j+1) = temp;
      end

      % Estimate the error and the acceptable error
      delta = abs(h*f*gamma(:,2));
      tau = tol*max(abs(y),1.0);
      l = l+1;

      % Update the solution only if the error is acceptable
      if delta <= tau
         t = t + h;
         y = y + h*f*gamma(:,1);
         tout = [tout; t];
         yout = [yout; y];
      end

      % Update the step size
      if delta ~= 0.0
         absh = min(hmax, 0.8*abs(h)*(tau/delta)^pow);
         h = absh*sign;
      else
         h = hmax*sign;
      end
   end;

   if (l >= itlim)
      disp('Maximum number of iterations reached.');
      disp(['Singularity possible at t = ', num2str(t),'.']);
   end

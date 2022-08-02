function [tout, yout] = ode23(ypfun, t0, tfinal, y0, tol, trace)
%ODE23	Solve differential equations, low order method.
%	ODE23 integrates a system of ordinary differential equations using
%	2nd and 3rd order Runge-Kutta formulas.
%	[T,Y] = ODE23('yprime', T0, Tfinal, Y0) integrates the system of
%	ordinary differential equations described by the M-file YPRIME.M,
%	over the interval T0 to Tfinal, with initial conditions Y0.
%	[T, Y] = ODE23(F, T0, Tfinal, Y0, TOL, 1) uses tolerance TOL
%	and displays status while the integration proceeds.
%
%	INPUT:
%	F     - String containing name of user-supplied problem description.
%	        Call: yprime = fun(t,y) where F = 'fun'.
%	        t      - Time (scalar).
%	        y      - Solution column-vector.
%	        yprime - Returned derivative column-vector; yprime(i) = dy(i)/dt.
%	t0    - Initial value of t.
%	tfinal- Final value of t.
%	y0    - Initial value column-vector.
%	tol   - The desired accuracy. (Default: tol = 1.e-3).
%	trace - If nonzero, each step is printed. (Default: trace = 0).
%
%	OUTPUT:
%	T  - Returned integration time points (column-vector).
%	Y  - Returned solution, one solution column-vector per tout-value.
%
%	The result can be displayed by: plot(tout, yout).
%
%	See also ODE45, ODEDEMO.

%	C.B. Moler, 3-25-87, 8-26-91, 9-08-92.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Initialization
pow = 1/3;
if nargin < 5, tol = 1.e-3; end
if nargin < 6, trace = 0; end

t = t0;
hmax = (tfinal - t)/16;
h = hmax/8;
y = y0(:);
chunk = 128;
tout = zeros(chunk,1);
yout = zeros(chunk,length(y));
k = 1;
tout(k) = t;
yout(k,:) = y.';

if trace
   clc, t, h, y
end

% The main loop

while (t < tfinal) & (t + h > t)
   if t + h > tfinal, h = tfinal - t; end

   % Compute the slopes
   s1 = feval(ypfun, t, y); s1 = s1(:);
   s2 = feval(ypfun, t+h, y+h*s1); s2 = s2(:);
   s3 = feval(ypfun, t+h/2, y+h*(s1+s2)/4); s3 = s3(:);

   % Estimate the error and the acceptable error
   delta = norm(h*(s1 - 2*s3 + s2)/3,'inf');
   tau = tol*max(norm(y,'inf'),1.0);

   % Update the solution only if the error is acceptable
   if delta <= tau
      t = t + h;
      y = y + h*(s1 + 4*s3 + s2)/6;
      k = k+1;
      if k > length(tout)
         tout = [tout; zeros(chunk,1)];
         yout = [yout; zeros(chunk,length(y))];
      end
      tout(k) = t;
      yout(k,:) = y.';
   end
   if trace
      home, t, h, y
   end

   % Update the step size
   if delta ~= 0.0
      h = min(hmax, 0.9*h*(tau/delta)^pow);
   end
end

if (t < tfinal)
   disp('Singularity likely.')
   t
end

tout = tout(1:k);
yout = yout(1:k,:);

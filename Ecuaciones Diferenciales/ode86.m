function [tout, yout, ireject] = ode86(FunFcn, t0, tfinal, y0, tol)
%   ODE86 Integrates a system of ordinary differential equations using 
%   a 12-stages, 8th and 6th order Runge-Kutta formulas.  
%   Better than ODE45 for tolerances stringent than 1e-6
%   See also ODE23 ODE45 and ODEDEMO.M.
%
%	[t,y] = ODE86('yprime', t0, tfinal, y0) integrates the system
%	of ordinary differential equations described by the M-file
%	YPRIME.M over the interval T0 to Tfinal and using initial
%	conditions Y0.
%	[t, y] = ODE86(f, t0, tfinal, y0, tol) uses tolerance TOL
%
% INPUT:
% f     - String containing name of user-supplied problem description.
%         Call: yprime = fun(t,y) where F = 'fun'.
%         t      - Time (scalar).
%         y      - Solution column-vector.
%         yprime - Returned derivative column-vector; yprime(i) = dy(i)/dt.
% t0    - Initial value of t.
% tfinal- Final value of t.
% y0    - Initial value column-vector.
% tol   - The desired accuracy. (Default: tol = 1.e-8).
%
% OUTPUT:
% t  - Returned integration time points (row-vector).
% y  - Returned solution, one solution column-vector per tout-value.
% ir - Returned number of rejected steps
%
% The result can be displayed by: plot(tout, yout).
%
% Example: Solve two-body problem using inline 
% the problem :
%              y1'=y3, y2'=y4, y3'=-y1/(y1^2+y2^2)^1.5, y4'=-y2/(y1^2+y2^2)^1.5
%              Initial contitions y1(0)=.5, y2(0)=0, y3(0)=0, y4(0)=3^0.5
% Matlab call :
%              [x,y]=ode86(inline('[y(3);y(4);-y(1)/sqrt(y(1)^2+y(2)^2)^3;-y(2)/sqrt(y(1)^2+y(2)^2)^3]','x','y'), ...
%              0, 20, [.5 0 0 sqrt(3)]', 1e-11);
% 
% based on  the code ODE45 by 
% C.B. Moler, 25-3-1987, the MathWorks, Inc.
%
% The error control method and coefficients are taken from 
% Ch. Tsitouras and S. N. Papakostas, "Cheap Error Estimation for Runge-Kutta
% methods", SIAM J. Sci. Comput. 20(1999) 2067-2088.
%
% Matlab version : 6.1
% Author : Ch. Tsitouras, 1996-2003.
%---------------------------------------------------------------------------------------
% the coefficients
beta=[
[0.06338028169014085 0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 0.],
[0.0194389804273365 0.0833489654490278 0. 0. 0. 0. 0. 0. 0. 0. 0. 0.],
[0.03854547970363662 0. 0.1156364391109098 0. 0. 0. 0. 0. 0. 0. 0. 0.],
[0.394365577701125 0. -1.481871932167337 1.475103253691018 0. 0. 0. 0. 0. 0. 0. 0.],
[0.04599448910769821 0. 0. 0.2323507062639547 0.1874082292858813 0. 0. 0. 0. 0. 0. 0.],
[0.06005228953244051 0. 0. 0.1122038319463678 -0.03357232951906142 0.01672161344565858 0. 0. 0. 0. 0. 0.],
[-1.573329273208686 0. 0. -1.316708773022366 -11.72351529618177 9.10782502817387 6.512820512820513 0. 0. 0. 0. 0.],
[-0.4810762562439125 0. 0. -6.650610360746391 -4.530206099782573 3.894414525020157 8.63421764552553 0.0094016247886815 0. 0. 0. 0.],
[-0.7754121446230568 0. 0. -7.996604718235832 -6.726558607230183 5.532184454327406 10.89757332024991 0.02009165028004539 -0.03918604268037686 0. 0. 0.],
[-1.189636324544999 0. 0. -7.128368483301215 -9.53722789710108 7.57447010898087 11.26748638207092 0.05100980122305832 0.0801941346950826 -0.1581961783984735 0. 0.],
[-0.3920003904712727 0. 0. 3.916659042493857 -2.801745928908056 2.441204566481742 -2.418365577882472 -0.3394332629003293 0.1949645038310337 -0.1943717676250815 0.5930888149805792 0.]]';

alpha=[0.06338028169014085 0.1027879458763643 0.1541819188145465 0.3875968992248062 0.4657534246575343 0.1554054054054054 1.00709219858156 0.876141078561489 0.912087912087912 0.959731543624161 1.]';

gamma=[[0.04441161093250152 0. 0. 0. 0. 0.3539506311373312 0.2485219684184965 -0.3326913171720666 1.921248828652836 -2.731778300088252 1.401200440989917 0.0951361371292365],
[-0.003732456673269437 0. 0. 0. 0. -0.02947203216019219 0.01158056612815422 -0.7627079959184843 2.046330367018225 -4.163198889384351 2.901200440989918 0.]]';
%-----------------------------------------------------------------------------
ireject=0;
pow = 1/8;
if nargin < 5, tol = 1.e-8; end

% Initialization
t = t0;
hmax = (tfinal - t)/2;
hmin = (tfinal - t)/200000;
y = y0(:);
f = y*zeros(1,length(alpha)+1);
tout = t;
yout = y.';
f(:,1) = feval(FunFcn, t,y);
h=tol^pow/max(max(abs(f(:,1))),1e-2);
h=min(hmax,max(h,hmin));


% The main loop
   while (t < tfinal) & (h >= hmin)
      if t + h > tfinal, h = tfinal - t; end

      % Compute the slopes
      f(:,1) = feval(FunFcn,t,y);
      for j = 1:length(alpha),
         f(:,j+1) = feval(FunFcn, t+alpha(j)*h, y+h*f*beta(:,j));
      end

      % Estimate the error
      delta = norm(h*h*f*gamma(:,2),'inf');

      % Update the solution only if the error is acceptable
      if delta <= tol,
         t = t + h;
         y = y + h*f*gamma(:,1);
         tout = [tout; t];yout = [yout; y.'];
      else
          ireject=ireject+1;
      end

      % Update the step size
      if delta ~= 0.0
         h = min(hmax, 0.9*h*(tol/delta)^pow);
      end
   end;

   if (t < tfinal)
      disp('SINGULARITY LIKELY.')
      t
   end
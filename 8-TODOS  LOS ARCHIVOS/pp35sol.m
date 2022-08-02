function [tout, yout] = pp35sol(FunFcn, y0, cwindow,sign,stop,tol)
% PHPL3_5SOLVE	Integrates a planar autonomous system of ordinary 
%	differential equations using
%	4th and 5th order Runge-Kutta formulas.  See also ODE45
%	[T,Y] = PHPL3_5SOLVE('yprime', y0, cxint,cyint,sign,stop,tol)) 
%	integrates the system
%	of ordinary differential equations described by the M-file
%	YPRIME.M over the interval T0 to Tfinal and using initial
%	conditions Y0.
%	[T, Y] = PHPL3_5SOLVE('yptimr',y0, cxint,cyint,sign,stop,tol)uses 
%	tolerance TOL.
%
% INPUT:
% F     - String containing name of user-supplied problem description.
%         Call: yprime = fun(y) where F = 'fun'.
%         y      - Solution column-vector.
%         yprime - Returned derivative column-vector; yprime(i) = dy(i)/dt.
% t0    - Initial value of t.
% tfinal- Final value of t.
% y0    - Initial value column-vector.
% tol   - The desired accuracy. (Default: tol = 1.e-6).
% trace - If nonzero, each step is printed. (Default: trace = 0).
%
% OUTPUT:
% T  - Returned integration time points (row-vector).
% Y  - Returned solution, one solution column-vector per tout-value.
%
% The result can be displayed by: plot(tout, yout).

%   C.B. Moler, 3-25-87.
%   Copyright (c) 1987 by the MathWorks, Inc.
%   All rights reserved.

% The Fehlberg coefficients:
% alpha = [1/4  3/8  12/13  1  1/2]';   Not needed for autonomous systems.
beta  = [ [    1      0      0     0      0    0]/4
          [    3      9      0     0      0    0]/32
          [ 1932  -7200   7296     0      0    0]/2197
          [ 8341 -32832  29440  -845      0    0]/4104
          [-6080  41040 -28352  9295  -5643    0]/20520 ]';
gamma = [ [902880  0  3953664  3855735  -1371249  277020]/7618050
          [ -2090  0    22528    21970    -15048  -27360]/752400 ]';
pow = 1/5;
if nargin < 6, tol = 1.e-6; end
itlim = 1000;

% Initialization
t = 0;

hmax = 0.1;
hmin = 1e-6;
absh = 0.01;
h = absh*sign;
y = y0(:);
f = y*zeros(1,6);
tout = t;
yout = y.';
tau = tol * max(norm(y, 'inf'), 1);

cxint=cwindow(1:2);cyint=cwindow(3:4);

% Inititalize the flags

windowflag = 1;
sinkflag = 1;
orbitflag = 1;
stepflag = 1;

test =zeros(4,10);

l=0; N=0;

% The main loop
   while ((windowflag) & (sinkflag)&(orbitflag)&(stepflag)&(l<itlim))

      % Compute the slopes
      temp = feval(FunFcn,y);
      f(:,1) = temp(:);
      for j = 1:5
         temp = feval(FunFcn, y+h*f*beta(:,j));
         f(:,j+1) = temp(:);
      end

      % Estimate the error and the acceptable error
      delta = norm(h*f*gamma(:,2),'inf');
      tau = tol*max(norm(y,'inf'),1.0);
      l = l+1;

      % Update the solution only if the error is acceptable
      if delta <= tau
         tn = t + h;
         yn = y + h*f*gamma(:,1);
         tout = [tout; t];
         yout = [yout; y.'];

	% Update the flags

	windowflag = ((cxint(1)<=yn(1))&(cxint(2)>=yn(1))&(cyint(1)<=yn(2))&(cyint(2)>=yn(2)));

	if(length(tout)>25)
		sinkflag = (norm(y-yn) > stop);
	end

	kk=0;
	while ((kk<N)&(orbitflag))
		kk = kk+1;
		z=yn-test([1 2],kk);
		w=test([3 4],kk);
		a=z'*w;
		b=w'*w;
		c=z'*z;
		tt=a/b;
		dd=sqrt(max(0,c-a*tt));
		if ((tt>0)&(tt<1)&(dd < stop))
			orbitflag = 0;
		end
	end

	% Create a  new test box if necessary.

	if (rem(length(tout),25) == 0)
		if (N < 10)
			N = N+1;
			test(:,N)=[yn;y-yn];
		else
			test=[test(:,[2:10]),[yn;y-yn]];
		end
	end

	t = tn; y = yn;
end
 

     % Update the step size
      if delta ~= 0.0
         	absh = min(hmax, 0.8*absh*(tau/delta)^pow);
	         h = absh * sign;
	         stepflag = (absh > hmin);
      else
          h = hmax*sign;
      end
   end;

if (windowflag == 0)
	disp('The orbit has left the computation window.')
end

if (sinkflag == 0)
	if (sign > 0)
		disp(['The orbit ends in a possible equilibrium point near (', num2str(yn(1)),', ', num2str(yn(2)),').']);
	else
		disp(['The orbit begins in a possible equilibrium point near (', num2str(yn(1)),', ', num2str(yn(2)),').']);
	end
end

if(orbitflag == 0)
	disp('A nearly closed orbit was detected.')
end

if (l>=itlim)
	disp('Maximum number of iterations (1000) has been reached.')
end

if (stepflag==0)
	disp('A step size smaller than the minimum was required.')
	disp(['A singularity is possible near (',num2str(yn(1)),', ', num2str(yn(2)),').']);
	end


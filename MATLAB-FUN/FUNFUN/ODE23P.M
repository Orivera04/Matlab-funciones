function ode23p(FunFcn, t0, tfinal, y0, tol)
%ODE23P Solve differential equations, low order method, displaying plot.
%	Integrate a system of ordinary differential equations using
%	2nd and 3rd order Runge-Kutta formulas and plot the time evolution
%	of the first two or three components of the solution.
%	ODE23P('FUN', T0, Tfinal, Y0) generates a 2 or 3-D phase plane
%	plot of the solution to the system of ordinary differential equations
%	described by the M-file YPRIME.M over the interval T0 to Tf and using
%	initial conditions Y0.
%
%	Before calling ODE23P, establish the appropriate axis limits with
%
%	   axis([y1min y1max y2min y2max]);
%	   hold
%
%	or
%
%	   axis([y1min y1max y2min y2max y3min y3max]);
%	   hold
%
%	Then call ODE23P('FUN',t0,tfinal,y0) where
%
%	FUN   - Name of the function defininish the differential equation.
%	        yprime = fun(t,y) where
%	        t      - Time (scalar).
%	        y      - Solution column-vector.
%	        yprime - Derivative column-vector; yprime(i) = dy(i)/dt.
%	t0    - Initial value of t.
%	tfinal- Final value of t.
%	y0    - Initial value column-vector.
%	tol   - The desired accuracy. (Default: tol = 1.e-3).
%
%	C.B. Moler, 3-25-87, 10-5-91, 6-3-93, 11-22-93.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Initialization
pow = 1/3;
if nargin < 5, tol = 0.001; end

t = t0;
hmax = (tfinal - t)/16;
h = hmax/8;
y = y0(:);
tau = tol * max(norm(y, 'inf'), 1);

% Save L steps and plot like a comet tail.
L = 50;
Y = y*ones(1,L);
cla;

twodim = length(y) <= 2;
if twodim
   head = line('color','c','linestyle','o','erase','xor', ...
               'xdata',y(1),'ydata',y(2));
   body = line('color','y','linestyle','-','erase','none', ...
               'xdata',[],'ydata',[]);
   tail = line('color','m','linestyle','-','erase','none', ...
               'xdata',[],'ydata',[]);
else
   head = line('color','c','linestyle','o','erase','xor', ...
               'xdata',y(1),'ydata',y(2),'zdata',y(3));
   body = line('color','y','linestyle','-','erase','none', ...
               'xdata',[],'ydata',[],'zdata',[]);
   tail = line('color','m','linestyle','-','erase','none', ...
               'xdata',[],'ydata',[],'zdata',[]);
end

% The main loop
   while (t < tfinal) & (t + h > t)
      if t + h > tfinal, h = tfinal - t; end

      % Compute the slopes
      s1 = feval(FunFcn, t, y);
      s2 = feval(FunFcn, t+h, y+h*s1);
      s3 = feval(FunFcn, t+h/2, y+h*(s1+s2)/4);

      % Estimate the error and the acceptable error
      delta = norm(h*(s1 - 2*s3 + s2)/3,'inf');
      tau = tol*max(norm(y,'inf'),1.0);

      % Update the solution only if the error is acceptable
      ts = t;
      ys = y;
      if delta <= tau
         t = t + h;
         y = y + h*(s1 + 4*s3 + s2)/6;

         % Update the plot
         Y = [y Y(:,1:L-1)];
         if twodim
            set(head,'xdata',Y(1,1),'ydata',Y(2,1))
            set(body,'xdata',Y(1,1:2),'ydata',Y(2,1:2))
            set(tail,'xdata',Y(1,L-1:L),'ydata',Y(2,L-1:L))
         else
            set(head,'xdata',Y(1,1),'ydata',Y(2,1),'zdata',Y(3,1))
            set(body,'xdata',Y(1,1:2),'ydata',Y(2,1:2),'zdata',Y(3,1:2))
            set(tail,'xdata',Y(1,L-1:L),'ydata',Y(2,L-1:L),'zdata',Y(3,L-1:L))
         end
         drawnow;
      end

      % Update the step size
      if delta ~= 0.0
         h = min(hmax, 0.9*h*(tau/delta)^pow);
      end
   end;

   if (t < tfinal)
      disp('Singularity likely.')
      t
   end

%CENSUSEX Callback script involked by the buttons in CENSUS demo.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

gold = [.9 .6 .3];
tinv = [12.706 4.303 3.182 2.776 2.571 2.447 2.365 2.306 2.262];

if offscale, close(offscale), offscale = 0; end

if button == 13
   % Toggle confidence intervals.
   bounds = 1 - bounds;
else
   % Reset the color of the previous button.
   set(buttons(d+1),'back','default')
   % Get the new degree from the button.
   d = button-1;
   % Set the new degree to gold.
   set(buttons(d+1),'back',gold);
end

% Set the cursor to a watch to show computation in progress.
point = get(fig,'pointer');
set(fig,'pointer','watch');
drawnow

if d <= 9 
   % Polynomial fit or interpolation.  Solve the linear equation
   % involving the last d+1 columns of the Vandermonde matrix.
   [Q,R] = qr(A(:,n-d:n));
   R = R(1:d+1,:);
   Q = Q(:,1:d+1);
   c = R\(Q'*p);    % Same as c = A(:,n-d:n)\p;
   y = polyval(c,x);
   z = polyval(c,10);
   if d < 9
      title(['Polynomial fit, degree = ' int2str(d)]);
   else
      title('Polynomial interpolation, degree = 9')
   end
   if bounds
      RI = inv(R);
      E = zeros(length(x),d+1);
      for j = 1:d+1
         E(:,j) = polyval(RI(:,j),x);
      end
      e = sqrt(1+sum((E.*E)')');
      r = p - A(:,n-d:n)*c;
      if d < 9
         sig = norm(r)/sqrt(9-d) * tinv(9-d);
      else
         sig = 9;   % Just a guess.
      end
      if all(y < sig*e)
         b = boff;
         offscale = text(1950,50,'Bounds off scale.');
      else
         b = [y-sig*e; NaN; y+sig*e];
      end
   end

elseif d == 10
   % Cubic spline interpolation
   y = spline(s,p,x);
   z = spline(s,p,10);
   title('Cubic spline interpolation')
   if bounds
      I = eye(n,n);
      E = zeros(length(x),n);
      for j = 1:n
         E(:,j) = spline(s,I(:,j),x);
      end
      e = sqrt(1+sum((E.*E)')');
      sig = 9;
      b = [y-sig*e; NaN; y+sig*e];
   end

elseif d == 11
   % Exponential least squares fit
   E = [ones(size(t)) log(t)];
   [Q,R] = qr(E);
   c = R\(Q'*log(p));
   r = log(p) - E*c;
   E = [ones(size(v)) log(v)];
   y = exp(E*c);
   z = exp([1 log(2000)]*c);
   title('Exponential fit')
   if bounds
      E = E/R(1:2,1:2);
      e = sqrt(1+sum((E.*E)')');
      sig = norm(r)/sqrt(n-2) * tinv(n-2);
      b = exp(sig*e);
      b = [y./b; NaN; y.*b];
   end

else
   % Done
   clf reset
   set(fig,'pointer',point)
   disp('Done')
   return
end

% Update the plot

set(yhandle,'ydata',y);
set(zhandle,'ydata',z);
zz = max(10,min(390,z-10));  % Avoid the edge of the graph.
set(ztext,'pos',[2000 zz],'string',num2str(z))
if bounds
   set(bhandle,'ydata',b);
   set(buttons(13),'back',gold)
else
   set(bhandle,'ydata',boff);
   set(buttons(13),'back','default')
end
set(fig,'pointer',point)

function [Sxint,Spxint] = ddeval(sol,xint)
%DDEVAL Evaluates the solution computed by DDE23 at XINT.
%   DDE23 returns a solution in the form of a structure SOL.
%   DDEVAL evaluates this solution at all the entries of the 
%   vector XINT. For each K, SXINT(:,K) is the solution 
%   corresponding to XINT(K) and SPXINT(:,K) is the first
%   derivative of the solution.

%   DDE23 provides the independent variable x = sol.x as an
%   ordered row vector and y = sol.y as y(:,k) = y(x(k)). The
%   cubic Hermite interpolant also uses the slopes yp = sol.yp.
x = sol.x;    
y = sol.y;    
yp = sol.yp;

[neq, Nx] = size(y);
Nxint = length(xint);
Sxint = zeros(neq,Nxint);
if nargout == 2
   Spxint = zeros(neq,Nxint);
end

% Make a local copy of xint that is a row vector and
% if necessary, sort it to match the order of x.
Xint = xint(:)';
xdir = sign(x(end) - x(1));
had2sort = ~isempty(find( xdir*diff(Xint) < 0) );
if had2sort
  [Xint,Xint_index] = sort(xdir*Xint);
  Xint = xdir*Xint;
end  

% Using the sorted version of xint, test for illegal values.
if (xdir*(Xint(1) - x(1)) < 0) | (xdir*(Xint(end) - x(end)) > 0)
  msg = sprintf(...
  ['Attempting to evaluate the solution outside the interval\n'...
   '[%e, %e] where it is defined.\n'],x(1),x(Nx));
  error(msg)
end

evaluated = 0;
bottom = 1;
while evaluated < Nxint
  
  % Find subinterval containing the next entry of Xint.
  % There is a special case when an entry equals x(end).
  % NOTE If successive entries in x are the same and one
  %      should be selected as bottom, it will be the one
  %      of largest index except when it would be the last
  %      one.  This avoids potential difficulty with 
  %      interpolating in an interval of zero length except
  %      when the last two values are the same, which is
  %      not allowed of the input data.
  Index = find( xdir*(Xint(evaluated+1) - x(bottom:end) >= 0)) ;
  bottom = min(bottom - 1 + Index(end), Nx - 1);
  
  % Find all the entries of Xint contained in this subinterval:
  index = find( xdir*(Xint(evaluated+1:end) - x(bottom+1)) <= 0 );
    
  % Vectorized evaluation of the interpolant for all these entries:
  h = x(bottom+1) - x(bottom);            
  if h <= 0
     bottom
     x(bottom)
     pause
  end
  t = (Xint(evaluated+index) - x(bottom))/h;
  fn = y(:,bottom);
  fpn = yp(:,bottom);
  fnp1 = y(:,bottom+1);
  fpnp1 = yp(:,bottom+1);
  slope = (fnp1 - fn)/h;
  c = (3*slope - 2*fpn - fpnp1)*h;
  d = (fpn + fpnp1 - 2*slope)*h;
  t2 = t.*t;
  t3 = t2.*t;
  Sxint(:,evaluated+index) = ...
      d*t3 + c*t2 + fpn*t*h + fn*ones(size(t)); 
  if nargout == 2
     Spxint(:,evaluated+index) = ...
        (3*d*t2 + 2*c*t + fpn*h*ones(size(t)))/h;
   end
  evaluated = evaluated + length(index);
end

if had2sort     % Restore the order of xint in the output.
  [dummy,Xint_index] = sort(Xint_index);
  Sxint = Sxint(:,Xint_index);
  if nargout == 2
     Spxint = Spxint(:,Xint_index);
  end
end




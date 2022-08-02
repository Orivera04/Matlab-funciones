function ypp = cubset ( xdata, ydata )

n = length ( xdata );
%
%  Most of the entries of A are zero, so let's zero them out now and be done.
%
A = zeros ( n, n );
%
%  Left boundary condition.
%
A(1,1) = 1.0;
A(1,2) = -1.0;
%
%  Internal second derivative continuity conditions.
%
for i = 2 : n-1
  A(i,i-1) = ( xdata(i) - xdata(i-1) ) / 6.0;
  A(i,i) = ( xdata(i+1) - xdata(i-1) ) / 3.0;
  A(i,i+1) = ( xdata(i+1) - xdata(i) ) / 6.0;
end
%
%  Right boundary condition.
%
A(n,n-1) = -1.0;
A(n,n) = 1.0;
%
%  Now take care of the right hand side.
%  The ZEROS command also "shapes" RHS into a column vector
%  which is what the linear solver prefers.
%
rhs = zeros(n,1);

rhs(2:n-1) = ( ydata(3:n  )-ydata(2:n-1) ) ./ ( xdata(3:n )-xdata(2:n-1) ) ...
           - ( ydata(2:n-1)-ydata(1:n-2) ) ./ ( xdata(2:n-1)-xdata(1:n-2) );
%
%  Solve the system.
%
ypp = ( A \ rhs )';


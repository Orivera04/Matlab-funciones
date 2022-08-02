function output = spline(x,y,xx)
%SPLINE	Cubic spline data interpolation.
%	Given data vectors X and Y, and a new abscissa vector XI, the
%	function YI = SPLINE(X,Y,XI) uses cubic spline interpolation
%	to find a vector YI corresponding to XI.
%
%	Here's an example that generates a coarse sine curve, then
%	interpolates over a finer abscissa:
%
%	    x = 0:10;  y = sin(x);
%	    xi = 0:.25:10;
%	    yi = spline(x,y,xi);
%	    plot(x,y,'o',xi,yi)
%
%	PP = spline(x,y) returns the pp-form of the cubic spline interpolant
%	instead, for later use with  ppval, etc.
%
%	See also INTERP1, INTERP2, PPVAL, MKPP, UNMKPP, the Spline Toolbox.

%	Carl de Boor 7-2-86
%	Revised 11-24-87 JNL, 6-16-92 CBM.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Generate the cubic spline interpolant in pp form, depending on
% the number of data points.  (using the not-a-knot end condition).

n=length(x);[xi,ind]=sort(x);xi=xi(:);
output=[];
if n<2,
   fprintf('There should be at least two data points!\n')
elseif all(diff(xi))==0,
   fprintf('The data abscissae should be distinct!\n')
elseif n~=length(y),
   fprintf('Abscissa and ordinate vector should be of the same length!\n')
else   
   yi=y(ind);yi=yi(:);
   if (n==2), % the interpolant is a straight line
      pp=mkpp(xi',[diff(yi)./diff(xi) yi(1)]);
   elseif (n==3), % the interpolant is a parabola
      yi(2:3)=diff(yi)./diff(xi);
      yi(3)=(yi(3)-yi(2))/(xi(3)-xi(1));
      yi(2)=yi(2)-yi(3)*(xi(2)-xi(1));
      pp = mkpp([xi(1),xi(3)],yi([3 2 1])');
   else % set up the sparse, tridiagonal, linear system for the slopes at  xi .
      dx=diff(xi);divdif=diff(yi)./dx;xi31=xi(3)-xi(1);xin=xi(n)-xi(n-2);
      c = spdiags([ [dx(2:n-1);xin;0] ...
           [dx(2);2*[dx(2:n-1)+dx(1:n-2)];dx(n-2)] ...
           [0;xi31;dx(1:n-2)] ],[-1 0 1],n,n);
      b=zeros(n,1);
      b(1)=((dx(1)+2*xi31)*dx(2)*divdif(1)+dx(1)^2*divdif(2))/xi31;
      b(2:n-1)=3*(dx(2:n-1).*divdif(1:n-2)+dx(1:n-2).*divdif(2:n-1));
      b(n)=...
      (dx(n-1)^2*divdif(n-2)+(2*xin+dx(n-1))*dx(n-2)*divdif(n-1))/xin;

        % sparse linear equation solution for the slopes
      mmdflag = spparms('autommd');
      spparms('autommd',0);
      s=c\b;
      spparms('autommd',mmdflag);
        % convert to pp form
      c4=(s(1:n-1)+s(2:n)-2*divdif(1:n-1))./dx;
      c3=(divdif(1:n-1)-s(1:n-1))./dx - c4;
      pp=mkpp(xi',[c4./dx c3 s(1:n-1) yi(1:n-1)]);
   end
   if nargin==2,
      output=pp;
   else
      output=ppval(pp,xx);
   end
end

function area=simpson(funcname,a,b,n,varargin)
%
% area=simpson(funcname,a,b,n,varargin)
% -------------------------------------
% Simpson's rule integration for a general function
% defined analytically or by a data array
% 
% funcname  - either the name of a function valid
%             for a vector argument x, or an array
%             having two columns with x data in the
%             first column and y data in the second
%             column. If array data is given, then
%             the function is determined by piecewise
%             cubic spline interpolation.
% a,b       - limits of integration
% n         - odd number of function evaluations. If
%             n is given as even, then the next
%             higher odd integer is used.
% varargin  - variable number of arguments passed
%             for use in funcname 
% area      - value of the integral when the integrand
%             is approximated as a piecewise cubic
%             function
%
% User functions called: function funcname in the 
%                        argument list
%----------------------------------------------------
if 2*fix(n/2)==n; n=n+1; end; n=max(n,3);
x=linspace(a,b,n);
if isstr(funcname)
  y=feval(funcname,x,varargin{:});
else
  y=spline(funcname(:,1),funcname(:,2),x);
end
area=(b-a)/(n-1)/3*( y(1)-y(n)+...
       4*sum(y(2:2:n))+2*sum(y(3:2:n)));
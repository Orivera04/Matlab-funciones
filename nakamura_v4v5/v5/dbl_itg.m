% function dbl_itg(f_name,c_lo,c_hi,a,b,m,n) computes 
% double integration of a function by extended Simpson's 
% Rule.
% f_name : function name for integrand
%   c_lo :function name for lower bound curve
%         (function of x),c(x)
%   d_hi :  function name for upper bound curve
%         (function of x), d(x)
%      a :lower limit of integration over x
%      b :upper limit of integration over x
%      m, n: number of intervals in x and y directions, 
%           respectively.     
% Copyright S. Nakamura, 1995
function I=dbl_itg(f_name,c_lo,c_hi,a,b,m,n) 
if   m<2  | n<2
      fprintf( 'Number of intervals invalid \n' ); return
end
mpt=m+1;npt=n+1;    %number of intervals
hx = (b - a)/m ; x =a+(0:m)*hx;
for i=1:mpt
    ylo= feval(c_lo,x(i));
    yhi = feval(c_hi, x(i));
    hy=(yhi-ylo)/n;
    y(i,:)=ylo+ (0:n)*hy;
    f(i,:)=feval(f_name,x(i),y(i,:));
    G(i) = Simps_v(f(i,:),hy);
end
I = Simps_v(G,hx);


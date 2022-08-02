% function Cauchy_d(f_name, z0, k) evaluates k-th derivative of 
% function f_name by Cauchy integral.  
% z0 : the abscissa value for whish derivative is to be found.
% k  : order of derivative.
% Copyright S. Nakamura, 1995 
function f_d = cauchy_d(f_name, z0, k)
N=2480 + k*10;   r=1;
dth = 2*pi/N;
th=0:dth:2*pi-dth;
z = r*exp(i*th)+ z0;
kf=1; for m=1:k, kf=kf*m; end
f_sum  = dth*sum( feval(f_name, z)./ exp(i*k*th) );
f_d = kf/(2*pi)*f_sum/r^k;


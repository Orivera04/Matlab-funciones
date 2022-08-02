function yp=geoce(t,y)
% Subroutine for Pb. 3.6.3; EL eqns. for shooting solution of min
% distance to a point;            	                       4/1/97
%
th=y(2); lth=y(4); be=-asin(lth); sb=sin(be); cb=cos(be);
c=cos(th); s=sin(th);
yp=[c/cb c*sb/cb 0 s*(1+lth*sb)/cb]';
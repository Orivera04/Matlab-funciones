function yp=geo0e(t,y)
% Subroutine for Pb. 2.6.3f,b; EL eqns. for shooting solution of min
% distance to a meridian;                                  	 2/21/97
%
th=y(2); lth=y(4); be=-asin(lth);
yp=[cos(th)/cos(be) cos(th)*tan(be) 0 ...
      sin(th)*(1+lth*sin(be))/cos(be)]';
function yp=noshpe(t,y)                     
% Subroutine for Example 2.6.2; EL eqns. for shooting soln.
% of min drag nose shape; t --> x, s=[dD/dx r]'; u=tan(theta);
% (r,l) in units of a=r(0), drag in q*pi*a^2, q=dynamic
% pressure;                                     4/94,  8/15/02
%
r=y(2); lr=y(4); A=4*r-lr; B=12*r-2*lr; C=-lr;
if abs(A)<1e-8, u=lr/(12*r-2*lr); 
else u=sqrt((-B+sqrt(B^2-4*A*C))/(2*A));
end
yp=[4*r*u^3/(1+u^2); -u; 0; -4*u^3/(1+u^2)];


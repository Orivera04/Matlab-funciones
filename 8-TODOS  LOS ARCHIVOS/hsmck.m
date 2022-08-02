function [t,yh,ah]= ...
         hsmck(m,c,k,y0,v0,tmin,tmax,ntimes)
%
% [t,yh,ah]=hsmck(m,c,k,y0,v0,tmin,tmax,ntimes)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Solution of 
%     m*yh''(t) + c*yh'(t) + k*yh(t) = 0
% subject to initial conditions of 
%     yh(0) = y0 and yh'(0) = v0
%
% m,c,k      -  mass, damping and spring 
%               constants
% y0,v0      -  initial position and velocity
% tmin,tmax  -  minimum and maximum times
% ntimes     -  number of times to evaluate 
%               solution
% t          -  vector of times
% yh         -  displacements for the 
%               homogeneous solution
% ah         -  accelerations for the 
%               homogeneous solution
%
% User m functions called:  none.
%----------------------------------------------

t=tmin+(tmax-tmin)/(ntimes-1)*(0:ntimes-1); 
r=sqrt(c*c-4*m*k);
if r~=0
  s1=(-c+r)/(2*m); s2=(-c-r)/(2*m); 
  g=[1,1;s1,s2]\[y0;v0];
  yh=real(g(1)*exp(s1*t)+g(2)*exp(s2*t));
  if nargout > 2
    ah=real(s1*s1*g(1)*exp(s1*t)+ ...
       s2*s2*g(2)*exp(s2*t));
  end 
else
  s=-c/(2*m); 
  g1=y0; g2=v0-s*g1; yh=(g1+g2*t).*exp(s*t);
  if nargout > 2
    ah=real(s*(2*g2+s*g1+s*g2*t).*exp(s*t));
  end
end
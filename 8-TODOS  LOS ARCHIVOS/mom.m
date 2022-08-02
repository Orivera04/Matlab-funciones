function me=mom(t,alp,bet,gam,th0,w)
%
% me=mom(t,alp,bet,gam,th0,w)
% ~~~~~~~~~
% t  - time
% alp,bet,gam,th0,w
%    - physical parameters in the
%      differential equation
% me - driving moment needed to produce 
%      exact solution
%
% User m functions called:  none.
%----------------------------------------------

th=th0*sin(w*t); 
thd=w*th0*cos(w*t); thdd=-th*w^2;
s=sin(th); c=cos(th); lam=sqrt(5-4*c);
me=thdd-s+alp*thd+bet*s*(1-gam/lam);
function zdot=pinvert(t,z)
%
% zdot=pinvert(t,z)
% ~~~~~~~~~~~~~~~~~
% Equation of motion for the pendulum
% 
% t    - time value
% z    - vector [theta ; theta_dot]
% zdot - time derivative of z
%
% User m functions called:  mom
%----------------------------------------------

global alp_ bet_ gam_ ncal_
ncal_=ncal_+1; th=z(1); thd=z(2);
c=cos(th); s=sin(th); lam=sqrt(5-4*c);
zdot=[thd; 
      mom(t)+s-alp_*thd-bet_*s*(1-gam_/lam)];

%=============================================

function me=mom(t)
%
% me=mom(t)
% ~~~~~~~~~
% t  - time
% me - driving moment needed to produce 
%      exact solution
%
% User m functions called:  none.
%----------------------------------------------

global th0_ w_ alp_ bet_ gam_
th=th0_*sin(w_*t); 
thd=w_*th0_*cos(w_*t); thdd=-th*w_^2;
s=sin(th); c=cos(th); lam=sqrt(5-4*c);
me=thdd-s+alp_*thd+bet_*s*(1-gam_/lam);


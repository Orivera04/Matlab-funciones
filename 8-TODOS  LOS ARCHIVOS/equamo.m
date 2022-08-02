function zdot=equamo(t,z)
%
% zdot=equamo(t,z)
% ~~~~~~~~~~~~~~~~
% Equation of motion for a cable fixed at 
% both ends and loaded by gravity forces only
%
% t        current time value
% z        column vector defined by
%          [thet(t);theta'(t)]
% zdot     column vector defined by 
%          the concatenation
%          z'(t) = [theta'(t);theta''(t)]
%
% User m functions called:  none.
%----------------------------------------------

% Values accessed as global variables
global first_ n_ m_ len_ grav_ b_ mas_ py_

% Initialize parameters first time 
% function is called
if first_==1, first_=0;
% mass parameters
  m_=m_(:); b_=flipud(cumsum(flipud(m_))); 
  mas_=b_(:,ones(n_,1)); 
  mas_=tril(mas_)+tril(mas_,-1)';
% load effects from gravity forces
  py_=-grav_*(b_-b_(n_)); 
end

% Solve for zdot = [theta'(t); theta''(t)];
n=n_; len=len_; 
th=z(1:n); td=z(n+1:2*n); td2=td.*td;
x=len.*cos(th); y=len.*sin(th);

% Matrix of mass coefficients and 
% constraint conditions
amat=[[mas_.*(x*x'+y*y'),x,y];
      [x,y;zeros(2,2)]'];

% Right side vector involves applied forces 
% and inertial terms
bmat=x*y'; bmat=mas_.*(bmat-bmat');

% Solve for angular acceleration. 
% Most computation occurs here.
soln=amat\[x.*py_+bmat*td2; y'*td2; -x'*td2];

% Final result needed for use by the  
% numerical integrator
zdot=[td; soln(1:n)];
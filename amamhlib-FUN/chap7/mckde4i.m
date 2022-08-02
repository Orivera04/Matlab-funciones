function [t,x,tcp] = ...
     mckde4i(m,c,k,t0,x0,v0,tmax,h,incout,forc)
%
% [t,x,tcp]= ...
%    mckde4i(m,c,k,t0,x0,v0,tmax,h,incout,forc)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function uses a fourth order implicit 
% integrator with fixed stepsize to solve the 
% matrix differential equation
%           m x'' + c x' + k x = forc(t)
% where m,c, and k are constant matrices and 
% forc is an externally defined function.
%
% Input:
% ------
% m,c,k   mass, damping and stiffness matrices
% t0      starting time
% x0,v0   initial displacement and velocity
% tmax    maximum time for solution evaluation
% h       integration stepsize
% incout  number of integration steps between 
%         successive values of output
% forc    externally defined time dependent 
%         forcing function. This parameter 
%         should be omitted if no forcing 
%         function is used.      
%
% Output:
% -------
% t       time vector going from t0 to tmax 
%         in steps of h*incout
% x       matrix of solution values such 
%         that row j is the solution vector 
%         at time t(j)
% tcp     computer time for the computation
%
% User m functions called:  none.
%----------------------------------------------

if nargin > 9, force=1; else, force=0; end 
if nargout ==3, tcp=clock; end
hbig=h*incout; t=(t0:hbig:tmax)';
n=length(t); ns=(n-1)*incout; nvar=length(x0);
jrow=1; jstep=0; h2=h/2; h12=h*h/12;

% Form the inverse of the effective stiffness 
% matrix for later use.

m12=m-h12*k;
mnv=inv([[(-h2*m-h12*c),m12]; 
        [m12,(c+h2*k)]]);

% The forcing function is integrated using a 
% 2 point Gauss rule
r3=sqrt(3); b1=h*(3-r3)/6; b2=h*(3+r3)/6;

% Initialize output matrix for x and other 
% variables
xnow=x0(:); vnow=v0(:); 
tnow=t0; zroforc=zeros(length(x0),1);

if force 
  fnow=feval(forc,tnow); 
else 
  fnow=zroforc;
end
x=zeros(n,nvar); x(1,:)=xnow'; fnext=fnow;

% Main integration loop
for j=1:ns
  tnow=t0+(j-1)*h; tnext=tnow+h;
  if force
    fnext=feval(forc,tnext); 
    di1=h12*(fnow-fnext);
    di2=h2*(feval(forc,tnow+b1)+ ...
            feval(forc,tnow+b2));
    z=mnv*[(di1+m*(h*vnow)); (di2-k*(h*xnow))]; 
    fnow=fnext;
  else
    z=mnv*[m*(h*vnow); -k*(h*xnow)];
  end
  vnext=vnow + z(1:nvar); 
  xnext=xnow + z((nvar+1):2*nvar);
  jstep=jstep+1;

  % Save results every incout steps
  if jstep == incout
    jstep=0; jrow=jrow+1; x(jrow,:)=xnext';
  end

  % Update quantities for next step
  xnow=xnext; vnow=vnext; fnow=fnext;
end
if nargout==3
  tcp=etime(clock,tcp);
else 
  tcp=[]; 
end
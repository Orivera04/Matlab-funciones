function [t,x,tcp] = ...
     mckde2i(m,c,k,t0,x0,v0,tmax,h,incout,forc)
%
% [t,x,tcp]= ...
%    mckde2i(m,c,k,t0,x0,v0,tmax,h,incout,forc)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function uses a second order implicit 
% integrator % to solve the matrix differential 
% equation
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
%         in steps of
% x       h*incout to yield a matrix of 
%         solution values such that row j 
%         is the solution vector at time t(j)
% tcp     computer time for the computation
%
% User m functions called:  none.
%----------------------------------------------

if (nargin > 9); force=1; else, force=0; end
if nargout ==3, tcp=clock; end
hbig=h*incout; 
t=(t0:hbig:tmax)'; n=length(t);
ns=(n-1)*incout; ts=t0+h*(0:ns)'; 
xnow=x0(:); vnow=v0(:); 
nvar=length(x0); 
jrow=1; jstep=0; h2=h/2;

% Form the inverse of the effective 
% stiffness matrix
mnv=h*inv(m+h2*(c+h2*k));

% Initialize the output matrix for x
x=zeros(n,nvar); x(1,:)=xnow'; 
zroforc=zeros(length(x0),1);

% Main integration loop
for j=1:ns
  tj=ts(j);tjh=tj+h2;
  if force 
    dv=feval(forc,tjh); 
  else 
    dv=zroforc; 
  end
  dv=mnv*(dv-c*vnow-k*(xnow+h2*vnow));
  vnext=vnow+dv;xnext=xnow+h2*(vnow+vnext);
  jstep=jstep+1;
  if jstep == incout
    jstep=0; jrow=jrow+1; x(jrow,:)=xnext';
  end
  xnow=xnext; vnow=vnext;
end
if nargout ==3
  tcp=etime(clock,tcp);
else
  tcp=[];
end
function deislner  
%
% Example:  deislner
% ~~~~~~~~~~~~~~~~~~
% Solution error for simulation of cable
% motion using a second or a fourth order 
% implicit integrator.
%
% This program uses implicit second or fourth 
% order integrators to compute the dynamical 
% response of a cable which is suspended at 
% one end and is free at the other end. The 
% cable is given a uniform initial velocity. 
% A plot of the solution error is given for 
% two cases where approximate solutions are 
% generated using numerical integration rather 
% than modal response which is exact.
%
% User m functions required: 
%    mckde2i, mckde4i, cablemk, udfrevib, 
%    plterror

% Choose a model having twenty links of 
% equal length 

fprintf(...
'\nPlease wait: solution takes a while\n')
clear all; close
n=20; gravty=1.; n2=1+fix(n/2);
masses=ones(n,1)/n; lengths=ones(n,1)/n;

% First generate the exact solution by 
% modal superposition
[m,k]=cablemk(masses,lengths,gravty); 
c=zeros(size(m));
dsp=zeros(n,1); vel=ones(n,1); 
t0=0; tfin=50; ntim=126; h=(tfin-t0)/(ntim-1);

% Numbers of repetitions each solution is
% performed to get accurate cpu times for
% the chosen step sizes are shown below.
% Parameter jmr may need to be increased to
% give reliable cpu times on fast computers

jmr=500; 
j2=fix(jmr/50); J2=fix(jmr/25);
j4=fix(jmr/20); J4=fix(jmr/10);

% Loop through all solutions repeatedly to
% obtain more reliable timing values on fast
% computers
tic;  
for j=1:jmr;
  [tmr,xmr]=udfrevib(m,k,dsp,vel,t0,tfin,ntim);
end
tcpmr=toc/jmr;

% Second order implicit results
i2=10; h2=h/i2; tic;
for j=1:j2
  [t2,x2]=mckde2i(m,c,k,t0,dsp,vel,tfin,h2,i2);
end
tcp2=toc/j2; tr2=tcp2/tcpmr;

I2=5; H2=h/I2; tic;
for j=1:J2
  [T2,X2]=mckde2i(m,c,k,t0,dsp,vel,tfin,H2,I2);
end
Tcp2=toc/J2; Tr2=Tcp2/tcpmr;

% Fourth order implicit results
i4=2; h4=h/i4; tic; 
for j=1:j4
  [t4,x4]=mckde4i(m,c,k,t0,dsp,vel,tfin,h4,i4);
end
tcp4=toc/j4; tr4=tcp4/tcpmr;

I4=1; H4=h/I4; tic;
for j=1:J4
  [T4,X4]=mckde4i(m,c,k,t0,dsp,vel,tfin,H4,I4);
end
Tcp4=toc/J4; Tr4=Tcp4/tcpmr;

% Plot error measures for each solution
plterror(xmr,t2,h2,x2,T2,H2,X2,...
         t4,h4,x4,T4,H4,X4,tr2,Tr2,tr4,Tr4)

%=============================================

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

%=============================================

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

%=============================================

function [m,k]=cablemk(masses,lngths,gravty)
%
% [m,k]=cablemk(masses,lngths,gravty)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Form the mass and stiffness matrices for 
% the cable.
%
% masses     - vector of masses
% lngths     - vector of link lengths
% gravty     - gravity constant
% m,k        - mass and stiffness matrices
%
% User m functions called:  none.
%----------------------------------------------

m=diag(masses);
b=flipud(cumsum(flipud(masses(:))))* ...
  gravty./lngths;
n=length(masses); k=zeros(n,n); k(n,n)=b(n);
for i=1:n-1
  k(i,i)=b(i)+b(i+1); k(i,i+1)=-b(i+1);
  k(i+1,i)=k(i,i+1);
end

%=============================================

function plterror(xmr,t2,h2,x2,T2,H2,X2,...
         t4,h4,x4,T4,H4,X4,tr2,Tr2,tr4,Tr4)
% plterror(xmr,t2,h2,x2,T2,H2,X2,...
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%          t4,h4,x4,T4,H4,X4,tr2,Tr2,tr4,Tr4)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Plots error measures showing how different
% integrators and time steps compare with 
% the exact solution using modal response.
%
% User m functions called:  none
%----------------------------------------------

% Compare the maximum error in any component
% at each time with the largest deflection
% occurring during the complete time history 
maxd=max(abs(xmr(:)));
er2=max(abs(x2-xmr)')/maxd;
Er2=max(abs(X2-xmr)')/maxd;
er4=max(abs(x4-xmr)')/maxd;
Er4=max(abs(X4-xmr)')/maxd;

plot(t2,er2,'-',T2,Er2,'--');
title(['Solution Error For Implicit ',...
       '2nd Order Integrator']);
xlabel('time');
ylabel('solution error measure');
lg1=['h= ', num2str(h2),  ...
     ', relative cputime= ', num2str(tr2)];
lg2=['h= ', num2str(H2),  ...
     ', relative cputime= ', num2str(Tr2)];
legend(lg1,lg2,2); figure(gcf); 
disp('Press [Enter] to continue'); pause
% print -deps deislne2

plot(t4,er4,'-',T4,Er4,'--');
title(['Solution Error For Implicit ',...
       '4th Order Integrator']);
xlabel('time');
ylabel('solution error measure');
lg1=['h= ', num2str(h4),  ...
     ', relative cputime= ', num2str(tr4)];
lg2=['h= ', num2str(H4),  ...
     ', relative cputime= ', num2str(Tr4)];
legend(lg1,lg2,2); figure(gcf); 
% print -deps deislne4 
disp(' '), disp('All Done')

%=============================================

% function [t,u,mdvc,natfrq]=...
%              udfrevib(m,k,u0,v0,tmin,tmax,nt)
% See Appendix B


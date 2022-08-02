function t=fltim(y)
%
% t=fltim(y)
% ~~~~~~~~~~
%
% This function evaluates the time descent 
% integral for a spline curve having heights 
% stored in y.
%
% y - vector defining the curve heights at 
%     interior points corresponding to base 
%     positions in xc
%
% t - the numerically integrated time descent 
%     integral evaluated by use of base points 
%     cbp and weight factors cwf passed as 
%     global variables
%
% User m functions called: splined
%----------------------------------------------

global xc cofs nparts bp wf nfcls cbp cwf ...
       b_over_a

nfcls=nfcls+1; x=cbp;

% Generate coefficients used in spline 
% interpolation
yc=[0;y(:);0];
y=spline(xc,yc,x); yp=splined(xc,yc,x);

% Evaluate the integrand 
f=(1+(b_over_a*(1+yp)).^2)./(x+y); f=sqrt(f);

% Evaluate the integral
t=cwf(:)'*f(:);
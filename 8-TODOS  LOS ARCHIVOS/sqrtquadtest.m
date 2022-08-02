function [vg,tg,vL,tL,pctdiff]=sqrtquadtest
%
% [vg,tg,vL,tL,pctdiff]=sqrtquadtest
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function compares the accuracy and 
% computation time for functions quadgsqrt 
% and quadlsqrt to evaluate: 
% integral(exp(u*x)*cos(v*x)/radical(x), a<x<b)
% where radical(x) is sqrt(x-a), sqrt(b-x), or
% sqrt((x-a)*(b-x))

%----------------------------------
% Program Output

% >> sqrtquadtest;
 
% EVALUATING INTEGRALS WITH SQUARE ROOT TYPE
%     SINGULARITIES AT THE END POINTS

% Function integrated:
% ftest(x,u,v)=exp(u*x).*cos(v*x)

% a = 1   b = 4
% u = 3   v = 10
 
% Results from function gquadsqrt
% 4.836504484e+003 -8.060993912e+003 -4.264510048e+003
% Computation time = 0.0159 sec.
 
% Results from function quadlsqrt
% 4.836504484e+003 -8.060993912e+003 -4.264510048e+003
% Computation time = 7.03 sec.
 
% Percent difference for the two methods
% -3.6669e-012 -1.5344e-012 1.4929e-012
% >>

%-------------------------------------

% The test function
ftest=inline('exp(u*x).*cos(v*x)','x','u','v');

% Limits and function parameters
a=1; b=4; u=3; v=10;

nloop=100; tic;
for j=1:nloop
  v1g=quadgsqrt(ftest,1,a,b,40,1,u,v);
  v2g=quadgsqrt(ftest,2,a,b,40,1,u,v);
  v3g=quadgsqrt(ftest,3,a,b,40,1,u,v);
end
vg=[v1g,v2g,v3g]; tg=toc/nloop;
disp(' ')
disp('EVALUATING INTEGRALS WITH SQUARE ROOT TYPE')
disp('     SINGULARITIES AT THE END POINTS') 
disp(' ')
disp('Function integrated:')
disp('ftest(x,u,v)=exp(u*x).*cos(v*x)')
disp(' ')
disp(['a = ',num2str(a),'   b = ',num2str(b)])
disp(['u = ',num2str(u),'   v = ',num2str(v)])
disp(' ')
disp('Results from function gquadsqrt')
fprintf('%17.9e %17.9e %17.9e\n',vg)
disp(['Computation time = ',num2str(tg),' sec.'])

tol=1e-12; tic;
v1L=quadlsqrt(ftest,1,a,b,tol,[],u,v);
v2L=quadlsqrt(ftest,2,a,b,tol,[],u,v);
v3L=quadlsqrt(ftest,3,a,b,tol,[],u,v);
vL=[v1L,v2L,v3L]; tL=toc;

disp(' ')
disp('Results from function quadlsqrt')
fprintf('%17.9e %17.9e %17.9e\n',vL)
disp(['Computation time = ',num2str(tL),' sec.'])

pctdiff=100*(vg-vL)./vL; disp(' ')
disp('Percent difference for the two methods')
fprintf('%13.4e %12.4e %12.4e\n',pctdiff)

%=========================================

function v=quadgsqrt(...
              func,type,a,b,norder,nsegs,varargin)
%
% v=quadgsqrt(func,type,a,b,norder,nsegs,varargin)
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function evaluates an integral having a
% square root type singularity at one or both ends
% of the integration interval a<x<b. Composite
% Gauss integration is used with func(x) treated 
% as a polynomial of degree norder.
% The integrand has the form:
% func(x)/sqrt(x-a) if type==1. 
% func(x)/sqrt(b-x) if type==2. 
% func(x)/sqrt((x-a)*(b-x)) if type==3.
% The integration interval is subdivided into
% nsegs subintervals of equal length.
%
% func   - a character string or function handle
%          naming a function continuous in the 
%          interval from x=a to x=b 
% type   - 1 if the integrand is singular at x=a
%          2 if the integrand is singular at x=b
%          3 if the integrand is singular at both
%            x=a and x=b.
% a,b    - integration limits with b>a
% norder - polynomial interpolation order within 
%          each interval. Lowest norder is 20.
% nsegs  - number of integration subintervals 
%
% User m functions called: gcquad
%
% Reference: Abromowitz and Stegun, 'Handbook of
%            Mathematical Functions', Chapter 25
% -------------------------------------------

if nargin<6, nsegs=1; end; 
if nargin<5, norder=50; end
switch type
  case 1  % Singularity at the left end.
          % Use Gauss quadrature
    [dumy,bp,wf]=gcquad(...
      '',0,sqrt(b-a),norder+1,nsegs);
    t=a+bp.^2; y=feval(func,t,varargin{:});
    v=wf(:)'*y(:)*2;
  case 2  % Singularity at the right end.
          % Use Gauss quadrature
    [dumy,bp,wf]=gcquad(...
      '',0,sqrt(b-a),norder+1,nsegs);
    t=b-bp.^2; y=feval(func,t,varargin{:});
    v=wf(:)'*y(:)*2;
  case 3  % Singularity at both ends.
          % Use Chebyshev integration
    n=norder; bp=cos(pi/(2*n+2)*(1:2:2*n+1));
    c1=(b+a)/2; c2=(b-a)/2; t=c1+c2*bp;
    y=feval(func,t,varargin{:});
    v=pi/(n+1)*sum(y);
end

%=========================================

function v=quadlsqrt(fname,type,a,b,tol,trace,varargin)
%
% v=quadlsqrt(fname,type,a,b,tol,trace,varargin)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function uses the MATLAB integrator quadl
% to evaluate integrals having square root type
% singularities at one or both ends of the 
% integration interval a < x < b. 
% The integrand has the form:
% func(x)/sqrt(x-a) if type==1. 
% func(x)/sqrt(b-x) if type==2. 
% func(x)/sqrt((x-a)*(b-x)) if type==3.
%
% func   - the handle for a function continuous
%          from x=a to x=b 
% type   - 1 if the integrand is singular at x=a
%          2 if the integrand is singular at x=b
%          3 if the integrand is singular at both
%            x=a and x=b.
% a,b    - integration limits with b > a

if nargin<6 | isempty(trace), trace=0; end
if nargin<5 | isempty(tol), tol=1e-8; end
if nargin<7
  varargin{1}=type; varargin{2}=[a,b];
  varargin{3}=fname;
else
  n=length(varargin); c=[a,b]; varargin{n+1}=type;
  varargin{n+2}=c; varargin{n+3}=fname;
end

if type==1 | type==2
  v=2*quadl(@fshift,0,sqrt(b-a),...
    tol,trace,varargin{:});
else  
  v=quadl(@fshift,0,pi,tol,trace,varargin{:});
end

%=========================================

function u=fshift(x,varargin)
% u=fshift(x,varargin)
% This function shifts arguments to produce
% a nonsingular integrand called by quadl
N=length(varargin); fname=varargin{N};
c=varargin{N-1}; type=varargin{N-2};
a=c(1); b=c(2); c1=(b+a)/2; c2=(b-a)/2;

switch type
  case 1, t=a+x.^2; case 2, t=b-x.^2;
  case 3, t=c1+c2*cos(x);
end

if N>3, u=feval(fname,t,varargin{1:N-3});
else, u=feval(fname,t); end

%=========================================

% function [val,bp,wf]=gcquad(func,xlow,...  
%              xhigh,nquad,mparts,varargin)
% See Appendix B

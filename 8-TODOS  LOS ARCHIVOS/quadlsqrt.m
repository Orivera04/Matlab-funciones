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
% func(x)/sqrt(x-a) if type==1 
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
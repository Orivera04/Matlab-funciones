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
% func(x)/sqrt(x-a) if type==1 
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

% ==================================================

function [val,bp,wf]=gcquad(func,xlow,...
                     xhigh,nquad,mparts,varargin)
%
% [val,bp,wf]=gcquad(func,xlow,...
%     xhigh,nquad,mparts,varargin)

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function integrates a general function using 
% a composite Gauss formula of arbitrary order. The 
% integral value is returned along with base points
% and weight factors obtained by an eigenvalue based 
% method. The integration interval is divided into
% mparts subintervals of equal length and integration
% over each part is performed with a Gauss formula
% making nquad function evaluations. Results are 
% exact for polynomials of degree up to 2*nquad-1.   
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% func         - name of a function to be integrated
%                having an argument list of the form
%                func(x,p1,p2,...) where any auxiliary
%                parameters p1,p2,.. are passed through
%                variable varargin. Use [ ] for the
%                function name if only the base points
%                and weight factors are needed.
% xlow,xhigh   - integration limits
% nquad        - order of Gauss formula chosen
% mparts       - number of subintervals selected in 
%                the composite integration
% varargin     - variable length parameter used to
%                pass additional arguments needed in
%                the integrand func
% val          - numerical value of the integral
% bp,wf        - vectors containing base points and 
%                weight factors in the composite
%                integral formula
%
% A typical calculation such as:
% Fun=inline('(sin(w*t).^2).*exp(c*t)','t','w','c');
% A=0; B=12; nquad=21; mparts=10; w=10; c=8;  
% [value,pcterr]=integrate(Fun,A,B,nquad,mparts,w,c);
% gives value = 1.935685556078172e+040 which is 
% accurate within an error of 1.9e-13 percent.
%
% User m functions called:  the function name passed 
%                           in the argument list

%----------------------------------------------

 if isempty(nquad),  nquad=10; end
 if isempty(mparts), mparts=1; end

% Compute base points and weight factors 
% for the single interval [-1,1]. (Ref:
% 'Methods of Numerical Integration' by
% P. Davis and P. Rabinowitz, page 93)

u=(1:nquad-1)./sqrt((2*(1:nquad-1)).^2-1);
[vc,bp]=eig(diag(u,-1)+diag(u,1));
[bp,k]=sort(diag(bp)); wf=2*vc(1,k)'.^2;

% Modify the base points and weight factors
% to apply for a  composite interval
d=(xhigh-xlow)/mparts;  d1=d/2;
dbp=d1*bp(:); dwf=d1*wf(:);  dr=d*(1:mparts);
cbp=dbp(:,ones(1,mparts))+ ...
dr(ones(nquad,1),:)+(xlow-d1);
cwf=dwf(:,ones(1,mparts)); wf=cwf(:); bp=cbp(:);

% Compute the integral
if isempty(func)
  val=[];
else
  f=feval(func,bp,varargin{:}); val=wf'*f(:);
end
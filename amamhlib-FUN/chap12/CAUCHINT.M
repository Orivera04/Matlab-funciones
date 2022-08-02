function F=cauchint(fb,zb,z,nquad)
%
% F=cauchint(fb,zb,z,nquad)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function numerically evaluates a Cauchy
% integral of the form:
%
%   F(z)=1/(2*pi*i)*Integral(f(t)/(t-z)*dt)
%
% where t denotes points on a curve in the
% complex plane. The boundary curve is defined
% by spline interpolation through data points
% zb lying on the curve. The values of f(t)
% are also specified by spline interpolation
% through values fb corresponding to the 
% points zb. Numerical evaluation of the  
% integral is performed using a composite 
% Gauss formula of arbitrary order.
%
% fb    - values of density function f
%         at point on the curve
% zb    - points where fb is given. The
%         number of values of zb must be
%         adequate to define the curve
%         accurately.
% z     - a matrix of values at which the 
%         Cauchy integral is to be evaluated.
%         If any of the z-values lie on path 
%         of integration or too close to the
%         path of integration, incorrect  
%         results will be obtained.
% nquad - the order of Gauss quadrature
%         formula used to perform numerical
%         integration
%
% F     - The value of the Cauchy integral
%         corresponding to matrix argument z
%
% User m functions called:  gcquad splined
%----------------------------------------------

n=length(fb); [nr,nc]=size(z); z=z(:).'; 
nz=length(z); t=1:n; 
[dummy,bp,wf]=gcquad('',1,n,nquad,n-1);
fq=spline(t,fb,bp); zq=spline(t,zb,bp);
zqd=splined(t,zb,bp);
bdrylen=sum(abs(zq(2:nq)-zq(1:nq-1)));
closnes=1e100; bigz=max(abs(z));
for j=1:nq
  closnes=min([closnes,abs(zq(j)-z)]);
end
if closnes/bdrylen<.01 | closnes/bigz<.01
 disp(['WARNING! SOME DATA VALUES ARE ', ...
       'EITHER NEAR OR ON']);
 disp(['THE BOUNDARY. COMPUTED RESULTS ', ...
       'MAY BE INACCURATE']);
end 
F=wf(:)'*(fq(:,ones(1,nz))./(zq(:,ones(1,nz))...
                             -z(ones(nq,1),:)));
F=reshape(F,nr,nc)/(2*pi*i);

%=============================================

function [val,bp,wf]=gcquad(func,xlow,...
                     xhigh,nquad,mparts,varargin)
%
% [val,bp,wf]=gcquad(func,xlow,...
%     xhigh,nquad,mparts,varargin)

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function integrates a general function using 
% a composite Gauss formula of arbitrary order. The 
% integral value is returned along with base point and
% weight factor vectors computed by a formulation using 
% eigenvalue calculation. The integration interval is
% divided into mparts sections of equal length and 
% integration over each part is performed with a Gauss
% formula making nquad function evaluations. Results 
% are exact for polynomials of degree up to 2*nquad-1.   
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

%=============================================

function val=splined(xd,yd,x,if2)
%
% val=splined(xd,yd,x,if2)
% ~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function evaluates the first or second 
% derivative of the piecewise cubic 
% interpolation curve defined by the intrinsic 
% function spline provided in MATLAB.If fewer
% than four data points are input, then simple
% polynomial interpolation is employed
%
% xd,yd - data vectors determining the spline
%         curve produced by function spline
% x     - vector of values where the first or
%         the second derivative are desired
% if2   - a parameter which is input only if 
%         y''(x) is required. Otherwise, y'(x)
%         is returned.
%
% val   - the first or second derivative values
%         for the spline
%
% User m functions called: none

n=length(xd); [b,c]=unmkpp(spline(xd,yd)); 
if n>3 % Use a cubic spline
  if nargin==3, c=[3*c(:,1),2*c(:,2),c(:,3)];
  else, c=[6*c(:,1),2*c(:,2)]; end
  val=ppval(mkpp(b,c),x);  
else % Use a simple polynomial
  c=polyder(polyfit(xd(:),yd(:),n-1));
  if nargin==4, c=polyder(c); end
  val=polyval(c,x);
end
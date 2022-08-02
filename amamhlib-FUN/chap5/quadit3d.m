function s = quadit3d(f,c,b1,b2,a1,a2,w)
%
% s = quadit3d(f,c,b1,b2,a1,a2,w)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes the iterated integral
%
% s = integral(...
%     f(x,y,z), x=a1..a2, y=b1..b2, z=c1..c2)
%
% where a1 and a2 are functions of y and z, b1
% and b2 are functions of z, and c is a vector
% containing constant limits on the z variable.
% Hence, as many as five external functions may
% be involved in the call list. For example,
% when the integrand and limits are:
%
% f  = x.^2+y^2+z^2 
% a2 = sqrt(4-y^2-z^2)
% a1 = -a2
% b2 = sqrt(4-z^2)
% b1 = -b2
% c = [-2,2]
%
% Then the exact value is 128*pi/5.
% The approximation produced from a 20 point
% Gauss formula is accurate within .007 percent. 
%
% f     - a function f(x,y,z) which must return
%         a vector value when x is a vector, 
%         and y and z are scalar.
% a1,a2 - integration limits on the x variable
%         which may specify names of functions
%         or have constant values. If a1 is a
%         function it should have a call list 
%         of the form a1(y,z). A similar form 
%         applies to a2.
% b1,b2 - integration limits on the y variable
%         which may specify functions of z or 
%         have constant values.
% c     - a vector defined by c=[c1,c2] where 
%         c1 and c2 are fixed integration 
%         limits for the z direction.
% w     - this argument defines the quadrature
%         formula used. It has the following
%         three possible forms. If w is omitted,
%         a Gauss formula of order 12 is used. 
%         If w is a positive integer n, a Gauss
%         formula of order n is used. If w is an
%         n by 2 matrix, w(:,1) contains the base
%         points and w(:,2) contains the weight
%         factors for a quadrature formula over
%         limits -1 to 1.
%
% s     - the numerically evaluated integral
%
% User m functions called:  gcquad
%----------------------------------------------

if nargin<7
% function gcquad generates base points
% and weight factors 
  n=12; [dummy,x,W]=gcquad('',-1,1,n,1);
elseif size(w,1)==1 & size(w,2)==1
  n=w; [dummy,x,W]=gcquad('',-1,1,n,1); 
else
 n=size(w,1); x=w(:,1); W=w(:,2);
end
s=0; cp=(c(1)+c(2))/2; cm=(c(2)-c(1))/2;

for k=1:n
  zk=cp+cm*x(k);
  if ischar(b1), B1=feval(b1,zk);
  else, B1=b1; end
  
  if ischar(b2), B2=feval(b2,zk);
  else, B2=b2; end
  
  Bp=(B2+B1)/2; Bm=(B2-B1)/2; sj=0;
  
  for j=1:n
    yj=Bp+Bm*x(j); 
    if ischar(a1), A1=feval(a1,yj,zk);
    else, A1=a1; end
    
    if ischar(a2), A2=feval(a2,yj,zk);
    else, A2=a2; end
    
    Ap=(A2+A1)/2; Am=(A2-A1)/2; 
    fval=feval(f, Ap+Am*x, yj, zk);
    si=fval(:).'*W(:); sj=sj+W(j)*Am*si;
  end
  s=s+W(k)*Bm*sj;
end
s=cm*s;

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
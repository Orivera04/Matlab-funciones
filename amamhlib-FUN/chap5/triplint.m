function val=triplint(n) 
%
% val=triplint(n)
% ~~~~~~~~~~~~~~~
% Triple integration example on inertial 
% moment of a sphere.
%
% User m functions called:  fsphere, bs1, bs2,
%                           as1, as2

if nargin==0, n=20; end
val=quadit3d('fsphere',[-1,1],'bs1','bs2',...
             'as1','as2',n)/(88*pi/15);

%=============================================

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

function v=fsphere(x,y,z) 
%
% v=fsphere(x,y,z) 
% ~~~~~~~~~~~~~~~~
% Integrand.
%----------------------------------------------

v=(x-2).^2+y.^2;

%=============================================

function x=as1(y,z) 
%
% x=as1(y,z) 
% ~~~~~~~~~~
% Lower x integration limit.
%----------------------------------------------

x=-sqrt(1-y.^2-z.^2);

%=============================================

function x=as2(y,z) 
%
% x=as2(y,z)
% ~~~~~~~~~~
% Upper x integration limit.
%----------------------------------------------

x=sqrt(1-y.^2-z.^2);

%=============================================

function y=bs1(z)
%
% y=bs1(z)
% ~~~~~~~~
% Lower y integration limit.
%----------------------------------------------

y=-sqrt(1-z.^2);

%=============================================

function y=bs2(z)  
%
% y=bs2(z)
% ~~~~~~~~~~
% Upper y integration limit.
%----------------------------------------------

y=sqrt(1-z.^2);

%=============================================

% function [val,bp,wf]=gcquad(func,xlow,...
%                  xhigh,nquad,mparts,varargin)
% See Appendix B

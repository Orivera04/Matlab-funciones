function u=cauchtst(z,nquad)
% 
% u=cauchtst(z,nquad)
% ~~~~~~~~~~~~~~~~~~~
%
% This function solves a mixed boundary
% value problem for the interior of a circle
% by numerically evaluating a Cauchy integral.
%
%  z     - matrix of complex coordinates where
%          function values are computed
%  nquad - order of Gauss quadrature used to
%          perform numerical integration
%
%  u     - computed values of the approximate
%          solution
%
% User m functions called: cauchint, mbvtest,
%             gcquad, splined

if nargin<2, nquad=50; end; nbdat=61; 
if nargin==0
  z=linspace(0,.99,10)'* ...
    exp(i*linspace(0,2*pi,91));
end
th=linspace(-pi/2,pi/2,nbdat); zb=exp(i*th);
fb=sqrt(zb-i).*sqrt(zb+i); fb(1)=1; fb(nbdat)=1;
fb=cos(th)./fb; fb(1)=0; fb(end)=0;
F=cauchint(fb,zb,z,nquad);
F=F.*sqrt(z-i).*sqrt(z+i); u=2*real(F); close

surf(real(z),imag(z),u); xlabel('x axis');
ylabel('y axis'); zlabel('Solution Value')
title(['Approximate Solution to ', ...
       'a Mixed Boundary Value Problem']);
grid on; figure(gcf); %gra(.4);
fprintf('\nPress [Enter] to solution error\n');
pause
%print -deps caucher1
uexact=mbvtest(z,1); udif=u-uexact;
clf; surf(real(z),imag(z),udif); 
title(['Difference Between Exact and ', ...
       'Approximate Solutions']);
xlabel('x axis'); ylabel('y axis'); 
zlabel('Solution Error')
grid on; figure(gcf); %gra(.4)
%print -deps caucher2

%=============================================

function u=mbvtest(z,noplot)
%
% u=mbvtest(z,noplot)
% ~~~~~~~~~~~~~~~~~~~
%
% This function determines a function which is
% harmonic for abs(z)<1 and satisfies at r=1,
%   u=cos(theta), -pi/2<theta<pi/2
%   du/dr=0,       pi/2<theta<3*pi/2
% The solution only applies for points inside 
% or on the unit circle.
%
% z      - matrix of complex values where the
%          solution is computed.  
% noplot - option set to one if no plot is 
%          requested, otherwise option is not 
%          required.
% 
% u      - values of the harmonic function
%          defined inside the unit circle
%
% User m functions called:  none
%----------------------------------------------

if nargin==0
  noplot=0; 
  z=linspace(0,1,10)'* ...
    exp(i*linspace(0,2*pi,81));
end
[n,m]=size(z); z=z(:); u=1/2*ones(size(z));
k=find(abs(z)>0); Z=z(k);
U=(Z+1./Z+(1-1./Z).*sqrt(Z-i).*sqrt(Z+i))/2;
u(k)=real(U); u=reshape(u,n,m); 
if nargin==1 | noplot==0
  z=reshape(z,n,m);  
  surf(real(z),imag(z),u); xlabel('x axis');
  ylabel('y axis');
  title(['Mixed Boundary Value Problem ', ...
         'for a Circular Disk']);
  grid; figure(gcf); %gra(.4), pause
  %print -deps mbvtest
end

%=============================================

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
zqd=splined(t,zb,bp); nq=length(fq);
fq=fq(:).*zqd(:); 

bdrylen=sum(abs(zq(2:nq)-zq(1:nq-1)));

closnes=1e100; bigz=max(abs(z));
for j=1:nq
  closnes=min([closnes,abs(zq(j)-z)]);
end
if closnes/bdrylen<.01 | closnes/bigz<.01
  disp(' ')
  disp(['WARNING! SOME DATA VALUES ARE ', ...
       'EITHER NEAR OR ON']);
  disp(['THE BOUNDARY. COMPUTED RESULTS ', ...
       'MAY BE INACCURATE']); disp(' ')
end 
F=wf(:)'*(fq(:,ones(1,nz))./(zq(:,ones(1,nz))...
                             -z(ones(nq,1),:)));
F=reshape(F,nr,nc)/(2*pi*i);

%=============================================

% function [val,bp,wf]=gcquad(func,xlow,...
%                      xhigh,nquad,mparts,varargin)
% See Appendix B

%=============================================

% function val=splined(xd,yd,x,if2)
% See Appendix B
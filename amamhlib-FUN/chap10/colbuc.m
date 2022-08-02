function [p,y,x]=colbuc(len,ei,nseg,endc)
% [p,y,x]=colbuc(len,ei,nseg,endc)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines the Euler buckling 
% load for a slender column of variable cross 
% section which can have any one of four 
% constraint conditions at the column ends.
% 
% len  - the column length
% ei   - the product of Young's modulus and the 
%        cross section moment of inertia. This 
%        quantity is defined as a piecewise 
%        linear function specified at one or 
%        more points along the length.  ei(:,1)
%        contains ei values at points 
%        corresponding to x values given in 
%        ei(:,2). Values at intermediate points 
%        are computed by linear interpolation
%        using function lintrp which allows
%        jump discontinuities in ei.
% nseg - the number of segments into which the 
%        column is divided to perform finite 
%        difference calculations.The stepsize h 
%        equals len/nseg.
% endc - a parameter specifying the type of end 
%        condition chosen. 
%          endc=1, both ends pinned
%          endc=2, x=0 free, x=len fixed
%          endc=3, x=0 pinned, x=len fixed
%          endc=4, both ends fixed
%
% p    - the Euler buckling load of the column
% x,y  - vectors describing the shape of the 
%        column in the buckled mode. x varies 
%        between 0 and len. y is normalized to 
%        have a maximum value of one.
%
% User m functions called:  lintrp, trapsum

if nargin==0;
  ei=[1 0; 1 10; 1000 10; 1000 20];
  nseg=100; endc=3; len=20;
end
 
% If the column has constant cross section, 
% then ei can be given as a single number. 
% Also, use at least 20 segments to assure  
% that computed results will be reasonable.
if size(ei,1) < 2 
  ei=[ei(1,1),0; ei(1,1),len]; 
end
nseg=max(nseg,30);

if endc==1       
% pinned-pinned case (y=0 at x=0 and x=len)
  str='Pinned-Pinned Buckling Load = ';
  h=len/nseg; n=nseg-1; x=linspace(h,len-h,n); 
  eiv=lintrp(ei(:,2),ei(:,1),x);
  a=-diag(ones(n-1,1),1); 
  a=a+a'+diag(2*ones(n,1));
  [yvecs,pvals]=eig(diag(eiv/h^2)*a); 
  pvals=diag(pvals);
  % Discard any spurious nonpositive eigenvalues
  j=find(pvals<=0); 
  if length(j)>0, pvals(j)=[]; yvecs(:,j)=[]; end
  [p,k]=min(pvals); y=[0;yvecs(:,k);0]; 
  [ym,j]=max(abs(y)); y=y/y(j); x=[0;x(:);len]; 
elseif endc==2    
% free-fixed case (y=0 at x=0 and y'=0 at x=len)
  str='Free-Fixed Buckling Load = ';
  h=len/nseg; n=nseg-1; x=linspace(h,len-h,n); 
  eiv=lintrp(ei(:,2),ei(:,1),x);
  a=-diag(ones(n-1,1),1); 
  a=a+a'+diag(2*ones(n,1));
  % Zero slope at x=len implies 
  % y(n+1)=4/3*y(n)-1/3*y(n-1). This
  % leads to y''(n)=(y(n-1)-y(n))*2/(3*h^2).
  a(n,[n-1,n])=[-2/3,2/3];
  [yvecs,pvals]=eig(diag(eiv/h^2)*a); 
  pvals=diag(pvals);
  % Discard any spurious nonpositive eigenvalues
  j=find(pvals<=0); 
  if length(j)>0, pvals(j)=[]; yvecs(:,j)=[]; end
  [p,k]=min(pvals); y=yvecs(:,k); 
  y=[0;y;4*y(n)/3-y(n-1)/3]; [ym,j]=max(abs(y)); 
  y=y/y(j); x=[0;x(:);len];
elseif endc==3   
% pinned-fixed case 
% (y=0 at x=0 and x=len, y'=0 at x=len)
  str='Pinned-Fixed Buckling Load = ';
  h=len/nseg; n=nseg; x=linspace(h,len,n); 
  eiv=lintrp(ei(:,2),ei(:,1),x);
  a=-diag(ones(n-1,1),1); 
  a=a+a'+diag(2*ones(n,1));
  % Use a five point backward difference 
  % approximation for the second derivative 
  % at x=len.
  v=-[35/12,-26/3,19/2,-14/3,11/12]; 
  a(n,n:-1:n-4)=v; a=diag(eiv/h^2)*a;
  % Form the equation requiring zero deflection 
  %   at x=len. 
  b=x(:)'.*[ones(1,n-1),1/2]./eiv(:)'; 
  % Impose the homogeneous boundary condition
  q=null(b); [z,pvals]=eig(q'*a*q); 
  pvals=diag(pvals);
  % Discard any spurious nonpositive eigenvalues
  k=find(pvals<=0); 
  if length(k)>0, pvals(k)=[]; z(:,k)=[]; end;
  vecs=q*z; [p,k]=min(pvals); mom=[0;vecs(:,k)]; 
  % Compute the slope and deflection from 
  %   moment values.
  yp=trapsum(0,len,mom./[1;eiv(:)]); 
  yp=yp-yp(n+1);  y=trapsum(0,len,yp);
  [ym,j]=max(abs(y)); y=y/y(j); x=[0;x(:)];
else             
% fixed-fixed case 
% (y and y' both zero at each end)
  str='Fixed-Fixed Buckling Load = ';
  h=len/nseg; n=nseg+1; x=linspace(0,len,n); 
  eiv=lintrp(ei(:,2),ei(:,1),x);
  a=-diag(ones(n-1,1),1); 
  a=a+a'+diag(2*ones(n,1));
  % Use five point forward and backward 
  % difference approximations for the second 
  % derivatives at each end.
  v=-[35/12,-26/3,19/2,-14/3,11/12];
  a(1,1:5)=v; a(n,n:-1:n-4)=v; 
  a=diag(eiv/h^2)*a;
  % Write homogeneous equations to make the 
  % slope and deflection vanish at x=len.
  b=[1/2,ones(1,n-2),1/2]./eiv(:)'; 
  b=[b;x(:)'.*b];
  % Impose the homogeneous boundary conditions
  q=null(b); [z,pvals]=eig(q'*a*q); 
  pvals=diag(pvals);
  % Discard any spurious nonpositive eigenvalues 
  k=find(pvals<=0); 
  if length(k>0), pvals(k)=[]; z(:,k)=[]; end;
  vecs=q*z; [p,k]=min(pvals); mom=vecs(:,k); 
  % Compute the moment and slope from moment 
  % values.
  yp=trapsum(0,len,mom./eiv(:)); 
  y=trapsum(0,len,yp);
  [ym,j]=max(abs(y)); y=y/y(j);
end

close;
plot(x,y); grid on; 
xlabel('axial direction'); 
ylabel('transverse deflection');
title([str,num2str(p)]); figure(gcf);
print -deps buck

%=============================================

function v=trapsum(a,b,y,n)
%
% v=trapsum(a,b,y,n)
% ~~~~~~~~~~~~~~~~~~
%
% This function evaluates:
%
%   integral(a=>x, y(x)*dx) for a<=x<=b
%
% by the trapezoidal rule (which assumes linear
% function variation between succesive function
% values).
%
% a,b - limits of integration
% y   - integrand which can be a vector valued
%       function returning a matrix such that
%       function values vary from row to row.
%       It can also be input as a matrix with
%       the row size being the number of
%       function values and the column size
%       being the number of components in the
%       vector function.
% n   - the number of function values used to
%       perform the integration.  When y is a
%       matrix then n is computed as the number
%       of rows in matrix y.
%
% v   - integral value
%
% User m functions called:  none
%----------------------------------------------

if isstr(y)
  % y is an externally defined function
  x=linspace(a,b,n)'; h=x(2)-x(1);
  Y=feval(y,x); % Function values must vary in 
                % row order rather than column 
                % order or computed results 
                % will be wrong.
  m=size(Y,2);
else
  % y is column vector or a matrix
  Y=y; [n,m]=size(Y); h=(b-a)/(n-1);
end
v=[zeros(1,m); ...
  h/2*cumsum(Y(1:n-1,:)+Y(2:n,:))];

%=============================================

function ei=eilt(h1,h2,L,n,E)
%
% ei=eilt(h1,h2,L,n,E)
% ~~~~~~~~~~~~~~~~~~~~
%
% This function computes the moment of inertia 
% along a linearly tapered circular cross 
% section and then uses that value to produce
% the product EI.
%
% h1,h2 - column diameters at each end
% L     - column length
% n     - number of points at which ei is
%         computed
% E     - Young's modulus
%
% ei    - vector of EI values along column
%
% User m functions called:  none
%----------------------------------------------

if nargin<5, E=1; end; 
x=linspace(0,L,n)';
ei=E*pi/64*(h1+(h2-h1)/L*x).^4;
ei=[ei(:),x(:)];

%=============================================

% function y=lintrp(xd,yd,x)
% See Appendix B

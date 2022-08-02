function [z,a,b]=elipdplt(rx,ry)
% [z,a,b]=elipdplt(rx,ry)
% ~~~~~~~~~~~~~~~~~~~~~~~
% This function plots contour lines showing 
% how a polar coordinate grid in a circular  
% disk maps onto an elliptic disk.
%
% User m functions called: elipdisk, gridview
               
if nargin==0, rx=2; ry=1; end
zeta=linspace(.3,1,12)'* ...
     exp(i*linspace(0,pi/2,61));
[z,a,b]=elipdisk(zeta,rx,ry); 
x=real(z); y=imag(z);
gridview(x,y,'x axis','y axis',...
  'Mapping abs(ZETA)<1 onto an Elliptic Disk');
colormap([1 1 1]); shg
print -deps elipdisk

%=============================================

function gridview(x,y,xlabl,ylabl,titl)
%
% gridview(x,y,xlabl,ylabl,titl)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function views a surface from the top 
% to show the coordinate lines of the surface. 
% It is useful for illustrating how coordinate 
% lines distort under a conformal transformation. 
% Calling gridview with no arguments depicts the 
% mapping of a polar coordinate grid map under 
% a transformation of the form 
% z=R*(zeta+m/zeta).
%
%  x,y         - real matrices defining a 
%                curvilinear coordinate system
%  xlabl,ylabl - labels for x and y axes
%  titl        - title for the graph
%
% User m functions called:  cubrange
%----------------------------------------------

close
if nargin<5  
  xlabl='real axis'; ylabl='imaginary axis';
  titl=''; 
end

% Default example using z=R*(zeta+m/zeta)
if nargin==0  
  zeta=linspace(1,3,10)'* ...
       exp(i*linspace(0,2*pi,81));
  a=2; b=1; R=(a+b)/2; m=(a-b)/(a+b);   
  z=R*(zeta+m./zeta); x=real(z); y=imag(z);
  titl=['Circular Annulus Mapped onto an ', ...
        'Elliptical Annulus'];
end

range=cubrange([x(:),y(:)],1.1);

% The data defin a curve
if size(x,1)==1 | size(x,2)==1 
  plot(x,y,'-k'); xlabel(xlabl); ylabel(ylabl);
  title(titl); axis('equal'); axis(range);
  grid on; figure(gcf);
  if nargin==0  
    print -deps gridviewl
  end
% The data defin a surface
else                           
  plot(x,y,'k-',x',y','k-')
  xlabel(xlabl); ylabel(ylabl); title(titl);
  axis('equal'); axis(range); grid on;
  figure(gcf);
  if nargin==0  
    print -deps gridview
  end
end

%=============================================

function [z,a,b]=elipdisk(zeta,rx,ry)
%
% [z,a,b]=elipdisk(zeta,rx,ry)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes a rational function 
% mapping abs(zeta)<=1 onto an elliptical disk 
% defined by (x/rx)^2+(y/ry)^2<=1. Boundary 
% points are computed using theory from 
%   P. Henrici, Applied Complex Analysis, 
%   Vol 3, p391.
% The rational function approximation has the 
% form:
%        z=sum(a(j)*zeta^(2*j-1)) /
%          (1+sum(b(j)*zeta^(2*j));
%
%  zeta  - matrix of points with abs(zeta)<=1
%  rx,ry - ellipse semidiameters on x and y 
%          axes
%
%  z     - points into which zeta maps
%  a,b   - coefficients in the rational 
%          function defining the map
%
% User m functions called: ratcof
%----------------------------------------------

ntrms=100; ntheta=251; 
tau=(0:2*pi/ntheta:2*pi)'; 
ep=(rx-ry)/(rx+ry); 
z=exp(i*tau); z=z+ep*conj(z);
j=1:ntrms;  ep=ep.^j; ep=ep./(j.*(1+ep.*ep));
theta=tau+2*( sin((2*tau+pi)*j)*ep'); 
zta=exp(i*theta); z=rx/max(real(z))*z; 
[a,b]=ratcof(zta.^2,z./zta,8);
a=fix(real(1e8*a))/1e8; b=fix(real(1e8*b))/1e8;
af=flipud(a(:)); bf=flipud([1;b(:)]); 
zta2=zeta.^2;
z=zeta.*polyval(af,zta2)./polyval(bf,zta2);

%=============================================

function [a,b]=ratcof(xdata,ydata,ntop,nbot)
%
% [a,b]=ratcof(xdata,ydata,ntop,nbot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Determine a and b to approximate ydata as 
% a rational function of the variable xdata. 
% The function has the form:
%
%    y(x) = sum(1=>ntop) ( a(j)*x^(j-1) ) /
%         ( 1 + sum(1=>nbot) ( b(j)*x^(j)) )
%
% xdata,ydata - input data vectors (real or 
%               complex)
% ntop,nbot   - number of series terms used in 
%               the numerator and the 
%               denominator.
%
% User m functions called: none
%----------------------------------------------

ydata=ydata(:); xdata=xdata(:); 
m=length(ydata);
if nargin==3, nbot=ntop; end;
x=ones(m,ntop+nbot); x(:,ntop+1)=-ydata.*xdata;
for i=2:ntop, x(:,i)=xdata.*x(:,i-1); end
for i=2:nbot 
  x(:,i+ntop)=xdata.*x(:,i+ntop-1); 
end
ab=x\ydata; 
a=ab(1:ntop); b=ab(ntop+1:ntop+nbot); 

%==============================================

% function range=cubrange(xyz,ovrsiz)
% See Appendix B
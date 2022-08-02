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

% close
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

% The data define a curve
if size(x,1)==1 | size(x,2)==1 
  plot(x,y,'-k'); xlabel(xlabl); ylabel(ylabl);
  title(titl); axis('equal'); axis(range);
  grid on; figure(gcf);
  if nargin==0  
    print -deps gridviewl;
  end
% The data define a surface
else                           
  plot(x,y,'k-',x',y','k-')
  xlabel(xlabl); ylabel(ylabl); title(titl);
  axis('equal'); axis(range); grid on;
  figure(gcf);
  if nargin==0  
    print -deps gridview;
  end
end

%==============================================

function range=cubrange(xyz,ovrsiz)
%
% range=cubrange(xyz,ovrsiz)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines limits for a square 
% or cube shaped region for plotting data values 
% in the columns of array xyz to an undistorted 
% scale
%
% xyz    - a matrix of the form [x,y] or [x,y,z]
%          where x,y,z are vectors of coordinate
%          points
% ovrsiz - a scale factor for increasing the
%          window size. This parameter is set to
%          one if only one input is given.
%
% range  - a vector used by function axis to set
%          window limits to plot x,y,z points
%          undistorted. This vector has the form
%          [xmin,xmax,ymin,ymax] when xyz has
%          only two columns or the form 
%          [xmin,xmax,ymin,ymax,zmin,zmax]
%          when xyz has three columns.
%
% User m functions called:  none
%----------------------------------------------

if nargin==1, ovrsiz=1; end
pmin=min(xyz); pmax=max(xyz); pm=(pmin+pmax)/2;
pd=max(ovrsiz/2*(pmax-pmin));
if length(pmin)==2
  range=pm([1,1,2,2])+pd*[-1,1,-1,1];
else
  range=pm([1 1 2 2 3 3])+pd*[-1,1,-1,1,-1,1];
end
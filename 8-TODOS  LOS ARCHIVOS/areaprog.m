function [p,x,y,xd,yd]=areaprog(xd,yd,icrnr)
%
% [p,x,y,xd,yd]=areaprog(xd,yd,icrnr)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function calls function aprop which
% computes geometrical properties for an area
% bounded by a spline curve through data
% points in (xd,yd).
%
% User functions called: aprop

if nargin==2,icrnr=[1,length(xd)]; end
titl='AREA IN THE XY PLANE';

if nargin==0
  [xd,yd,icrnr]=makcrcsq;
  titl=...
  'HALF ANNULUS ABOVE A SQUARE WITH A HOLE';
end

disp(' ')
disp(['      GEOMETRICAL PROPERTY ANALYSIS',...
      ' USING FUNCTION APROP'])
[p,z]=aprop(xd,yd,icrnr); x=real(z); y=imag(z);
disp('  ');
disp(['      A         XCG       YCG   ',...
      '    AXX       AXY       AYY'])
disp(p), close, plot(xd,yd,'ko',x,y,'k-')

xlabel('x axis'), ylabel('y axis')
title(titl),axis(cubrange([x(:),y(:)],1.2));
axis square; shg

%=========================================

function [p,zplot]=aprop(xd,yd,kn)
%
% [p,zplot]=aprop(xd,yd,kn)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines geometrical properties
% of a general plane area bounded by a spline 
% curve
% 
% xd,yd - data points for spline interpolation
%         with the boundary traversed in counter-
%         clockwise direction. The first and last 
%         points must match for boundary closure.
% kn    - vector of indices of points where the
%         slope is discontinuous to handle corners
%         like those needed for shapes such as a
%         rectangle.
% p     - the vector [a,xcg,ycg,axx,axy,ayy]
%         containing the area, centroid coordinates,
%         moment of inertia about the y-axis,
%         product of inertia, and moment of inertia
%         about the x-axis
% zplot - complex vector of boundary points for 
%         plotting the spline interpolated geometry.
%         The points include the numerical quadrature
%         points interspersed with data values.
%
% User functions called: gcquad, curve2d
if nargin==0 
  td=linspace(0,2*pi,13); kn=[1,13];
  xd=cos(td)+1; yd=sin(td)+1;
end
nd=length(xd); nseg=nd-1;
[dum,bp,wf]=gcquad([],1,nd,6,nseg);
[z,zplot,zp]=curve2d(xd,yd,kn,bp);
w=[ones(size(z)), z, z.*conj(z), z.^2].*...
   repmat(imag(conj(z).*zp),1,4);
v=(wf'*w)./[2,3,8,8]; vr=real(v); vi=imag(v);
p=[vr(1:2),vi(2),vr(3)+vr(4),vi(4),vr(3)-vr(4)];
p(2)=p(2)/p(1); p(3)=p(3)/p(1);

%=========================================

function [z,zplot,zp]=curve2d(xd,yd,kn,t)
%
% [z,zplot,zp]=curve2d(xd,yd,kn,t)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function generates a spline curve through
% given data points with corners(slope dis-
% continuities) allowed as selected points.
% xd,yd - real data vectors of length nd 
%         defining the curve traversed in 
%         counterclockwise order. 
% kn    - vectors of point indices, between one
%         and nd, where slope discontinuities
%         occur
% t     - a vector of parameter values at which 
%         points on the spline curve are 
%         computed. The components of t normally
%         range from one to nd, except when t is
%         a negative integer,-m. Then t is 
%         replaced by a vector of equally spaced 
%         values using m steps between each 
%         successive pair of points.
% z     - vector of points on the spline curve
%         corresponding to the vector t
% zplot - a complex vector of points suitable
%         for plotting the geometry
% zp    - first derivative of z with respect to
%         t for the same values of t as is used
%         to compute z
%
% User m functions called:  splined
%----------------------------------------------

nd=length(xd); zd=xd(:)+i*yd(:); td=(1:nd)';
if isempty(kn), kn=[1;nd]; end 
kn=sort(kn(:)); if kn(1)~=1, kn=[1;kn]; end
if kn(end)~=nd, kn=[kn;nd]; end
N=length(kn)-1; m=round(abs(t(1))); 
if -t(1)==m, t=linspace(1,nd,1+N*m)'; end
z=[]; zp=[]; zplot=[];
for j=1:N
  k1=kn(j); k2=kn(j+1); K=k1:k2;
  k=find(k1<=t & t<k2);
  if j==N, k=find(k1<=t & t<=k2); end
  if ~isempty(k)
    zk=spline(K,zd(K),t(k)); z=[z;zk];
    zplot=[zplot;zd(k1);zk];
    if nargout==3
      zp=[zp;splined(K,zd(K),t(k))];
    end
  end
end
zplot=[zplot;zd(end)];

%=========================================

function [x,y,icrnr]=makcrcsq
%
% [x,y,icrnr]=makcrcsq
% ~~~~~~~~~~~~~~~~~~~~
% This function creates data for a geometry 
% involving half of an annulus placed above a 
% square containing a square hole.
%
% x,y   - data points characterizing the data
% icrnr - index vector defining corner points
%
% User m functions called:  none
%----------------------------------------------

xshift=3.0; yshift=3.0;
a=2; b=1; narc=7; x0=0; y0=2*a-b;
xy=[a,-a,-b, b, b,-b,-b,-a,-a, a, a;
    a, a, b, b,-b,-b, b, a,-a,-a, a]';
theta=linspace(0,pi,narc)'; 
c=cos(theta); s=sin(theta); 
xy=[xy;[x0+a*c,y0+a*s]]; 
c=flipud(c); s=flipud(s);
xy=[xy;[x0+b*c,y0+b*s];[a,y0];[a,a]];
x=xy(:,1)+xshift; y=xy(:,2)+yshift;
icrnr=[(1:12)';11+narc;12+narc; ...
       11+2*narc;12+2*narc;13+2*narc];

%=========================================

% function [val,bp,wf]=gcquad(func,xlow,...
%                    xhigh,nquad,mparts,varargin)
% See Appendix B

%=========================================

% function range=cubrange(xyz,ovrsiz)
% See Appendix B

%=========================================

% function val=splined(xd,yd,x,if2)
% See Appendix B

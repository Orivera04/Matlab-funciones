function [u,ux,uy,X,Y]=laplarec(...
                   ubot,utop,ulft,urht,a,b,nx,ny,N)
%                 
% [u,ux,uy,X,Y]=laplarec(...
%               ubot,utop,ulft,urht,a,b,nx,ny,N)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This program evaluates a harmonic function and its
% first partial derivatives in a rectangular region.
% The method employs a Fourier series expansion.
% ubot   - defines the boundary values on the bottom
%          side. This can be an array in which
%          ubot(:,1) is x coordinates and ubot(:,2)
%          is function values. Values at intermediate
%          points are obtained by piecewise linear
%          interpolation. A character string giving
%          the name of a function can also be used.
%          Then the function is evualuated using 200
%          points along a side to convert ubot to an
%          array. Similar comments apply for utop,
%          ulft, and urht introduced below.
% utop   - boundary value definition on the top side
% ulft   - boundary value definition on the left side
% urht   - boundary value definition on the right side
% a,b    - rectangle dimensions in x and y directions
% nx,ny  - number of x and y values for which the
%          solution is evaluated 
% N      - number of terms used in the Fourier series
% u      - function value for the solution
% ux,uy  - first partial derivatives of the solution
% X,Y    - coordinate point arrays where the solution
%          is evaluated
%
% User m functions used: datafunc ulinbc 
%                        recseris ftsincof

disp(' ')
disp('SOLVING THE LAPLACE EQUATION IN A RECTANGLE')
disp(' '), close

if nargin==0
   disp(...
      'Give the name of a function defining the data')   
   datfun=input(...
      '(try datafunc as an example): > ? ','s');
   [ubot,utop,ulft,urht,a,b,nx,ny,N]=feval(datfun);
end 

% Create a grid to evaluate the solution
x=linspace(0,a,nx); y=linspace(0,b,ny); 
[X,Y]=meshgrid(x,y); d=(a+b)/1e6;
xd=linspace(0,a,201)'; yd=linspace(0,b,201)';

% Check whether boundary values are given using
% external functions. Convert these to arrays

if isstr(ubot)
   ud=feval(ubot,xd); ubot=[xd,ud(:)];
end
if isstr(utop)
   ud=feval(utop,xd); utop=[xd,ud(:)];
end
if isstr(ulft)
   ud=feval(ulft,yd); ulft=[yd,ud(:)];
end
if isstr(urht)
   ud=feval(urht,yd); urht=[yd,ud(:)];
end

% Determine function values at the corners
ub=interp1(ubot(:,1),ubot(:,2),[d,a-d]);
ut=interp1(utop(:,1),utop(:,2),[d,a-d]);
ul=interp1(ulft(:,1),ulft(:,2),[d,b-d]);
ur=interp1(urht(:,1),urht(:,2),[d,b-d]);
U=[ul(1)+ub(1),ub(2)+ur(1),ur(2)+ut(2),...
      ut(1)+ul(2)]/2;

% Obtain a solution satisfying the corner
% values and varying linearly along the sides

[v,vx,vy]=ulinbc(U,a,b,X,Y);

% Reduce the corner values to zero to improve
% behavior of the Fourier series solution 
% near the corners

f=inline('u0+(u1-u0)/L*x','x','u0','u1','L');
ubot(:,2)=ubot(:,2)-f(ubot(:,1),U(1),U(2),a);
utop(:,2)=utop(:,2)-f(utop(:,1),U(4),U(3),a);
ulft(:,2)=ulft(:,2)-f(ulft(:,1),U(1),U(4),b);
urht(:,2)=urht(:,2)-f(urht(:,1),U(2),U(3),b);

% Evaluate the series and combine results
% for the various component solutions

[ub,ubx,uby]=recseris(ubot,a,b,1,x,y,N);
[ut,utx,uty]=recseris(utop,a,b,2,x,y,N);
[ul,ulx,uly]=recseris(ulft,a,b,3,x,y,N);
[ur,urx,ury]=recseris(urht,a,b,4,x,y,N);
u=v+ub+ut+ul+ur; ux=vx+ubx+utx+ulx+urx;
uy=vy+uby+uty+uly+ury; close

% Show results graphically

surfc(X,Y,u), xlabel('x axis'), ylabel('y axis')
zlabel('U(X,Y)')
title('HARMONIC FUNCTION IN A RECTANGLE')
shg, pause
% print -deps laprecsr

contour(X,Y,u,30); title('Contour Plot');
xlabel('x direction'); ylabel('y direction'); 
colorbar, shg, pause
% print -deps laprecnt

surf(X,Y,ux), xlabel('x axis'), ylabel('y axis')
zlabel('DU(X,Y)/DX')
title('DERIVATIVE OF U(X,Y) IN THE X DIRECTION')
shg, pause
% print -deps laprecdx

surf(X,Y,uy), xlabel('x axis'), ylabel('y axis')
zlabel('DU(X,Y)/DY')	
title('DERIVATIVE OF U(X,Y) IN THE Y DIRECTION')
% print -deps laprecdy
shg

%============================================ 

function [ubot,utop,ulft,urht,a,b,...
                              nx,ny,N]=datafunc
%  
% [ubot,utop,ulft,urht,a,b,...
%         nx,ny,N]=datafunc
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This is a sample data case which can be 
% modified to apply to other examples
%
% ubot, utop - vectors of function values on the
%              bottom and top sides 
% ulft, urht - vectors of function values on the
%              right and left sides
% a, b       - rectangle dimensions along the 
%              x and y axis
% nx, ny     - number of grid values for the x
%              and y directions
% N          - number of terms used in the
%              Fourier series solution

a=3; b=2; e=1e-5; N=100;
x=linspace(0,1,201)'; s=sin(pi*x);
c=cos(pi*x); ubot=[a*x,2-4*s];
utop=[a*x,interp1([0,1/3,2/3,1],...
      [-2,2,2,-2],x)];
ulft=[b*x,2*c]; urht=ulft; nx=51; ny=31;

%============================================

function [u,ux,uy]=ulinbc(U,a,b,X,Y)
%
% [u,ux,uy]=ulinbc(U,a,b,X,Y)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines a harmonic function
% varying linearly along the sides of a rectangle
% with specified corner values
%
% U     - corner values of the harmonic function
%         [U(1),...U(4)] <=> corner coordinates
%         (0,0), (0,a), (a,b), (0,b)
% a,b   - rectangle dimensions in the x and y
%         directions
% X,Y   - array coordinates where the solution
%         is evaluated
% u     - function values evaluated for X,Y
% ux,uy - first derivative components evaluated
%         for the X,Y arrays

c=[1,0,0,0;1,a,0,0;1,a,b,a*b;1,0,b,0;]\U(:);
u=c(1)+c(2)*X+c(3)*Y+c(4)*X.*Y;
ux=c(2)+c(4)*Y; uy=c(3)+c(4)*X;

%============================================

function [u,ux,uy,X,Y]=recseris(udat,a,b,iside,x,y,N)
%
% [u,ux,uy,X,Y]=recseris(udat,a,b,iside,x,y,N)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes a function harmonic in
% a rectangle with general function values given
% on one side and zero function values on the 
% other three sides.
% udat    - a data array to determine the function
%           values by piecewise linear interpolation
%           along the side having nonzero values.
%           udat(:,1) contains either x or y values
%           along a side, and udat(:,2) contains
%           corresponding function values
% a,b     - side lengths for the x and y directions
% iside   - an index indicating the side for which
%           function values are given. 
%           [1,2,3,4]<=>[bottom,top,left,right]
% x,y       data vectors defining a grid 
%           [X,Y]=meshgrid(x,y) on which the function
%           and its first partial derivatives are
%           computed
% N       - number of series terms used (up to 500)
% u,ux,uy - arrays of values of the harmonic function
%           and its first partial derivatives
% X,Y       arrays of coordinate values for which
%           function values were computed.

x=x(:)'; y=y(:); ny=length(y); N=min(N,500);
if iside<3, period=2*a; else, period=2*b; end
c=ftsincof(udat,period); n=1:N; c=c(n);
if iside<3     % top or bottom sides
   npa=pi/a*n; c=c./(1-exp(-2*b*npa));
   sx=sin(npa(:)*x); cx=cos(npa(:)*x);
   if iside==1 % bottom side
      dy=exp(-y*npa); ey=exp(-(2*b-y)*npa);
      u=repmat(c,ny,1).*(dy-ey)*sx;
      c=repmat(c.*npa,ny,1);
      ux=c.*(dy-ey)*cx; uy=-c.*(dy+ey)*sx;
   else        % top side
      dy=exp((y-b)*npa); ey=exp(-(y+b)*npa);
      u=repmat(c,ny,1).*(dy-ey)*sx; 
      c=repmat(c.*npa,ny,1);
      ux=c.*(dy-ey)*cx; uy=c.*(dy+ey)*sx;
   end
else           % left or right sides
   npb=pi/b*n; c=c./(1-exp(-2*a*npb));
   sy=sin(y*npb); cy=cos(y*npb);
   if iside==3 % left side
      dx=exp(-npb(:)*x);
      ex=exp(-npb(:)*(2*a-x));
      u=repmat(c,ny,1).*sy*(dx-ex);
      c=repmat(c.*npb,ny,1);
      ux=c.*sy*(-dx-ex); uy=c.*cy*(dx-ex);
   else        % right side
      dx=exp(-npb(:)*(a-x)); 
      ex=exp(-npb(:)*(a+x));
      u=repmat(c,ny,1).*sy*(dx-ex);
      c=repmat(c.*npb,ny,1);
      ux=c.*sy*(dx+ex); uy=c.*cy*(dx-ex);
   end
end
[X,Y]=meshgrid(x,y);

%============================================

function c=ftsincof(y,period)
%
% c=ftsincof(y,period)
% ~~~~~~~~~~~~~~~~~~~
% This function computes 500 Fourier sine
% coefficients for a piecewise linear 
% function defined by a data array 
% y      - an array defining the function
%          over half a period as
%          Y(x)=interp1(y(:,1),y(:,2),x)
% period - the period of the function
% 
xft=linspace(0,period/2,513);
uft=interp1(y(:,1),y(:,2)/512,xft);
c=fft([uft,-uft(512:-1:2)]); 
c=-imag(c(2:501)); 

function [X,Y,Z]=rgdbodmo(x,y,z,v,R0)
% 
% [X,Y,Z]=rgdbodmo(x,y,z,v,R0)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function transforms coordinates x,y,z to 
% new coordinates X,Y,Z by rotating and 
% translating the reference frames. When no
% input is given, an example involving an 
% ellipsoid is run.
%
% x,y,z - initial coordinate matrices referred
%         to base vectors [1;0;0], [0;1;0] and
%         [0;0;1]. Columns of v are used to
%         create new basis vectors i,j,k such
%         that a typical point [a;b;c] is
%         transformed into [A;B;C] according
%         to the equation
%            [A;B;C]=R0(:)+[i,j,k]*[a;b;c]
% v     - a matrix having three rows and either
%         one or two columns used to construct
%         the new basis [i,j,k] according to
%         methods employed function rotatran
% R0    - a vector which translates the rotated
%         coordinates when R0 is input. 
%         Otherwise no translation is imposed.
%
% X,Y,Z - matrices containing the transformed
%         coordinates        
%
% User m functions called: elipsoid, rotatran

if nargin==0
  [x,y,z]=elipsoid(1,1,2,[17,33],0);R0=[3;4;5];
  v=[[1;1;1],[1;1;0]];
end
[n,m]=size(x); XYZ=[x(:),y(:),z(:)]*rotatran(v)';
X=XYZ(:,1); Y=XYZ(:,2); Z=XYZ(:,3);
if ~isempty(R0) 
  X=X+R0(1); Y=Y+R0(2); Z=Z+R0(3); 
end
X=reshape(X,n,m); Y=reshape(Y,n,m); 
Z=reshape(Z,n,m);
if nargin==0
  close; surf(X,Y,Z), axis equal, grid on
  title('ROTATED AND TRANSLATED ELLIPSOID')  
  xlabel('x axis'), ylabel('y axis')
  zlabel('z axis'),colormap([1 1 1]); shg
end

%==============================================

function [x,y,z]=elipsoid(a,b,c,n,noplot)
%
% [x,y,z]=elipsoid(a,b,c,n,noplot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function plots an ellipsoid having semi-
% diameters a,b,c
% a,b,c  - semidiameters of the ellipsoid defined
%          by (x/a)^2+(y/b)^2+(z/c)^2=1
% n      - vector [nth,nph] giving the number of
%          theta values and phi values used to plot
%          the surface
% noplot - omit this parameter if no plot is desired
% x,y,z  - matrices of points on the surface
%
% User m functions called: none
%----------------------------------------------

if nargin==0, a=2; b=1.5; c=1; n=[17,33]; end
nth=n(1); nph=n(2); 
th=linspace(-pi/2,pi/2,nth)'; ph=linspace(-pi,pi,nph);
x=a*cos(th)*cos(ph); y=b*cos(th)*sin(ph);
z=c*sin(th)*ones(size(ph));
if nargin<5
   surf(x,y,z); axis equal
   title('ELLIPSOID'), xlabel('x axis')
   ylabel('y axis'), zlabel('z axis')
   colormap([1 1 1]); grid on, figure(gcf)
end

%==============================================

function mat=rotatran(v)
%
% mat=rotatran(v)
% ~~~~~~~~~~~~~~~
% This function creates a rotation matrix based 
% on the columns of v.
%
% v   - a matrix having three rows and either
%       one or two columns which are used to
%       create an orthonormal triad [i,j,k]
%       returned in the columns of mat. The
%       third base vector k is defined as
%       v(:,1)/norm(v(:,1)). If v has two 
%       columns then, v(:,1) and v(:,2) define 
%       the xz plane with the direction of j 
%       defined by cross(v(:,1),v(:2)). If only 
%       v(:,1) is input, then v(:,2) is set 
%       to [1;0;0].
%
% mat - the matrix having columns containing 
%       the basis vectors [i,j,k]
%
% User m functions called: none
%----------------------------------------------

k=v(:,1)/norm(v(:,1)); 
if size(v,2)==2, p=v(:,2); else, p=[1;0;0]; end
j=cross(k,p); nj=norm(j); 
if nj~=0
  j=j/nj; mat=[cross(j,k),j,k];
else 
  mat=[[0;1;0],cross(k,[0;1;0]),k];
end   

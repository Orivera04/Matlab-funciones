function [dfl,cof]=membran(h,np,ns,nx,ny)
% [dfl,cof]=membran(h,np,ns,nx,ny)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes the transverse 
% deflection of a uniformly tensioned membrane 
% which is subjected to uniform pressure. The 
% membrane shape is a rectangle of width h and 
% height two joined with a semicircle of 
% diameter two.
%
% Example use:  membran(0.75,100,50,40,40);
%
% h       - the width of the rectangular part
% np      - the number of least square points 
%           used to match the boundary 
%           conditions in the least square 
%           sense is about 3.5*np
% ns      - the number of terms used in the 
%           approximating series to evaluate 
%           deflections. The series has the
%           form
% 
%           dfl = abs(z)^2/4 + 
%                 sum({j=1:ns},cof(j)*
%                 real(z^(j-1)))
%
% nx,ny   - the number of x points and y points 
%           used to compute deflection values 
%           on a rectangular grid
% dfl     - computed array of deflection values
% cof     - coefficients in the series 
%           approximation
%
% User m functions called:  none

if nargin==0
  h=.75; np=100; ns=50; nx=40; ny=40;
end

% Generate boundary points for least square 
% approximation
z=[exp(i*linspace(0,pi/2,round(1.5*np))),...
   linspace(i,-h+i,np),...
   linspace(-h+i,-h,round(np/2))]; 
z=z(:); xb=real(z); xb=[xb;xb(end:-1:1)];
yb=imag(z); yb=[yb;-yb(end:-1:1)]; nb=length(xb);

% Form the least square equations and solve 
% for series coefficients
a=ones(length(z),ns); 
for j=2:ns, a(:,j)=a(:,j-1).*z; end
cof=real(a)\(z.*conj(z))/4;

% Generate a rectangular grid for evaluation 
% of deflections
xv=linspace(-h,1,nx); yv=linspace(-1,1,ny); 
[x,y]=meshgrid(xv,yv); z=x+i*y;

% Evaluate the deflection series on the grid 
dfl=-z.*conj(z)/4+ ...
    real(polyval(cof(ns:-1:1),z));

% Set values outside the physical region of 
% interest to zero
dfl=real(dfl).*(1-((abs(z)>=1)&(real(z)>=0)));

% Make surface and contour plots
hold off; close; surf(x,y,dfl);  
xlabel('x axis'); ylabel('y axis');
zlabel('deflection'); view(-10,30);
title('Membrane Deflection'); colormap([1 1 1]);
shg, disp(...
'Press [Enter] to show a contour plot'), pause
% print -deps membdefl;
contour(x,y,dfl,15,'k'); hold on
plot(xb,yb,'k-'); axis('equal'), hold off
xlabel('x axis'); ylabel('y axis');
title('Membrane Surface Contour Lines'), shg
% print -deps membcntr
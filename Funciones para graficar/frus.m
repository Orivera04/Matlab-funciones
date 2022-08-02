function [X,Y,Z]=frus(rb,rt,h,n,noplot)
%
% [X,Y,Z]=frus(rb,rt,h,n,noplot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes points on the surface 
% of a conical frustum which has its axis along 
% the z axis.
%
% rb,rt,h - the base radius,top radius and 
%           height
% n       - vector of two integers defining the 
%           axial and circumferential grid 
%           increments on the surface
% noplot  - parameter input when no plot is
%           desired
%
% X,Y,Z   - points on the surface
%
% User m functions called: none

if nargin==0
  rb=2; rt=1; h=3; n=[23, 35]; 
end

th=linspace(0,2*pi,n(2)+1)'-pi/n(2); 
sl=sqrt(h^2+(rb-rt)^2); s=sl+rb+rt;
m=ceil(n(1)/s*[rb,sl,rt]); 
rbot=linspace(0,rb,m(1));
rside=linspace(rb,rt,m(2));
rtop=linspace(rt,0,m(3));
r=[rbot,rside(2:end),rtop(2:end)]; 
hbot=zeros(1,m(1));
hside=linspace(0,h,m(2));
htop=h*ones(1,m(3));
H=[hbot,hside(2:end),htop(2:end)];
Z=repmat(H,n(2)+1,1); 
xy=exp(i*th)*r; X=real(xy); Y=imag(xy);
if nargin<5
  surf(X,Y,Z); title('Frustum'); xlabel('x axis')
  ylabel('y axis'), zlabel('z axis')
  grid on, colormap([1 1 1]);
  figure(gcf); 
end
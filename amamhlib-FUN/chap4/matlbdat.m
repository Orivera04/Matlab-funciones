function matlbdat        
% Example: matlbdat
% ~~~~~~~~~~~~~~~~~
% This example illustrates the use of splines
% to draw the word MATLAB.
%
% User m functions required: spcurv2d

x=[13 17 17 16 17 19 21 22 21 21 23 26
   25 28 30 32 37 32 30 32 35 37 37 38
   41 42 42 42 45 39 42 42 44 47 48 48
   47 47 48 51 53 57 53 52 53 56 57 57
   58 61 63 62 61 64 66 64 61 64 67 67];
y=[63 64 58 52 57 62 62 58 51 58 63 63
   53 52 56 61 61 61 56 51 55 61 55 52
   54 59 63 59 59 59 59 54 52 54 58 62
   58 53 51 55 60 61 60 54 51 55 61 55
   52 53 58 62 53 57 53 51 53 51 51 51];
x=x'; x=x(:); y=y'; y=y(:);
ncrnr=[17 22 26 27 28 29 30 31 36 42 47 52]; 
close; [xs,ys]=curv2d(x,y,10,ncrnr);
plot(xs,ys,'k-',x,y,'k*'), axis off;
title('A Spline Curve Drawing the Word MATLAB');
figure(gcf);
% print -deps matlbdat

%=============================================

function [X,Y]=spcrv2d(xd,yd,nseg,icrnr)
%
% [X,Y]=spcrv2d(xd,yd,nseg,icrnr)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes points (X,Y) on a
% spline curve through (xd,yd) allowing slope
% discontinuities at points with corner 
% indices in icrnr. nseg plot segments are 
% used between each successive pair of points.

if nargin<4, icrnr=[]; end
if nargin<3, nseg=10; end
zd=xd(:)+i*yd(:); n=length(zd); 
N=[1;sort(icrnr(:));n]; Z=zd(1);
if N(1)==N(2); N(1)=[]; end
if N(end)==N(end-1); N(end)=[]; end
for k=1:length(N)-1
  zk=zd(N(k):N(k+1)); sk=length(zk)-1;
  s=linspace(0,sk,1+sk*nseg)';
  Zk=spline(0:sk,zk,s); Z=[Z;Zk(2:end)];
end
X=real(Z); Y=imag(Z);
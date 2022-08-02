function [c,r]=ecentric(ri,wo,ro,nopl)
%
% [c,r]=ecentric(ri,wo,ro,nopl)
% ~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function determines the bilinear
% transformation which maps the region
% 1<=abs(z)<=r onto an eccentric annulus
% defined by 
%      abs(w)>=ri & abs(w-wo)<=ro
%
% The coefficients c in the transformation
%      w=(c(1)*z+c(2))/(c(3)*z+c(4)) 
% must be found as well as the outer radius r 
% of the annulus in the z plane.
%
% ri  - radius of inner circle abs(w)=ri
% wo  - center of outer circle abs(w-wo)=ro
% ro  - radius of outer circle
%
% c   - coefficients in the mapping function
% r   - radius of outer circle abs(z)=r 
% nopl- no plot is given if nopl is input
%
% User m functions called: gridview

if nargin==0, ri=.25; wo=-.25; ro=1; end

if wo~=0
  c1=(wo+ro)/ri; c2=(wo-ro)/ri; c3=2/(c1+c2);
  c4=(c2-c1)/(c1+c2); c5=c3-c1-c1*c4; c6=1-c1*c3;
  rt=sqrt(c5^2-4*c4*c6);
  r1=(-c5+rt)/(2*c4); r2=(-c5-rt)/(2*c4);
  r=max([r1,r2]); d=c3+c4*r; c=[ri*d;ri;1;d];
else
  c=[ri;0;0;1]; r=ro/ri;
end
if nargin > 3, return, end

% Show the region onto which a polar coordinate
% grid in the z-plane maps. 
z=linspace(1,r,20)'*exp(i*linspace(0,2*pi,81));
w=(c(1)*z+c(2))./(c(3)*z+c(4)); 
titl=['Concentric Annulus Mapped onto ', ...
      'Eccentric Annulus']; close;
gridview(real(w),imag(w),...
  'real axis','imaginary axis',titl); shg
% print -deps ecentric

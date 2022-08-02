function [Y,X,T]=strngwav(xd,yd,x,t,len,a)
%
% [Y,X,T]=strngwav(xd,yd,x,t,len,a)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function computes the dynamic response of
% a tightly stretched string released from rest
% with a piecewise linear initial deflection. The
% string ends are fixed.
%
% xd,yd - data vectors defining the initial 
%         deflection as a piecewise linear
%         function. xd values should be increasing
%         and lie between 0 and len
% x,t   - position and time vectors for which the
%         solution is evaluated
% len,a - string length and wave speed

if nargin<6, a=1; end; if nargin <5, len=1; end
xd=xd(:); yd=yd(:);  p=2*len; 

% If end values are not zero, add these points
if xd(end)~=len, xd=[xd;len]; yd=[yd;0]; end
if xd(1)~=0, xd=[0;xd]; yd=[0;yd]; end
nd=length(xd);

% Eliminate any repeated abscissa values
k=find(diff(xd)==0); tiny=len/1e6;
if length(k)>0, xd(k)=xd(k)+tiny; end

% Extend the data definition for len < x < 2*len
xd=[xd;p-xd(nd-1:-1:1)]; yd=[yd;-yd(nd-1:-1:1)];
[X,T]=meshgrid(x,t); xp=X+a*T; xm=X-a*T;
shape=size(xp); xp=xp(:); xm=xm(:); 

% Compute the general solution for a piecewise
% linear initial deflection
Y=(sign(xp).*interp1(xd,yd,rem(abs(xp),p),...
  'linear','extrap')+sign(xm).*interp1(xd,yd,...
   rem(abs(xm),p),'linear','extrap'))/2;
Y=reshape(Y,shape);
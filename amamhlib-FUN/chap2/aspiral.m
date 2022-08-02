function [R,T,N,B,kap,tau,arclen]= ...
                             aspiral(r0,k,h,t)
%                           
% [R,T,N,B,kap,tau,arclen]=aspiral(r0,k,h,t)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes geometrical properties
% of a spiral curve having the parametric 
% equation
%
%   R = [(r0+k*t)*cos(t);(r0+k*t)*sin(t);h*t)]
%
% A figure showing the curve along with the 
% osculating plane and the rectifying plane 
% at each point is also drawn.
%
% r0,k,h - parameters which define the spiral
% t      - a vector of parameter values at 
%          which the curve is evaluated from 
%          the parametric form.
% 
% R      - matrix with columns containing 
%          position vectors for points on the 
%          curve
% T,N,B  - matrices with columns containing the
%          tangent,normal,and binormal vectors
% kap    - vector of curvature values
% tau    - vector of torsion values
% arclen - value of arc length approximated as 
%          the sum of chord values between 
%          successive points
%
% User m functions called: 
%          crvprp3d, cubrange
%----------------------------------------------

if nargin==0
  k=1; h=2; r0=2*pi; t=linspace(2*pi,8*pi,101);
end

% Evaluate R, R'(t), R''(t) and R'''(t) for 
% the spiral
t=t(:)'; s=sin(t); c=cos(t); kc=k*c; ks=k*s;
rk=r0+k*t; rks=rk.*s; rkc=rk.*c; n=length(t);
R=[rkc;rks;h*t]; R1=[kc-rks;ks+rkc;h*ones(1,n)];
R2=[-2*ks-rkc;2*kc-rks;zeros(1,n)];
R3=[-3*kc+rks;-3*ks-rkc;zeros(1,n)];

% Obtain geometrical properties 
[T,N,B,kap,tau]=crvprp3d(R1,R2,R3);
arclen=sum(sqrt(sum((R(:,2:n)-R(:,1:n-1)).^2)));

% Generate points on the osculating plane and
% the rectifying plane along the curve.
w=arclen/100; Rn=R+w*N;  Rb=R+w*B; 
X=[Rn(1,:);R(1,:);Rb(1,:)];
Y=[Rn(2,:);R(2,:);Rb(2,:)];
Z=[Rn(3,:);R(3,:);Rb(3,:)];

% Draw the surface
v=cubrange([X(:),Y(:),Z(:)]); hold off; clf; close;
surf(X,Y,Z); axis(v); xlabel('x axis');
ylabel('y axis'); zlabel('z axis');
title(['Spiral Showing Osculating and ', ...
       'Rectifying Planes']); grid on; drawnow; 
figure(gcf); 
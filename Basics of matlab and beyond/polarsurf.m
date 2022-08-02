function h = polarsurf(r,theta,z,c)
%SURF   3-D polar surf surface.
%       POLARSURF(R,THETA,Z) Produces a surf plot of Z as a function of R and
%       THETA.
%
%       Example:
%       
%       [r,theta] = surfgrid(0.5:.5:10,0:pi/20:2*pi);
%       z = sin(r)./r;
%       polarsurf(r,theta,z)
%
%       See SURF for usage.

%       Andrew Knight, 1993

x = r.*cos(theta);
y = r.*sin(theta);
hh = surf(x,y,z);

if nargout==1
  h = hh;
end

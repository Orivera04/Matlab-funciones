function h = polarmesh(r,theta,z,c)
%MESH   3-D polar mesh surface.
%       POLARMESH(R,THETA,Z) Produces a mesh plot of Z as a function of R and
%       THETA.
%
%       Example:
%       
%       [r,theta] = meshgrid(0.5:.5:10,0:pi/20:2*pi);
%       z = sin(r)./r;
%       polarmesh(r,theta,z)
%
%       See MESH for usage.

%       Andrew Knight, 1993

x = r.*cos(theta);
y = r.*sin(theta);
hh = mesh(x,y,z);

if nargout==1
  h = hh;
end

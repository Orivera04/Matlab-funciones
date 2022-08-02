function h = polarsurfl(r,theta,z,c)
%SURFL   3-D polar surfl surflace.
%       POLARSURFL(R,THETA,Z) Produces a surfl plot of Z as a function of R and
%       THETA.
%
%       Example:
%       
%       [r,theta] = surflgrid(0.5:.5:10,0:pi/20:2*pi);
%       z = sin(r)./r;
%       polarsurfl(r,theta,z)
%
%       See SURFL for usage.

%       Andrew Knight, 1993

x = r.*cos(theta);
y = r.*sin(theta);
hh = surfl(x,y,z);

if nargout==1
  h = hh;
end

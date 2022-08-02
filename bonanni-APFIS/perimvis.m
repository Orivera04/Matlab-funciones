function [elon,nlat] = perimvis(x,elev,npoints)

% PERIMVIS - Calculate perimeter of visible ground region.
% [elon,nlat] = perimvis(x [, elev], npoints)
%
% Calculates a length 'npoints' sequence of (elon,nlat) pairs that 
% define the perimeter of the region on the Earth's surface visible 
% from a given position 'x' in space.  Visibility is defined by the 
% criterion that the elevation to the point 'x' from the ground is 
% greater than or equal to angle 'elev'.  This angle is given in 
% degrees, and defaults to zero if omitted from the argument list. 
% The position 'x' is specified in km with respect to Earth-centered 
% coordinates.  Units for 'elon' and 'nlat' are east longitude degrees 
% and north latitude degrees, respectively. 
%
% P.G. Bonanni
% 6/22/00


% Constants
rad2deg = 180/pi;
deg2rad = pi/180;

% Earth radius (km)
Re = 6370;

% Default elevation
elev0 = 0;  % degrees

if nargin<3
  npoints = elev;
  elev = elev0;
end

% Unity vector
ONES = ones(npoints,1);

% Check position
if norm(x)<Re
  elon = NaN * ONES;
  nlat = NaN * ONES;
  return;
end

% Convert elevation to radians
Oelev = elev*deg2rad;

% Convert 'x' to spherical coordinates
[az0,el0,r0] = cart2sph(x(1),x(2),x(3));

% Calculate the angular radius of the visibility region
Oradius = acos((Re*cos(Oelev))/r0)-Oelev;

% First assume 'x' aligned with pole.  Define 
% a parallel of latitude of the required size.
az = linspace(0,2*pi,npoints)';
el = pi/2 - Oradius*ONES;
r  = Re*ONES;

% Convert to Cartesian coordinates
[xp,yp,zp] = sph2cart(az,el,r);

% Now rotate to actual (az,el) of 'x'
ROT = rot3z(az0) * rot3y(pi/2-el0);
Xp = [xp,yp,zp] * ROT';

% Convert back to spherical coordinates
[az,el,r] = cart2sph(Xp(:,1),Xp(:,2),Xp(:,3));

% Latitudes and longitudes
elon = az * rad2deg;
nlat = el * rad2deg;

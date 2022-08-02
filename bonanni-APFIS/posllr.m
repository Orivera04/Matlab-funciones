function x = posllr(elon,nlat,range)

% POSLLR - Calculate position given longitude, latitude, and range.
% x = posllr(elon,nlat [,range])
%
% Calculates an Nx3 vector 'x' of Earth-fixed Cartesian 
% positions given Nx1 input vectors specifying longitude, 
% latitude, and range.  Longitude 'elon' is specified in 
% east degrees and latitude in north degrees.  If 'range' 
% parameter is omitted, Earth radius is assumed. 
%
% P.G. Bonanni
% 3/7/95


% Constants
rad2deg = 180/pi;
deg2rad = pi/180;

% Earth radius
Re = 6370;  % (km)

% Default range value
if nargin<3,
  range = Re*ones(size(elon));
end

% Convert to radians
az = elon * deg2rad;
el = nlat * deg2rad;

% Cartesian position vector
[x1,x2,x3] = sph2cart(az,el,range);
x = [x1,x2,x3];

function [elon,nlat] = swath(xECF,vECF,elev)

% SWATH - Calculate swath of visibility for an orbit.
% [elon,nlat] = swath(xECF,vECF [,elev])
%
% Generates a sequence of (elon,nlat) pairs that define the swath of 
% coverage for a satellite with the given orbit.  Coverage is defined 
% by the criterion that the elevation to the satellite from the ground 
% is greater than or equal to angle 'elev' in degrees.  Units for 'elon' 
% and 'nlat' are east longitude degrees and north latitude degrees, 
% respectively.  The NX3 orbital position trajectory 'xECF' and velocity 
% trajectory 'vECF' are specified in km and km/sec respectively, with 
% respect to Earth-centered-fixed coordinates.  Elevation 'elev' may be 
% scalar or Nx1 corresponding to the orbit length.  If omitted entirely, 
% zero is assumed. 
%
% P.G. Bonanni (adapted from code by Irfan Ali)
% 6/29/00


% Constants
rad2deg = 180/pi;
deg2rad = pi/180;

% Earth radius (km)
Re = 6370;

% Default elevation
if nargin < 3
  elev = 0;
end

% Orbit length
N = size(xECF,1);

% Unity vector
ONES = ones(N,1);

% Convert elevation to radians
Oelev = elev*deg2rad;

% Convert orbit to spherical coordinates
[azx,elx,rangx] = cart2sph(xECF(:,1),xECF(:,2),xECF(:,3));

% Calculate the angular radius of the visibility region
% Install NaN value anywhere range is less than Earth radius
Oradius = acos((Re*cos(Oelev))./rangx)-Oelev;
Oradius(rangx<Re) = NaN;

% Convert 'vECF' to a heading sequence, ...
% defined in radians from East toward North
[vx,vy,vz] = rotate3z(vECF(:,1),vECF(:,2),vECF(:,3),-azx);
[vx,vy,vz] = rotate3y(vx,vy,vz,elx);
thetah = atan2(vz,vy);

% First assume satellite is aligned with ECF x-axis. 
% Define two points on meridian spaced by +/- Oradius. 
x1 =  Re*cos(Oradius);  x2 =  x1;
y1 =  0;                y2 =  y1;
z1 = -Re*sin(Oradius);  z2 = -z1;

% Rotate by heading angle, then to (az,el) of xECF
% (if scalar, grows (x1,y1,z1) and (x2,y2,z2) into Nx1 sequences)
[x1,y1,z1] = rotate3x(x1,y1,z1,thetah);
[x1,y1,z1] = rotate3y(x1,y1,z1,-elx);
[x1,y1,z1] = rotate3z(x1,y1,z1,azx);
[x2,y2,z2] = rotate3x(x2,y2,z2,thetah);
[x2,y2,z2] = rotate3y(x2,y2,z2,-elx);
[x2,y2,z2] = rotate3z(x2,y2,z2,azx);

% Latitude and longitude sequences for sides of swath
[elon1,nlat1] = lonlat([x1,y1,z1]);
[elon2,nlat2] = lonlat([x2,y2,z2]);

% Flip sequence on "left side" of swath
elon2 = flipud(elon2);
nlat2 = flipud(nlat2);

% Determine maximum spacing of sub-satellite points, in degrees
delta = max(arcangle(elon1(1:end-1), nlat1(1:end-1), ...
                     elon1(2:end  ), nlat1(2:end  )  ));

% Calculate great arcs to connect swath sides.  Space points on arcs 
% no further apart than the maximum spacing of the orbit points.
npoints = 1+ceil(arcangle(elon1(end),nlat1(end),elon2(1),nlat2(1))/delta);
npoints = max(npoints,2);    % need at least 2 points on each arc
[elonA,nlatA] = greatarc(elon1(end),nlat1(end),elon2(1),nlat2(1),npoints);
[elonB,nlatB] = greatarc(elon2(end),nlat2(end),elon1(1),nlat1(1),npoints);

% Final (elon,nlat) sequence (first and last points are the same)
elon = [elon1; elonA(2:end); elon2(2:end); elonB(2:end)];
nlat = [nlat1; nlatA(2:end); nlat2(2:end); nlatB(2:end)];

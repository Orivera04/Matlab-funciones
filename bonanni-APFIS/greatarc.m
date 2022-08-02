function [elon,nlat] = greatarc(elon1,nlat1,elon2,nlat2,npoints)

% GREATARC - Great arc connecting two surface points.
% [elon,nlat] = greatarc(elon1,nlat1,elon2,nlat2,npoints)
%
% Generates longitude (deg E) and latitude (deg N) coordinates 
% representing the great arc connecting points (elon1,nlat1) 
% and (elon2,nlat2).  Parameter 'npoints' specifies the number 
% of points on the arc. 
%
% P.G. Bonanni
% 8/26/94


% Constants
deg2rad = pi/180;
rad2deg = 180/pi;

% Convert endpoints
az1 = elon1*deg2rad;
el1 = nlat1*deg2rad;
[x1,y1,z1] = sph2cart(az1,el1,1);
az2 = elon2*deg2rad;
el2 = nlat2*deg2rad;
[x2,y2,z2] = sph2cart(az2,el2,1);

% Compute normal; exit if undefined
n = cross([x1;y1;z1],[x2;y2;z2]);
if norm(n) > 0
  n = n/norm(n);
else
  % Special case: coincident endpoints
  elon = linspace(elon1,elon2,npoints)';
  nlat = linspace(nlat1,nlat2,npoints)';
  return
end

% Compute rotation matrix
Npole = [0 0 1]';
Oincl = acos(n'*Npole);
Oazth = atan2(n(2),n(1));
ROT = rot3y(-Oincl) * rot3z(-Oazth);

% Rotate [x1,y1,z1] and [x2,y2,z2] toward equator
X1 = ROT * [x1;y1;z1]; [az1,el1,rd1] = cart2sph(X1(1),X1(2),X1(3));
X2 = ROT * [x2;y2;z2]; [az2,el2,rd2] = cart2sph(X2(1),X2(2),X2(3));

% Generate equatorial segment connecting (X1,X2)
if (cross(X1,X2)'*Npole > 0)
  if az2 < az1, az2 = az2+2*pi; end
  az = linspace(az1,az2,npoints)';
else
  if az1 < az2, az1 = az1+2*pi; end
  az = linspace(az2,az1,npoints)';
end
el = zeros(size(az));
rd = ones(size(az));

% Apply inverse rotation to segment
[x,y,z] = sph2cart(az,el,rd);
Xo = [x,y,z] * ROT;
[az,el,rd] = cart2sph(Xo(:,1),Xo(:,2),Xo(:,3));

% Convert [az,el] to degrees
elon = az*rad2deg;
nlat = el*rad2deg;

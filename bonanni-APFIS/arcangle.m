function angle = arcangle(elon1,nlat1,elon2,nlat2)

% ARCANGLE - Angular distance between surface points.
% angle = arcangle(elon1,nlat1,elon2,nlat2)
%
% Calculates the angular distance between surface points (elon1,nlat1) 
% and (elon2,nlat2), along the great arc connecting the points.  Inputs 
% 'elon1' and 'elon2' are in east longitude degrees and 'nlat1' and 
% 'nlat2' are in north latitude degrees.  These may be scalars or 
% column vectors of uniform length.  Output 'angle' (scalar or vector, 
% matching the inputs) is returned in degrees. 
%
% P.G. Bonanni
% 6/29/00


% Constants
deg2rad = pi/180;
rad2deg = 180/pi;

% Make column vectors
elon1 = elon1(:);
nlat1 = nlat1(:);
elon2 = elon2(:);
nlat2 = nlat2(:);

% Convert endpoints
az1 = elon1*deg2rad;
el1 = nlat1*deg2rad;
[x1,y1,z1] = sph2cart(az1,el1,1);
az2 = elon2*deg2rad;
el2 = nlat2*deg2rad;
[x2,y2,z2] = sph2cart(az2,el2,1);

% Angular distance(s) in degrees
angle = acos(sum([x1,y1,z1].*[x2,y2,z2],2))*rad2deg;

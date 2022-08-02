function [xECF,vECF] = eci2ecf2(JT,xECI,vECI)

% ECI2ECF2 - Pos/vel ECI to ECF transformation.
% [xECF,vECF] = eci2ecf2(JT,xECI,vECI)
% xECF = eci2ecf2(JT,xECI)
%
% Converts positions x and velocities v 
% from ECI to ECF, given Julian time JT 
% in days.
%
% Parameters:
%  JT   - Nx1 vector of Julian times
%  xECI - Nx3 ECI position trajectory
%  vECI - Nx3 ECI velocity trajectory
%
% ECF outputs 'xECF' and 'vECF' are Nx3. 
% Input parameter 'vECI' may be omitted 
% if only a position transformation is 
% desired. 
%
% P.G. Bonanni
% 9/28/94


% Sidereal day (sec)
Trotation = 86164.0918;

% Right ascension of Greenwich (rad)
azG = grnwich(JT);


% POSITION

% Convert xECI to spherical coordinates
[azX,elX,rX] = cart2sph(xECI(:,1),xECI(:,2),xECI(:,3));

% Subtract Greenwich azimuth
azX = azX - azG;

% Convert back to Cartesian coordinates
[x,y,z] = sph2cart(azX,elX,rX);
xECF = [x,y,z];

% Return if no velocity supplied
if nargin<3, return, end


% VELOCITY

% Convert vECI to spherical coordinates
[azV,elV,rV] = cart2sph(vECI(:,1),vECI(:,2),vECI(:,3));

% Subtract Greenwich azimuth
azV = azV - azG;

% Convert back to Cartesian coordinates
[vx,vy,vz] = sph2cart(azV,elV,rV);
vECF = [vx,vy,vz];

% Adjust for eastward rotation rate of Earth
Erate = (rX.*cos(elX)) * (2*pi/Trotation);
vEAST = [-Erate.*sin(azX), Erate.*cos(azX), zeros(size(azX))];
vECF = vECF - vEAST;

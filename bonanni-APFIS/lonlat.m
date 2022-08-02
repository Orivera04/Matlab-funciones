function [elon,nlat,range] = lonlat(x)

% LONLAT - Calculate longitude, latitude, and range.
% [elon,nlat,range] = lonlat(x)
%
% Given an Nx3 vector 'x' of Earth-fixed Cartesian positions, 
% calculate Nx1 input vectors specifying longitude, latitude, 
% and range.  Longitude 'elon' is specified in east degrees 
% and latitude in north degrees.  Ouput 'range' has units to 
% match those of input trajectory 'x'. 
%
% P.G. Bonanni
% 6/28/00


% Constants
rad2deg = 180/pi;
deg2rad = pi/180;

% Convert Cartesion position trajectory
[az,el,range] = cart2sph(x(:,1),x(:,2),x(:,3));

% Latitude and longitude degrees
elon = az * rad2deg;
nlat = el * rad2deg;

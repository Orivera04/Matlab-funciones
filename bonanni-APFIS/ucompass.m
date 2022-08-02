function [east,north,zenith] = ucompass(elon0,nlat0)

% UCOMPASS - Calculate compass directions.
% [east,north,zenith] = ucompass(elon0,nlat0)
%
% Calculates 3x1 unit vectors 'east', 'north', and 
% 'zenith' representing the corresponding local 
% directions for a given longitude 'elon0' and 
% latitude 'nlat' expressed in the ECF frame.  
% Input units are degrees east and degrees north, 
% respectively. 
%
% P.G. Bonanni
% 3/8/95


% Constants
rad2deg = 180/pi;
deg2rad = pi/180;

% Convert units
az = elon0 * deg2rad;
el = nlat0 * deg2rad;

% Basic quantities
sin_az = sin(az);  cos_az = cos(az);
sin_el = sin(el);  cos_el = cos(el);

% Build vectors
east   = [-sin_az;          cos_az;               0];
north  = [-cos_az.*sin_el; -sin_az.*sin_el;  cos_el];
zenith = [ cos_az.*cos_el;  sin_az.*cos_el;  sin_el];

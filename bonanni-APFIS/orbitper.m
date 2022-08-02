function T = orbitper(a)

% ORBITPER - Calculate period for terrestrial orbits.
% T = orbitper(a)
%
% Calculates orbital period as a function of 
% semi-major axis for a body in Earth orbit. 
% The semi-major axis 'a' is specified in km 
% (vector input is permitted).  Orbit period 
% is returned in units of seconds. 
%
% P.G. Bonanni
% 3/7/95


% Earth gravity constant
u = 398600.607;  % km^3/s^2

% Orbit period
T = (2*pi) * a.* sqrt(a/u);

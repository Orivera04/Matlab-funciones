function [XECI,VECI] = walker(nsat,radius,inclin,nplanes,harmonic,ran0,anom0,time)

% WALKER - Generate a Walker satellite constellation.
% [XECI,VECI] = walker(nsat,radius,inclin,nplanes,harmonic,ran0,anom0,time)
%
% Generates orbit trajectories XECI = {xECI1,xECI2,...,xECInsat} and 
% corresponding velocity trajectories VECI = {vECI1,vECI2,...,vECInsat} 
% for a Walker satellite constellation orbiting the Earth at 'radius' km. 
% The Walker constellation is specified by the number of satellites 'nsat', 
% inclination angle 'inclin' (in degrees), number of planes 'nplanes', and 
% harmonic factor 'harmonic'.  Parameter 'ran0' specifies the right ascension 
% of the ascending node (in degrees), and 'anom0' the initial true anomaly 
% (in degrees), for the first satellite in the constellation.  Vector 'time' 
% (in seconds) defines the temporal spacing and duration of the trajectory 
% points.  (The initial value time(1) is referenced to 'anom0'.)
%
% P.G. Bonanni (adapted from code by Irfan Ali)
% 6/28/00


% Constants
rad2deg = 180/pi;
deg2rad = pi/180;

% Normalize time vector
t = time(:)-time(1);

% Orbital period
T = orbitper(radius);

% Inclination, in radians
thetai = inclin*deg2rad;

% Calculate orbits
for k=1:nsat
  % Right ascension of ascending node, in radians
  thetao = ran0*deg2rad + 2*pi*(k-1)/nplanes;

  % True anomaly sequence, in radians
  thetav = anom0*deg2rad + 2*pi*harmonic*(k-1)/nplanes + 2*pi*t/T;

  % Compute orbit from kepler elements
  [XECI{k},VECI{k}] = kepl2eci(radius,0,thetai,thetao,0,thetav);
end;

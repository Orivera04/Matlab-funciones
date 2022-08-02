function [elon,nlat] = dbmacover(xECF,vECF,index,dt,elev1,elev2,tmax)

% DBMACOVER - Coverage region using DBMA protocol.
% [elon,nlat] = dbmacover(xECF,vECF,index,dt,elev1,elev2,tmax)
%
% Calculates a longitude and latitude sequence (elon,nlat) defining the 
% boundary of the region within which tags are allowed to communicate 
% by the DBMA protocol.  This "region of eligibility," computed for a 
% specific instant in time, is symmetric about the sub-satellite point 
% and is given by the intersection of three larger regions:
%
%   (1) Visibility cone around the subsatellite point - the region 
%       in which the elevation to the satellite from the ground exceeds 
%       a given angle, specified by 'elev1' in degrees.  Nodes may 
%       transmit only if the satellite is above this elevation at 
%       the current time.
%   (2) Orbital swath - the region defined by a lower bound to the 
%       maximum elevation angle to the satellite, specified by 'elev2' 
%       in degrees.  Only nodes that have observed, or will observe, 
%       an elevation angle greater than this value upon closest passage 
%       of the satellite during the current orbital cycle are permitted 
%       to transmit.
%   (3) Orbital time window - the region observing closest passage of 
%       the satellite within a given time window, whose half width is 
%       specified by 'tmax' in seconds.  Only nodes that have observed 
%       (or will observe) maximum elevation within +/- this interval 
%       from the current time are permitted to transmit.
%
% Parameters:
%   xECF   - Earth-centered-fixed satellite location [x,y,z] in km
%   vECF   - Earth-centered-fixed satellite velocity [vx,vy,vz] in km/sec
%   index  - index into xECF (and vECF) defining the current time
%   dt     - time between orbit samples, in sec
%   elev1  - minimum current visibility angle, in degrees
%   elev2  - minimum visibility at closest passage, in degrees
%   tmax   - maximum time preceding/following closest passage, in sec
%
% NOTE: A negative value for 'tmax' specifies use of the full time 
% window during which the visibility and maximum elevation criteria 
% are met.
%
% Units for (elon,nlat) are east longitude degrees and north latitude 
% degrees, respectively.
%
% Irfan Ali / P.G. Bonanni
% 7/10/00


% Constants
rad2deg = 180/pi;
deg2rad = pi/180;

% Earth radius (km)
Re = 6370;

% Number of orbit points
N = size(xECF,1);

% Satellite position and velocity
xsat=xECF(index,:); r0=norm(xsat);
vsat=vECF(index,:); v0=norm(vsat);

% Calculate the angular radius of the visibility region
Oradius = acos((Re*cos(elev1*deg2rad))/r0)-elev1*deg2rad;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% REGION 1 IS OBTAINED BY COMPUTATION OF THE VISIBILITY CONTOUR SPECIFIED 
% BY 'ELEV1'.  THIS CORRESPONDS TO THE PROJECTION OF A CONE OF THE APPROPRIATE 
% RADIUS DIRECTED FROM THE SATELLITE TO THE SUB-SATELLITE SURFACE POINT. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Determine suitable number of points for visibility contour
No = 500;  % reference value corresponding to a great circle (spacing is 2*pi/No)
npoints = 1+ceil((No-1)*sin(Oradius));  % fewer points for smaller regions
%
% Calculate visibility contour (Region 1)
[elon1,nlat1] = perimvis(xsat,elev1,npoints);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% THE INTERSECTION OF REGIONS 2 AND 3 CAN BE OBTAINED DIRECTLY VIA COMPUTATION 
% OF THE SWATH DETERMINED BY 'ELEV2' SURROUNDING THE SATELLITE GROUND TRACE.  
% THE SWATH IS LIMITED IN ITS EXTENT BY INCLUDING ONLY THAT PORTION OF THE 
% SATELLITE ORBIT THAT FALLS WITHIN THE SPECIFIED TIME WINDOW. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Upper bound 'tmax' by the time needed to travel from the center 
% to the edge of the visibility cone.  This keeps the swath region 
% small, preventing failure of the intersection computation below.  
% Substitution of this bound for large 'tmax' does not impact 
% the result.
%
% Angular velocity of the satellite in its orbit (assumed circular)
omega = v0/r0;
%
% Upper bound time value
tlimit = Oradius/omega;
%
% Modify 'tmax' if necessary (Negative 'tmax' specifies consideration 
% of the full time window, and is thus treated similarly)
if tmax<0 | tmax>tlimit, tmax=tlimit; end
%
% Number of orbit points in each half of time window
nmax = round(tmax/dt);
%
% Index range for swath computation
i1 = max(index-nmax,0);
i2 = min(index+nmax,N);
irange = i1:i2;
%
% Excise relevant orbit portion
xECFo = xECF(irange,:);
vECFo = vECF(irange,:);
%
% Compute swath corresponding to elevation 'elev2' and the computed time window.
% (Note: function "swath" terminates the region using the great arcs defined by  
% the swath endpoints.  This represents Region 3 correctly for circular orbits.)
%
% Calculate swath (intersection of Regions 2 & 3)
[elon2,nlat2] = swath(xECFo,vECFo,elev2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INTERSECTION OF REGIONS CALCULATED ABOVE 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate intersection region
[elon,nlat] = intreg(elon1,nlat1,elon2,nlat2);

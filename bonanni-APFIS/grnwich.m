function az = grnwich(JT)

% GRNWICH - Greenwich right ascension.
% az = grnwich(JT)
%
% Computes the right ascension of Greenwich (rad) given 
% Julian Time vector 'JT' (days).  (Algorithm from Meeus, 
% J., Astronomical Algorithms, p. 83-85.)
%
% P.G. Bonanni (adapted from code by Craig Bennett)
% 10/31/94


% Constants
deg2rad = pi/180;
rad2deg = 180/pi;

% Time in Julian centuries from the Epoch J2000.0
Tu = (JT - 2451545.0) ./ 36525;

% Compute sun mean longitude, moon mean longitude
L  = pvdeg(280.46645   +     36000.76983 * Tu + 0.0003032 * Tu.^2);
Lp = pvdeg(218.3164591 + 481267.88134236 * Tu - 0.0013268 * Tu.^2 +   (1/538841) * Tu.^3 - (1/65194000) * Tu.^4);

% Compute longitude of ascending node of moon's mean orbit on the ecliptic
omega = pvdeg(125.04452 - 1934.136261 * Tu + 0.0020708 * Tu.^2 + (1/450000) * Tu.^3);

% Convert to radians
Lr     = L     * deg2rad;
Lpr    = Lp    * deg2rad;
omegar = omega * deg2rad;

% Compute mean obliquity of ecliptic
Eps = pvdeg(23 + 26/60 + (21.448 - 46.8150 * Tu - 0.00059 * Tu.^2 + 0.001813 * Tu.^3) / 3600);

% Nutations in longitude and obliquity (degrees)
deltapsi = (-17.20*sin(omegar) - 1.32*sin(2*Lr) - 0.23*sin(2*Lpr) + 0.21*sin(2*omegar)) / 3600;
deltaeps = (  9.20*cos(omegar) + 0.57*cos(2*Lr) + 0.10*cos(2*Lpr) - 0.09*cos(2*omegar)) / 3600;

% True obliquity of the ecliptic
Eps  = Eps + deltaeps;
Epsr = Eps * deg2rad;

% Right ascension of Greenwich (in radians)
az = 280.46061837 + 360.98564736629 * (36525*Tu) + 0.000387933 * Tu.^2 - (1/38710000) * Tu.^3;
az = az + deltapsi.*cos(Epsr);
az = pvdeg(az) * deg2rad;

function [xECI,vECI] = kepl2eci(a,e,i,o,w,v)

% KEPL2ECI - Keplerian to ECI transformation.
% [xECI,vECI] = kepl2eci(a,e,i,o,w,v)
%
% Calculates the Nx3 position trajectory 'xECI' and Nx3 velocity 
% trajectory 'vECI' in Earth-centered-inertial coordinates given 
% Keplerian orbit element Nx1 sequences (a,e,i,o,w,v).  Scalar 
% values for any of the inputs are acceptable.  Units for 'xECI' 
% and 'vECI' are km and km/sec, respectively. 
%
% The Keplerian elements are:
%   a  :  semimajor axis (km)
%   e  :  eccentricity (unitless)
%   i  :  inclination (rad)
%   o  :  right ascension of the
%           ascending node (rad)
%   w  :  argument of perigee (rad)
%   v  :  true anomaly (rad)
%
% P.G. Bonanni
% 3/10/95


% Fix inputs
a = a(:);
e = e(:);
i = i(:);
o = o(:);
w = w(:);
v = v(:);

% Earth gravity constant
u = 398600.607;  % km^3/s^2

% Basic quantities
sini = sin(i);  cosi = cos(i);
sino = sin(o);  coso = cos(o);
sinw = sin(w);  cosw = cos(w);
Px =  coso.*cosw - sino.*sinw.*cosi;
Py =  sino.*cosw + coso.*sinw.*cosi;
Pz =  sinw.*sini;
Qx = -sino.*cosw.*cosi - coso.*sinw;
Qy =  coso.*cosw.*cosi - sino.*sinw;
Qz =  cosw.*sini;

% Eccentric anomaly
v = pvrads(v);  cosv = cos(v);
E = sign(v) .* acos((e+cosv)./(1+e.*cosv));
E = pvrad(E);

% More quantities
sinE = sin(E);
cosE = cos(E);
p  = a .* (cosE - e);
q  = a .* sqrt(1 - e.^2) .* sinE;
p1 = - sqrt(u*a)           .* sinE ./ (a .* (1 - e.*cosE));
q1 =   sqrt(u*a.*(1-e.^2)) .* cosE ./ (a .* (1 - e.*cosE));

% ECI position
xECI = [Px.*p  + Qx.*q, ...
        Py.*p  + Qy.*q, ...
        Pz.*p  + Qz.*q      ];

% ECI velocity
vECI = [Px.*p1 + Qx.*q1, ...
        Py.*p1 + Qy.*q1, ...
        Pz.*p1 + Qz.*q1      ];

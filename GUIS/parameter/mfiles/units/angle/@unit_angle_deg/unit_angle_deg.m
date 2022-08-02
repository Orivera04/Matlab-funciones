function nu=unit_angle_deg

str.name='deg';
str.fullname='degree';

str.converter=unitconvertermultpow(2*pi/360,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_angle_deg',un);
function nu=unit_angle_rad

str.name='rad';
str.fullname='radian';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_angle_rad',un);
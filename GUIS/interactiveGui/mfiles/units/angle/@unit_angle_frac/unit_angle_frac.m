function nu=unit_angle_frac

str.name='fraction';
str.fullname='fraction';

str.converter=unitconvertermultpow(2*pi,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_angle_frac',un);
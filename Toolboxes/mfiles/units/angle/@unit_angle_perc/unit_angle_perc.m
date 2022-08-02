function nu=unit_angle_perc

str.name='%';
str.fullname='percent';

str.converter=unitconvertermultpow(2*pi/100,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_angle_perc',un);
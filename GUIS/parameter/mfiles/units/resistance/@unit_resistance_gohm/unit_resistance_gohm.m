function nu=unit_resistance_gohm

str.name='GOhm';
str.fullname='Giga Ohm';

str.converter=unitconvertermultpow(1000000000,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_resistance_gohm',un);
function nu=unit_resistance_ohm

str.name='Ohm';
str.fullname='Ohm';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_resistance_ohm',un);
function nu=unit_resistance_kohm

str.name='KOhm';
str.fullname='Kilo Ohm';

str.converter=unitconvertermultpow(1000,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_resistance_kohm',un);
function nu=unit_resistance_mohm

str.name='MOhm';
str.fullname='Mega Ohm';

str.converter=unitconvertermultpow(1000000,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_resistance_mohm',un);
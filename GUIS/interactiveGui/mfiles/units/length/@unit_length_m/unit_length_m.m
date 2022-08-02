function nu=unit_length_m

str.name='m';
str.fullname='meter';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_m',un);
function nu=unit_length_km

str.name='km';
str.fullname='kilometer';

str.converter=unitconvertermultpow(1000,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_km',un);
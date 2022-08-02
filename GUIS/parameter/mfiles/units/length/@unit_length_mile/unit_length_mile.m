function nu=unit_length_mile

str.name='mile';
str.fullname='statute english mile';

str.converter=unitconvertermultpow(1609.344,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_mile',un);
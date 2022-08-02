function nu=unit_capacity_picofarad

str.name='pF';
str.fullname='pico Farad';

str.converter=unitconvertermultpow(0.000000000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_capacity_picofarad',un);
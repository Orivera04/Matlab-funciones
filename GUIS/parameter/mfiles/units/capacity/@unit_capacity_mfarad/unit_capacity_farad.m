function nu=unit_capacity_mfarad

str.name='mF';
str.fullname='Milli Farad';

str.converter=unitconvertermultpow(0.001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_capacity_mfarad',un);
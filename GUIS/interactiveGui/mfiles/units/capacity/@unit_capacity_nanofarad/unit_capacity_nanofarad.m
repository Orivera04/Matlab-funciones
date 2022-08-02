function nu=unit_capacity_nanofarad

str.name='nF';
str.fullname='nano Farad';

str.converter=unitconvertermultpow(0.000000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_capacity_nanofarad',un);
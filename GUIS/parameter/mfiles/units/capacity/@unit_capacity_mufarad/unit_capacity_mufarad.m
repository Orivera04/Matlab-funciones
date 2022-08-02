function nu=unit_capacity_mufarad

str.name='µF';
str.fullname='micro Farad';

str.converter=unitconvertermultpow(0.000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_capacity_mufarad',un);
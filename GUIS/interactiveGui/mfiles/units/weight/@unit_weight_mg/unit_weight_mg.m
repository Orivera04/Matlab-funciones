function nu=unit_weight_mg()

str.name='mg';
str.fullname='milli gram';

str.converter=unitconvertermultpow(0.000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_weight_mg',un);
function nu=unit_weight_g()

str.name='g';
str.fullname='gram';

str.converter=unitconvertermultpow(0.001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_weight_g',un);
function nu=unit_weight_t()

str.name='t';
str.fullname='tons';

str.converter=unitconvertermultpow(1000,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_weight_t',un);
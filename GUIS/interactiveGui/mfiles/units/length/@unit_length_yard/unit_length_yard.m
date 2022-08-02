function nu=unit_length_yard

str.name='yard';
str.fullname='yard';

str.converter=unitconvertermultpow(0.9144,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_yard',un);
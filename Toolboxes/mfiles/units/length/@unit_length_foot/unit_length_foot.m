function nu=unit_length_foot

str.name='foot';
str.fullname='foot';

str.converter=unitconvertermultpow(0.3048,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_foot',un);
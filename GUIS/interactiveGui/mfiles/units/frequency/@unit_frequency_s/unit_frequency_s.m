function nu=unit_frequency_s()

str.name='s';
str.fullname='seconds';

str.converter=unitconvertermultpow(1,-1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_frequency_s',un);
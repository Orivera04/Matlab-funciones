function nu=unit_frequency_khz

str.name='KHz';
str.fullname='kilo Herz';

str.converter=unitconvertermultpow(1000,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_frequency_khz',un);
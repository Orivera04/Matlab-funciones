function nu=unit_frequency_hz

str.name='Hz';
str.fullname='Herz';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_frequency_hz',un);
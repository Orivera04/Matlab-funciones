function nu=unit_freq_mhz()

str.name='MHz';
str.fullname='mega Herz';

str.converter=unitconvertermultpow(1000000,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_freq_mhz',un);
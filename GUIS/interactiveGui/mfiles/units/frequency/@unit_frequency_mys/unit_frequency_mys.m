function nu=unit_frequency_mys()

str.name='µs';
str.fullname='micro seconds';

str.converter=unitconvertermultpow(0.000001,-1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_frequency_mys',un);
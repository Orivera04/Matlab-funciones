function nu=unit_frequency_ms

str.name='ms';
str.fullname='milli seconds';

str.converter=unitconvertermultpow(0.001,-1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_frequency_ms',un);
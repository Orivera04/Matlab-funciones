function nu=unit_current_mampere

str.name='mA';
str.fullname='milli Ampere';

str.converter=unitconvertermultpow(0.001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_current_mampere',un);
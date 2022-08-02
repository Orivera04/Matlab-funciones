function nu=unit_voltage_mvolt

str.name='mV';
str.fullname='milli Volt';

str.converter=unitconvertermultpow(0.001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_voltage_mvolt',un);
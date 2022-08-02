function nu=unit_voltage_volt

str.name='V';
str.fullname='Volt';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_voltage_volt',un);
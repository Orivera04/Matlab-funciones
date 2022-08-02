function nu=unit_voltage_nvolt

str.name='nV';
str.fullname='nano Volt';

str.converter=unitconvertermultpow(0.000000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_voltage_nvolt',un);
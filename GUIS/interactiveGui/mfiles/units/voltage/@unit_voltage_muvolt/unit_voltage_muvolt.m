function nu=unit_voltage_muvolt

str.name='µV';
str.fullname='micro Volt';

str.converter=unitconvertermultpow(0.000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_voltage_muvolt',un);
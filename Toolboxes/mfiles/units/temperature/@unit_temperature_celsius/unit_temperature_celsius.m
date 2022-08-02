function nu=unit_temperature_celsius()

str.name='°C';
str.fullname='degree Celsius';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_temperature_celsius',un);
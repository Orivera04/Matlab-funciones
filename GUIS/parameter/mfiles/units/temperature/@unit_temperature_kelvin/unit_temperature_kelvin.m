function nu=unit_temperature_kelvin()

str.name='K';
str.fullname='degree Kelvin';

str.converter=unitconvertermultadd(1,273.15);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_temperature_kelvin',un);
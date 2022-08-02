function nu=unit_temperature_fahrenheit()

str.name='°F';
str.fullname='degree Fahrenheit';

str.converter=unitconvertermultadd(9/5,32);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_temperature_fahrenheit',un);
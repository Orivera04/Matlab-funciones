function nu=unit_time_hours()

str.name='hours';
str.fullname='hours';

str.converter=unitconvertermultpow(60*60,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_time_hours',un);
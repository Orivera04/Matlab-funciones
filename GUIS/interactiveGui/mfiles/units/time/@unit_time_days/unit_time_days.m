function nu=unit_time_days()

str.name='days';
str.fullname='days';

str.converter=unitconvertermultpow(60*60*24,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_time_days',un);
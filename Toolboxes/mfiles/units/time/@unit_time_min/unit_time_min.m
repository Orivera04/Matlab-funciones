function nu=unit_time_min()

str.name='min';
str.fullname='minutes';

str.converter=unitconvertermultpow(60,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_time_min',un);
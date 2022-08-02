function nu=unit_time_weeks()

str.name='weeks';
str.fullname='weeks';

str.converter=unitconvertermultpow(60*60*24*7,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_time_weeks',un);
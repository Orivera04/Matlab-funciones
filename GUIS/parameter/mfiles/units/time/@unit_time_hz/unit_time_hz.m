function unitobj=unit_time_hz

str.name='hz';
str.fullname='herz';

str.converter=unitconvertermultpow(1,-1);

un=unit(str.name,str.fullname,str.converter);
unitobj=class(str,'unit_time_hz',un);




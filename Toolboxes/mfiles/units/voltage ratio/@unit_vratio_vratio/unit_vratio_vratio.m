function nu=unit_vratio_vratio

str.name='volt ratio';
str.fullname='voltage ratio';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_vratio_vratio',un);


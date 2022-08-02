function nu=unit_fratio_fratio()

str.name='frequency ratio';
str.fullname='frequency ratio';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_fratio_fratio',un);
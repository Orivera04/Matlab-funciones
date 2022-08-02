function nu=unit_length_point

str.name='point';
str.fullname='point';

str.converter=unitconvertermultpow(0.0003527778,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_point',un);
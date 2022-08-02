function nu=unit_lengthmm

str.name='mm';
str.fullname='millimeter';

str.converter=unitconvertermultpow(0.001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_mm',un);
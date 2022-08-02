function nu=unit_length_cm

str.name='cm';
str.fullname='centimeter';

str.converter=unitconvertermultpow(0.01,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_cm',un);
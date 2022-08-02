function nu=unit_conductivity_siemens

str.name='S';
str.fullname='Siemens';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_conductivity_siemens',un);
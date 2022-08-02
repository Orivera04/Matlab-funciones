function nu=unit_conductivity_msiemens

str.name='mS';
str.fullname='milli Siemens';

str.converter=unitconvertermultpow(0.001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_conductivity_msiemens',un);
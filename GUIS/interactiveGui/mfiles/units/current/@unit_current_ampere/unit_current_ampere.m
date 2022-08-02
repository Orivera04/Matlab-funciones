function nu=unit_current_ampere

str.name='A';
str.fullname='Ampere';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_current_ampere',un);
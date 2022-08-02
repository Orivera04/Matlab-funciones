function nu=unit_capacity_farad

str.name='F';
str.fullname='Farad';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_capacity_farad',un);
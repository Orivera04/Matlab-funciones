function nu=unit_mod_lin

str.name='lin';
str.fullname='linear';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_mod_lin',un);
function nu=unit_mod_perc

str.name='%';
str.fullname='percent';

str.converter=unitconvertermultpow(0.01,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_mod_perc',un);
function nu=unit_current_nanoampere

str.name='nA';
str.fullname='nano Ampere';

str.converter=unitconvertermultpow(0.000000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_current_nanoampere',un);
function nu=unit_length_parsec

str.name='parsec';
str.fullname='parsec';

str.converter=unitconvertermultpow(30856780000000,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_parsec',un);
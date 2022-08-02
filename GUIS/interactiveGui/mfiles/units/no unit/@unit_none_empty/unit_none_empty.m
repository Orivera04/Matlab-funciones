function nu=unit_none_empty

str.name='';
str.fullname='no unit';

str.converter=unitconvertermultpow(1,1);;

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_none_empty',un);
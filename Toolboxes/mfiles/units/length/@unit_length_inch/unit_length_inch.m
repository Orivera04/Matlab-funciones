function nu=unit_length_inch

str.name='inch';
str.fullname='inch';

str.converter=unitconvertermultpow(0.0254,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_length_inch',un);
function nu=unit_mod_maxtomin

str.name='Max to Min ratio';
str.fullname='Max to Min ratio';

str.converter=unitconvertermaxtomin;

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_mod_maxtomin',un);
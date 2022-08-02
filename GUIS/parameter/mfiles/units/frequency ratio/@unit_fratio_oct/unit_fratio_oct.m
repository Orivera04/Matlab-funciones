function nu=unit_fratio_oct

str.name='octaves';
str.fullname='octaves';

str.converter=unitconverteroctratio;

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_fratio_oct',un);
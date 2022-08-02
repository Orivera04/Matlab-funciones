function nu=unit_weight_mug()

str.name='µg';
str.fullname='micro gram';

str.converter=unitconvertermultpow(0.000000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_weight_mug',un);
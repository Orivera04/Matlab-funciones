function nu=unit_current_muampere

str.name='µA';
str.fullname='micro Ampere';

str.converter=unitconvertermultpow(0.000001,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_current_muampere',un);
function nu=unit_weight_kg()

str.name='kg';
str.fullname='kilogram';

str.converter=unitconvertermultpow(1,1);

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_weight_kg',un);
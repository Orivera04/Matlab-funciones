function nu=unit_mod_db

str.name='db';
str.fullname='dB';

str.converter=unitconverterlogv;

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_mod_db',un);
function nu=unit_mod_db_atten

str.name='dB atten';
str.fullname='dB atten';

str.converter=unitconverterlogvneg;

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_mod_db_atten',un);
function nu=unit_vratio_db_atten

str.name='dB power atten';
str.fullname='dB power attenuation';

str.converter=unitconverterlogvneg;

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_vratio_db_atten',un);



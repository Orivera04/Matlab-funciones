function nu=unit_vratio_db

str.name='dB power';
str.fullname='dB power';

str.converter=unitconverterlogv;

un=unit(str.name,str.fullname,str.converter);
nu=class(str,'unit_vratio_db',un);




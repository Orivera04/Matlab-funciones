function un=unit(name,fullname,converter);


str.name=name;    % the name of the unit
str.fullname=fullname; % the long name of the unit
str.converter=converter; % the converter

un=class(str,'unit');
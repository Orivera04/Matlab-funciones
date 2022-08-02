function unitobj=unit_temperature

str.name='temperature';
ub=unitbag(str.name);
ub=add(ub,unit_temperature_celsius);
ub=add(ub,unit_temperature_kelvin);
ub=add(ub,unit_temperature_fahrenheit);

unitobj= class(str,'unit_temperature',ub);

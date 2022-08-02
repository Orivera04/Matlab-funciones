function unitobj=unit_frequency

str.name='frequency';
ub=unitbag(str.name);
ub=add(ub,unit_frequency_hz);
ub=add(ub,unit_frequency_khz);
ub=add(ub,unit_frequency_s);
ub=add(ub,unit_frequency_ms);
ub=add(ub,unit_frequency_mys);


unitobj= class(str,'unit_frequency',ub);





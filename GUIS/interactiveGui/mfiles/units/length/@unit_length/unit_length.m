function unitobj=unit_length

str.name='length';
ub=unitbag(str.name);
ub=add(ub,unit_length_m);
ub=add(ub,unit_length_cm);
ub=add(ub,unit_length_mm);
ub=add(ub,unit_length_km);
ub=add(ub,unit_length_point);
ub=add(ub,unit_length_inch);
ub=add(ub,unit_length_foot);
ub=add(ub,unit_length_yard);
ub=add(ub,unit_length_mile);
ub=add(ub,unit_length_parsec);


unitobj= class(str,'unit_length',ub);





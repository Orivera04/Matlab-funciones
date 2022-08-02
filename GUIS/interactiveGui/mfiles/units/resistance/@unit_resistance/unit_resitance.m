function unitobj=unit_resistance

str.name='resistance';
ub=unitbag(str.name);
ub=add(ub,unit_resistance_ohm);
ub=add(ub,unit_resistance_kohm);
ub=add(ub,unit_resistance_mohm);
ub=add(ub,unit_resistance_gohm);

unitobj= class(str,'unit_resistance',ub);


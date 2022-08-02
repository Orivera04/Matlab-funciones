function unitobj=unit_weight


str.name='weight';
ub=unitbag(str.name);
ub=add(ub,unit_weight_t);
ub=add(ub,unit_weight_kg);
ub=add(ub,unit_weight_g);
ub=add(ub,unit_weight_mg);
ub=add(ub,unit_weight_mug);


unitobj= class(str,'unit_weight',ub);





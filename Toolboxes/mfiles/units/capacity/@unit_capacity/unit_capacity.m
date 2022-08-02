function unitobj=unit_capacity

str.name='capacity';
ub=unitbag(str.name);
ub=add(ub,unit_capacity_farad);
ub=add(ub,unit_capacity_mfarad);
ub=add(ub,unit_capacity_mufarad);
ub=add(ub,unit_capacity_nanofarad);
ub=add(ub,unit_capacity_picofarad);

unitobj= class(str,'unit_capacity',ub);





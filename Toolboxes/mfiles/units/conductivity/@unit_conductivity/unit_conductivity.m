function unitobj=unit_conductivity

str.name='conductivity';
ub=unitbag(str.name);
ub=add(ub,unit_conductivity_siemens);
ub=add(ub,unit_conductivity_msiemens);
ub=add(ub,unit_conductivity_musiemens);
ub=add(ub,unit_conductivity_nanosiemens);

unitobj= class(str,'unit_conductivity',ub);


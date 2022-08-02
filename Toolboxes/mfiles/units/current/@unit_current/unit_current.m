function unitobj=unit_current

str.name='current';
ub=unitbag(str.name);
ub=add(ub,unit_current_ampere);
ub=add(ub,unit_current_mampere);
ub=add(ub,unit_current_muampere);
ub=add(ub,unit_current_nanoampere);

unitobj= class(str,'unit_current',ub);


function unitobj=unit_mod

str.name='modulation depth';
ub=unitbag(str.name);
ub=add(ub,unit_mod_lin);
ub=add(ub,unit_mod_perc);
ub=add(ub,unit_mod_db);
ub=add(ub,unit_mod_db_atten);
ub=add(ub,unit_mod_maxtomin);



unitobj= class(str,'unit_mod',ub);





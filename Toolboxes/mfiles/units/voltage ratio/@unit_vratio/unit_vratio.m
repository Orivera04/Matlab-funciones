function unitobj=unit_vratio

str.name='angle';
ub=unitbag(str.name);
ub=add(ub,unit_vratio_vratio);
ub=add(ub,unit_vratio_db);
ub=add(ub,unit_vratio_db_atten);

unitobj= class(str,'unit_vratio',ub);





function unitobj=unit_fratio

str.name='frequency ratio';
ub=unitbag(str.name);
ub=add(ub,unit_fratio_fratio);
ub=add(ub,unit_fratio_oct);



unitobj= class(str,'unit_fratio',ub);





function unitobj=unit_none

str.name='no unit';
ub=unitbag(str.name);
ub=add(ub,unit_none_empty);

unitobj= class(str,'unit_none',ub);





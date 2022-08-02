function unitobj=unit_angle

str.name='angle';
ub=unitbag(str.name);
ub=add(ub,unit_angle_rad);
ub=add(ub,unit_angle_deg);
ub=add(ub,unit_angle_perc);
ub=add(ub,unit_angle_frac);



unitobj= class(str,'unit_angle',ub);





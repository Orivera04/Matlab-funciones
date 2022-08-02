function unitobj=unit_time

str.name='time';
ub=unitbag(str.name);
ub=add(ub,unit_time_s);
ub=add(ub,unit_time_ms);
ub=add(ub,unit_time_mys);
ub=add(ub,unit_time_hz);
ub=add(ub,unit_time_min);
ub=add(ub,unit_time_hours);
ub=add(ub,unit_time_days);
ub=add(ub,unit_time_weeks);
% ub=add(ub,unit_time_months);
% ub=add(ub,unit_time_years);


unitobj= class(str,'unit_time',ub);

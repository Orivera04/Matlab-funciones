function unitobj=unit_voltage

str.name='volatage';
ub=unitbag(str.name);
ub=add(ub,unit_voltage_volt);
ub=add(ub,unit_voltage_mvolt);
ub=add(ub,unit_voltage_muvolt);
ub=add(ub,unit_voltage_nvolt);

unitobj= class(str,'unit_voltage',ub);


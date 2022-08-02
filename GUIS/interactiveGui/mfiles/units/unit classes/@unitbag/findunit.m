function nr=findunit(ub,unitname)
% returns the number of the unitname in the unitbag ub

units=ub.units;
for i=1:length(units)
    unname=getname(units{i});
    if strcmp(unname,unitname)
        nr=i;
        return
    end
end
% if still here then there was no exact match. Take the first oen with a
% close match
for i=1:length(units)
    unname=getname(units{i});
    if ~isemtpy(strfind(unname,unitname))
        nr=i;
        return
    end
end

% if still here then error
error(sprintf('unit %s not found',unitname));
nr=-1;
return
function yes=hasunit(ub,unitname);

units=ub.units;
for i=1:length(units)
    unname=getname(units{i};
    if strcmp(unname,unitname)
        yes=1;
        return
    end
end
% if still here then there was no exact match. Take the first oen with a
% close match
for i=1:length(units)
    unname=getname(units{i};
    if ~isemtpy(strfind(unname,unitname))
        yes=1;
        return
    end
end

yes=0;

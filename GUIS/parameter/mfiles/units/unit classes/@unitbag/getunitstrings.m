function ret=getunitsstrings(uba)
un=uba.units;
for i=1:length(un)
    ret{i}=getname(un{i});
end

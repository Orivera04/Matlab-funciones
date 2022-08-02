function ret=getunitsfullstrings(uba)
un=uba.units;
for i=1:length(un)
    ret{i}=getfullname(un{i});
end

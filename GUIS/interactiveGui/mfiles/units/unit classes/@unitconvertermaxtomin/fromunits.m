function newval=fromunits(un,oldval)
if oldval~=-1
    newval=(oldval-1)/(oldval+1);
else
    newval=inf;
end
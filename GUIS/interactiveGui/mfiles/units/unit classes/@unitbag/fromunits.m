function newval=fromunit(ub,val,name);

nr_un=getcount(ub);
for i=1:nr_un
    cun=getunit(ub,i);
    if strcmp(getname(cun),name)
        con=getconverter(cun);
        newval=fromunits(con,val);
        return
    end
end

for i=1:nr_un
    cun=getunit(ub,i);
    if ~isempty(strfind(getname(cun),name))
        con=getconverter(cun);
        newval=fromunits(con,val);
        return
    end
end

error('dont know unit')
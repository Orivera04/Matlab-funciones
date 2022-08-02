function newval=tounits(un,val,name)

nr_un=getcount(un);
for i=1:nr_un
    cun=getunit(un,i);
    if strcmp(getname(cun),name)
        con=getconverter(cun);
        newval=tounits(con,val);
        return
    end
end

disp('dont know unit')
function val=tounits(un,valold)
if valold~=0
    val=(1+valold)/(1-valold);
else
    val=inf;
end
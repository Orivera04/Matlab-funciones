function td=solandoi(c)
td=0;
for i=1:(length(c)-1);
    if c(i)~=c(i+1)
        td=td+1;
    end
end
td=td;
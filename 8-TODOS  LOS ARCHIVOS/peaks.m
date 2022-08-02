%%finds peaks and throughs
%%Nagi Hatoum
%%copyright 2005
function [p,t]=peaks(s)
warning off
ds=diff(s);
ds=[ds(1);ds];%pad diff
filter=find(ds(2:end)==0)+1;%%find zeros
ds(filter)=ds(filter-1);%%replace zeros
ds=sign(ds);
ds=diff(ds);
t=find(ds>0);
p=find(ds<0);

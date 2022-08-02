function r = ramp(x)
r=x;
set=find(x<0);
r(set)=zeros(size(set));
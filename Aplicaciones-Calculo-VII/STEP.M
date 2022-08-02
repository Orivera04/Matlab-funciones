function s = step(x)
s=zeros(size(x));
set= find(x>=0);
s(set)=ones(size(set));
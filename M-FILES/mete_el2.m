function y=mete_el2(x,ind,elem)
n=numel(x);m=numel(ind);

for i=1:m
   y=mete_el(x,ind(i),elem(i));
   x=y;
end

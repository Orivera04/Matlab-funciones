function y=mete_el(x,ind,elem)
n=numel(x);
if ind==1
    y=[elem,x];
else
    x1=x([1:ind-1]);
    x2=x([ind:n]);
    y=[x1,elem,x2];
end
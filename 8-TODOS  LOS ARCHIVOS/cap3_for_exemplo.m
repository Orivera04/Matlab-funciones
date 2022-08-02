% cap3_for_exemplo ()
% gera matriz diagonal (n+1,...,n+n)
function R = cap3_for_exemplo (n)
for i=1:n
    R(i,i)=i+n;
end 

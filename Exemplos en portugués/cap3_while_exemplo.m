% cap3_while_exemplo ()
% R: multiplos de n menores que m
function R = cap3_while_exemplo (n,m)
i=1;
R=[];
while i*n < m
    R=[R i*n];
    i=i+1;
end


% cap3_error_exemplo ()
% R: multiplos de n menores que m
function R = cap3_error_exemplo (n,m)
if n>=m
    msg_erro='n deve ser menor que m';
    error(msg_erro);
end
i=1;
R=[];
while i*n < m
    R=[R i*n];
    i=i+1;
end


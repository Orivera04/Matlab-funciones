function [nerr,nerrup] = norm1(m,k,scal,err)
nerr = 0d0;
for j=1:k-1
    nerr0=0d0;
    for i=1:m
        nerr0 = nerr0 + ( err(i,j)*scal(i))^2;
    end
    nerr = max(nerr,nerr0);
end
nerrup=0d0;
for i=1:m
    nerrup = nerrup + ( err(i,k)*scal(i))^2;
end
nerr = max(nerr,nerrup);
nerr   = sqrt(nerr/(m));
nerrup = sqrt(nerrup/(m));
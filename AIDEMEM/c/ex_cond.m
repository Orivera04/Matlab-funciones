a = eye(10);        %bien conditionn�e
norm(a), cond(a), condest(a)
b = hilb(10);       %mal conditionn�e
norm(b), cond(b), condest(b)
s=condeig([1 0 1; 0 1+2*eps 1; 0 0 1-eps])
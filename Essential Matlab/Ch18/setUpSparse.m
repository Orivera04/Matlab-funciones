n = 6;                                     
P = sparse(1, 1, 1, n, n);              
P = P + sparse(n, n, 1, n, n);          
P = P + sparse(1:n-2, 2:n-1, 1/3, n, n);
P = P + sparse(3:n, 2:n-1, 2/3, n, n)   
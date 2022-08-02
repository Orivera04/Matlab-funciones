function x =  lsitrn2(A,b,numitr)
%LSITRN2 Iterative refinement for least-squares solution.
%x =  lsitrn2(A,b,numitr) refines iteratively a computed least 
%squares solution x of Ax = b. numitr is the  user supplied 
%number of iterations.  This program implements Algorithm 7.10.2
%of the book.
%input  : Matrix A, vector b, and integer numitr
%output : vector x

        [m,n] = size(A);
        xold = zeros(n,1);
        rold = zeros(m,1);
        bigm =  [eye(m,m) A;A' zeros(n,n)];
        for e1 = 1:numitr
           r1 = b - ( eye(m,m) * rold + A * xold );
           r2 = A' * rold ;
           [q,dp1] = qr(A);
           ran = rank(dp1);
           R1 = dp1(1:ran,:);
           rprime = q' * r1;
           r1prime = rprime(1:n);
           r2prime = rprime(n+1:m);
           c2prime = R1'\r2;
           c2 = R1\(r1prime - c2prime);
           c1 = q * [c2prime; r2prime];
           rold = rold + c1;
           xold = xold + c2;
        end; 
        x = xold;
        end;

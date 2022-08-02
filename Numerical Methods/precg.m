clear;
%
%  Solves  -uxx -uyy = 200+200sin(pi x)sin(pi y)
%  Uses PCG with SSOR preconditioner
%  Uses 2D arrays for the column vectors
%  Does not explicitly store the matrix
%
w = 1.5;
n = 20;
h = 1./n;
u(1:n+1,1:n+1)= 0.0;
r(1:n+1,1:n+1)= 0.0;
rhat(1:n+1,1:n+1) = 0.0;  
p(1:n+1,1:n+1)= 0.0;
q(1:n+1,1:n+1)= 0.0;
%  Define right side of PDE
for j= 2:n
   for i = 2:n
      r(i,j)= h*h*(200+200*sin(pi*(i-1)*h)*sin(pi*(j-1)*h));
   end
end
%  Execute SSOR preconditioner
rhat = ssor(r,n,w);  
p(2:n,2:n)= rhat(2:n,2:n);
err = 1.0;
m = 0;
newrho = sum(sum(rhat.*r));
%  Begin PCG iterations
while ((err>.0001)*(m<200))
   m = m+1;
%  Executes the matrix product q = Ap 
%  Does without storage of A
   for j= 2:n
      for i = 2:n
         q(i,j)=4.*p(i,j)-p(i-1,j)-p(i,j-1)-p(i+1,j)-p(i,j+1);
      end
   end
%  Executes the steepest descent segment
   rho = newrho;
   alpha = rho/sum(sum(p.*q));
   u = u + alpha*p;
   r = r - alpha*q;
%  Test for convergence 
%  Use the infinity norm of the residual
   err = max(max(abs(r(2:n,2:n))));
   reserr(m) = err;
%  Execute SSOR preconditioner
    rhat = ssor(r,n,w);  
% Find new conjugate direction
    newrho = sum(sum(rhat.*r));
    p = rhat + (newrho/rho)*p;
end
m
semilogy(reserr)
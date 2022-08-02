%  Solves  -u_xx - u_yy = 200+200sin(pi x)sin(pi y).
%  Uses PCG with SSOR or block diagonal preconditioner.
%  Uses 2D arrays for the column vectors.
%  Does not explicity store the matrix.
clear;
w = 1.6;
n = 65;
h = 1./n;
u(1:n+1,1:n+1)= 0.0;
r(1:n+1,1:n+1)= 0.0;
rhat(1:n+1,1:n+1) = 0.0;
%  Define right side of PDE
for j= 2:n
   for i = 2:n
      r(i,j)= h*h*(200+200*sin(pi*(i-1)*h)*sin(pi*(j-1)*h));
   end
end
errtol = .0001*sum(sum(r(2:n,2:n).*r(2:n,2:n)))^.5;
p(1:n+1,1:n+1)= 0.0;
q(1:n+1,1:n+1)= 0.0;
err = 1.0;
m = 0;
rho = 0.0;
%  Begin PCG iterations
while ((err > errtol)&(m < 200))
   m = m+1;
   oldrho = rho;
%   Execute SSOR preconditioner
    rhat = ssorpc(n,n,1,1,1,1,4,.25,w,r,rhat);
%   Execute block diagonal preconditioner
%   rhat = bdiagpc(n,n,1,1,1,1,4,.25,w,r,rhat); 
%   Use the following line for no preconditioner
%   rhat = r;
%  Find conjugate direction
   rho = sum(sum(r(2:n,2:n).*rhat(2:n,2:n)));
   if (m==1) 
      p = rhat;
   else
      p = rhat + (rho/oldrho)*p;
   end
%  Use the following line for steepest descent method
%   p=r;
%  Executes the matrix product q = Ap without storage of A
   for j= 2:n
      for i = 2:n
         q(i,j)=4.*p(i,j)-p(i-1,j)-p(i,j-1)-p(i+1,j)-p(i,j+1);
      end
   end
%  Executes the steepest descent segment 
   alpha = rho/sum(sum(p.*q));
   u = u + alpha*p;
   r = r - alpha*q;
%  Test for convergence via the infinity norm of the residual
   err = max(max(abs(r(2:n,2:n))));
   reserr(m) = err;
end
m
semilogy(reserr)
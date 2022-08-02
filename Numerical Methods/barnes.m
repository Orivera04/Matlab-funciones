function [xsol,basic]=barnes(A,b,c,tol)
% Barnes' method for solving a linear programming problem
% to minimise c'x subject to Ax = b. Assumes problem is non-degenerate.
%
% Example call: [xsol,basic]=barnes(A,b,c,tol)
% A is the matrix of coefficients of the constraints.
% b is the right-hand side column vector and c is the row vector of cost coefficients.
% xsol is the solution vector, basic is the index list of basic variables.
% see example on page 275.
%
x2=[ ]; x=[ ]; [m n]=size(A);
%Set up initial problem
aplus1=b-sum(A(1:m,:)')'; cplus1=1000000;
A=[A aplus1]; c=[c cplus1];
B=[ ]; n=n+1;
x0=ones(1,n)'; x=x0;
alpha = .0001; lambda=zeros(1,m)'; iter=0;
%Main step
while abs(c*x-lambda'*b)>tol
  x2=x.*x; D=diag(x); D2=diag(x2);
  AD2=A*D2;
  lambda=(AD2*A')\(AD2*c');
  dualres=c'-A'*lambda;
  normres=norm(D*dualres);
  for i=1:n
    if dualres(i)>0
      ratio(i)=normres/(x(i)*(c(i)-A(:,i)'*lambda));
    else
      ratio(i)=inf;
    end
  end
  R=min(ratio)-alpha;
  x1=x-R*D2*dualres/normres;
  x=x1; basiscount=0; B=[ ]; basic=[ ]; cb=[ ];
  for k=1:n
    if x(k)>tol
      basiscount=basiscount+1;
      basic=[basic k];
    end
  end
  %Only used if problem non-degenerate
  if basiscount==m
    for k=basic
      B=[B A(:,k)]; cb=[cb c(k)];
    end
    primalsol=b'/B'; xsol=primalsol;
    break
  end
  iter=iter+1;
end;
objective=c*x

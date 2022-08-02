function [sol,k]=newtonmve(fnewt,x0,tol,maxiter)

%Set x0 (initial estimation) as a column vector;
%Must create another function [F,J]=fnewt(x) where:
%	F is a column vector with the non-linear system
%	J is the Jacobian matrix of the system

k=1;
incr=tol+1;
A(1,:)=x0';

while incr>tol & k<=maxiter
   [F,J]=feval(fnewt,x0);
   y=J\(-F);
   x=x0+y;
   incr=norm(x-x0);
   e(k)=incr;
   k=k+1;
   A(k,:)=x';
   x0=x;
end

%Convergence Speed
	%Linear:
	cl=e(2:end)./e(1:end-1);
	%Cuadratic:
	cc=e(2:end)./e(1:end-1).^2;
   
if k>maxiter
   disp('It does not converge or more iterations are needed')
else
   sol=x;
   subplot(2,2,1),plot(A),grid,title('Iterations evolution');
   subplot(2,2,2),plot(cl),grid,title('Linear Convergence');
   subplot(2,2,3),plot(cc),grid,title('Cuadratic Convergence');
end
 
if cc<1
   disp('Cuadratic convergence');
   break
else
   if cl<1
      disp('Linear convergence, look at the graphic, if graph<1, linear convergence; if graph-->0, superlinear convergence');
   end
end

   
   

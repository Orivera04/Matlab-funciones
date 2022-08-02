%   PCG subroutine with SSOR preconditioner
      		
      function [u , mpcg]= pcgssor(an,as,aw,ae,ac,up,rhs,n)
      w = 1.6;
      u =  up;
      r      = zeros(n+1);
      rhat = zeros(n+1);
      q     = zeros(n+1);
      p     = zeros(n+1);
%   Use the previous Picard iterate as an initial guess for PCG.      
      for j = 2:n
        for i = 2:n
          r(i,j) = rhs(i,j)-(ac(i,j)*up(i,j)   ...
      	       +aw(i,j)*up(i-1,j)+ae(i,j)*up(i+1,j)  ...
      	       +as(i,j)*up(i,j-1)+an(i,j)*up(i,j+1));
        end 
      end 
      error = 1. ;
      m = 0;
      rho  = 0.0;
      while ((error>.0001)&(m<200))
        m = m+1;
        oldrho = rho;
%   Execute SSOR preconditioner.
	for  j= 2:n
	  for i = 2:n
	    rhat(i,j) = w*(r(i,j)-aw(i,j)*rhat(i-1,j)   ...
	                 -as(i,j)*rhat(i,j-1))/ac(i,j);
	  end
	end 
	for j= 2:n
	  for i = 2:n
	    rhat(i,j) =  ((2.-w)/w)*ac(i,j)*rhat(i,j);
	  end 
	end 
	for j= n:-1:2
	  for i = n:-1:2
	    rhat(i,j) = w*(rhat(i,j)-ae(i,j)*rhat(i+1,j)  ...
	                  -an(i,j)*rhat(i,j+1))/ac(i,j);
	  end 
	end 
%   Find conjugate direction.       
        rho = sum(sum(r(2:n,2:n).*rhat(2:n,2:n)));
        if (m==1)
          p = rhat;
        else
          p = rhat + (rho/oldrho)*p ;    
       end
%   Execute matrix product q = Ap.
        for j = 2:n
          for i = 2:n
            q(i,j)=ac(i,j)*p(i,j)+aw(i,j)*p(i-1,j)     ...
         	       +ae(i,j)*p(i+1,j)+as(i,j)*p(i,j-1)   ...
         	       +an(i,j)*p(i,j+1);
          end 
        end 
%   Find steepest descent.
        alpha = rho/sum(sum(p.*q));
        u = u + alpha*p;
        r = r - alpha*q;
        error = max(max(abs(r(2:n,2:n))));
      end
      mpcg = m;


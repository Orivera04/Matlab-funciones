      clear;
%  This progran solves -(K(u)ux)x - (K(u)uy)y = f.
%  K(u) is defined in the function cond(u).
%  The Picard nonlinear method is used.
%  The solve step is done in the subroutine cgssor.
%  It uses the PCG method with SSOR preconditioner.      
      maxmpic = 50;
      tol = .001;
      n = 40;
      up  = zeros(n+1);
      rhs = zeros(n+1);
      up  = zeros(n+1);
      h = 1./n;
%   Defines the right side of PDE.      
      for j = 2:n
        for i = 2:n 
      	  rhs(i,j) = h*h*200.*sin(3.14*(i-1)*h)*sin(3.14*(j-1)*h);
        end 
      end 
%   Start the Picard iteration.         
      for mpic=1:maxmpic
%   Defines the five nonzero row components in the matrix.      
        for j = 2:n
          for i = 2:n
      	    an(i,j) = -(cond(up(i,j))+cond(up(i,j+1)))*.5;
            as(i,j) = -(cond(up(i,j))+cond(up(i,j-1)))*.5;
            ae(i,j) = -(cond(up(i,j))+cond(up(i+1,j)))*.5;
            aw(i,j) = -(cond(up(i,j))+cond(up(i-1,j)))*.5;
            ac(i,j) = -(an(i,j)+as(i,j)+ae(i,j)+aw(i,j));
          end 
        end 
%        
%   The solve step is done by PCG with SSOR preconditioner.
%              
         [u , mpcg] = pcgssor(an,as,aw,ae,ac,up,rhs,n);
%        
        errpic = max(max(abs(up(2:n,2:n)-u(2:n,2:n))));
        fprintf('Picard iteration = %6.0f\n',mpic)
        fprintf('Number of PCG iterations = %6.0f\n',mpcg)
        fprintf('Picard error = %6.4e\n',errpic)
        fprintf('Max u = %6.4f\n', max(max(u)))
        up = u;
        if (errpic<tol) 
            break;
        end
        mesh(u)
        pause
      end 
      

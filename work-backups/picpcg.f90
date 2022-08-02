      program picpcg
!  This progran solves -(K(u)ux)x - (K(u)uy)y = f.
!  K(u) is defined in the function cond(u).
!  The Picard nonlinear method is used.
!  The solve step is done in the subroutine cgssor.
!  It uses the PCG method with SSOR preconditioner.      
      implicit none
      real,dimension(0:100,0:100):: up,rhs,an,as,ae,aw,ac
      real,dimension(0:100,0:100):: u
      real :: tol,h,errpic,cond
      integer :: mpic,maxmpic,n,i,j,mpcg
      maxmpic = 50
      tol = .001
      up = 0.0
      n = 20
      h = 1./n
!   Defines the right side of PDE.      
      do j = 1,n-1
        do i = 1,n-1 
      	  rhs(i,j) = h*h*200.*sin(3.14*i*h)*sin(3.14*j*h)
        end do
      end do
!   Start the Picard iteration.         
      do mpic=1,maxmpic
!   Defines the five nonzero row components in the matrix.      
        do j = 1,n-1
          do i = 1,n-1 
      	    an(i,j) = -(cond(up(i,j))+cond(up(i,j+1)))*.5
            as(i,j) = -(cond(up(i,j))+cond(up(i,j-1)))*.5
            ae(i,j) = -(cond(up(i,j))+cond(up(i+1,j)))*.5
            aw(i,j) = -(cond(up(i,j))+cond(up(i-1,j)))*.5
            ac(i,j) = -(an(i,j)+as(i,j)+ae(i,j)+aw(i,j))
          end do
        end do
!        
!   The solve step is done by PCG with SSOR preconditioner.
!              
        call cgssor(an,as,aw,ae,ac,up,rhs,u,mpcg,n)
!        
        errpic = maxval(abs(up(1:n-1,1:n-1)-u(1:n-1,1:n-1)))
        print*,"Picard iteration = ",mpic
        print*,"   Number of PCG iterations = ",mpcg
        print*,"   Picard error = ",errpic
        print*,"   Max u = ", maxval(u)              
        if (errpic<tol) exit
        up = u
      end do
      
      end program
 
!   Nonlinear thermal conductivity function.
      			
      function cond(x) result(fcond)
      implicit none
      real :: c0,c1,c2,x,fcond
        c0 = 1.
        c1 = .10
        c2 = .02
        fcond = c0*(1.+ c1*x + c2*x*x)
      end function
      
!   PCG subroutine.
      		
      subroutine cgssor(an,as,aw,ae,ac,up,rhs,u,mpcg,n)
      implicit none
      real,dimension(0:100,0:100):: p,q,r,rhat
      real,dimension(0:100,0:100),intent(in):: up,rhs,an,as,ae,aw,ac
      real,dimension(0:100,0:100),intent(out):: u
      real :: oldrho, rho,alpha,error,w
      integer :: i,j,m
      integer, intent(out):: mpcg
      integer, intent(in):: n
      w = 1.5
      u = up
      r = 0.0
      rhat = 0.0
      q = 0.0
      p = 0.0
!   Use the previous Picard iterate as an initial guess for PCG.      
      do j = 1,n-1
        do i = 1,n-1
          r(i,j)=rhs(i,j)-(ac(i,j)*up(i,j)   &
      	       +aw(i,j)*up(i-1,j)+ae(i,j)*up(i+1,j)  &
      	       +as(i,j)*up(i,j-1)+an(i,j)*up(i,j+1))
        end do
      end do
      error = 1. 
      m = 0
      rho  = 0.0
      do while ((error>.0001).and.(m<200))
        m = m+1
        oldrho = rho
!   Execute SSOR preconditioner.
	do j= 1,n-1
	  do i = 1,n-1
	    rhat(i,j) = w*(r(i,j)-aw(i,j)*rhat(i-1,j)   &
	                 -as(i,j)*rhat(i,j-1))/ac(i,j)
	  end do
	end do
	do j= 1,n-1
	  do i = 1,n-1
	    rhat(i,j) =  ((2.-w)/w)*ac(i,j)*rhat(i,j)
	  end do
	end do
	do j= n-1,1,-1
	  do i = n-1,1,-1
	    rhat(i,j) = w*(rhat(i,j)-ae(i,j)*rhat(i+1,j)  &
	                  -an(i,j)*rhat(i,j+1))/ac(i,j)
	  end do
	end do
!   Find conjugate direction.       
        rho = sum(r(1:n-1,1:n-1)*rhat(1:n-1,1:n-1))
        if (m.eq.1) then
          p = rhat
        else
          p = rhat + (rho/oldrho)*p     
        endif
!   Execute matrix product q = Ap.
        do j = 1,n-1
          do i = 1,n-1
            q(i,j)=ac(i,j)*p(i,j)+aw(i,j)*p(i-1,j)     &
         	       +ae(i,j)*p(i+1,j)+as(i,j)*p(i,j-1)  &
         	       +an(i,j)*p(i,j+1)
          end do
        end do
!   Find steepest descent.
        alpha = rho/sum(p*q)
        u = u + alpha*p
        r = r - alpha*q
        error = maxval(abs(r(1:n-1,1:n-1)))
      end do
      mpcg = m
      end subroutine


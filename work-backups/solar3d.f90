      program solar3d
!  This progran solves density csp ut -(K ux)x - (K uy)y - (K uz)z = f.
!  The thermal properties density, csp and K are constant.
!  The implicit time discretization is used.
!  The solve step is done in the subroutine cgssor3d.
!  It uses the PCG method with the SSOR preconditioner.      
      implicit none
      real,dimension(0:30,0:30,0:30):: u,up
      real :: dt,h,cond,density,csp,ac,time,ftime
      integer :: i,j,n,l,m,mtime,mpcg
      open(6,file='c:\matlab\outsolar')
      mtime = 48
      ftime = 24.
!   Define the initial condition.      
      up = 60.0
      n = 30
      h = 1./n
      cond = 0.81
      density = 119.
      csp = .21
      dt = ftime/mtime
      ac = density*csp*h*h/(cond*dt)

!   Start the time iteration.         
      do m=1,mtime
        time = m*dt
!        
!   The solve step is done by PCG with SSOR preconditioner.
!              
        call cgssor3d(ac,up,u,mpcg,n,time)
!        
        up =u
        print*,"Time = ",time
        print*,"   Number of PCG iterations = ",mpcg
        print*,"   Max u = ", maxval(u)              
      end do
      close(6)
      end program
 
!   Heat source function for top.
      			
      function usur(t) result(fusur)
      implicit none
      real :: t,fusur
        fusur = 60. + 30.*sin(t*3.14/12.)
      end function
      
!   PCG subroutine.
      		
      subroutine cgssor3d(ac,up,u,mpcg,n,time)
      implicit none
      real,dimension(0:30,0:30,0:30):: p,q,r,rhat
      real,dimension(0:30,0:30,0:30),intent(in):: up
      real,dimension(0:30,0:30,0:30),intent(out):: u
      real :: oldrho, rho,alpha,error,w,ra,usur
      real ,intent(in):: ac,time
      integer :: i,j,l,m
      integer, intent(out):: mpcg
      integer, intent(in):: n
      w = 1.5
      ra = 1./(6.+ac)
      r = 0.0
      rhat = 0.0
      q = 0.0
      p = 0.0
      r = 0.0
!   Uses previous temperature as an initial guess.      
      u = up
!   Updates the boundary condition on the top.      
      do i = 0,n
        do j = 0,n
          u(i,j,n)=usur(time)
        end do
      end do
      r(1:n-1,1:n-1,1:n-1)=ac*up(1:n-1,1:n-1,1:n-1)   &
                            -(6.0+ac)*u(1:n-1,1:n-1,1:n-1)  &
                           +u(0:n-2,1:n-1,1:n-1)+u(2:n,1:n-1,1:n-1)   &
        		   +u(1:n-1,0:n-2,1:n-1)+u(1:n-1,2:n,1:n-1)   &
        		   +u(1:n-1,1:n-1,0:n-2)+u(1:n-1,1:n-1,2:n)   
      error = 1. 
      m = 0
      rho  = 0.0
      do while ((error>.0001).and.(m<200))
        m = m+1
        oldrho = rho
!	Execute SSOR preconditioner
	do l = 1,n-1
	  do j= 1,n-1
	    do i = 1,n-1
	      rhat(i,j,l) = w*(r(i,j,l)+rhat(i-1,j,l)+rhat(i,j-1,l) &
	      			+rhat(i,j,l-1))*ra
	    end do
	  end do
	end do
	rhat(1:n-1,1:n-1,1:n-1) =  ((2.-w)/w)*(6.+ac)*rhat(1:n-1,1:n-1,1:n-1)
	do l = n-1,1,-1
	  do j= n-1,1,-1
	    do i = n-1,1,-1
	      rhat(i,j,l) = w*(rhat(i,j,l)+rhat(i+1,j,l)+rhat(i,j+1,l) &
	      			+rhat(i,j,l+1))*ra
	    end do
	  end do
	end do
!	Find conjugate direction       
        rho = sum(r(1:n-1,1:n-1,1:n-1)*rhat(1:n-1,1:n-1,1:n-1))
        if (m.eq.1) then
          p = rhat
        else
          p = rhat + (rho/oldrho)*p     
        endif
!       Execute matrix product q = Ap
        q(1:n-1,1:n-1,1:n-1)=(6.0+ac)*p(1:n-1,1:n-1,1:n-1)   &
                                -p(0:n-2,1:n-1,1:n-1)-p(2:n,1:n-1,1:n-1)  &
        			-p(1:n-1,0:n-2,1:n-1)-p(1:n-1,2:n,1:n-1)  &
        			-p(1:n-1,1:n-1,0:n-2)-p(1:n-1,1:n-1,2:n)    
!	Find steepest descent
        alpha = rho/sum(p*q)
        u = u + alpha*p
        r = r - alpha*q
        error = maxval(abs(r(1:n-1,1:n-1,1:n-1)))
      end do
      mpcg = m
      print*, m ,error,u(15,15,15),u(15,15,28)
      do l = 0,30,3
        do j = 0,30,3
          write(6,'(11f12.4)') (u(i,j,l),i=0,30,3)
        end do
      end do
      end subroutine


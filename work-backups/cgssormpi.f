      program cgssor
! This code approximates the solution of
!	-u_xx - u_yy  = f
! PCG is used with a SSOR verson of the
! Schwarz additive preconditioner.
! The sparse matrix product, dot products and updates
! are also done in parallel.    
      implicit none
      include 'mpif.h'
      real,dimension(0:1025,0:1025):: u,p,q,r,rhat
      real,dimension (0:1025) :: x,y
      real :: oldrho,ap, rho,alpha,error,dx2,w,t0,timef,tend
      real :: loc_rho,loc_ap,loc_error
      real*8:: t1,t2
      integer :: i,j,n,m
      integer :: my_rank,proc,source,dest,tag,ierr,loc_n
      integer :: status(mpi_status_size),bn,en
      integer :: maxit,sbn
      w = 1.8
      u = 0.0
      n = 1025 
      maxit = 400
      dx2 = 1./(n*n)
      do i=0,n
      	x(i) = float(i)/n
      	y(i) = x(i)
      end do
      r = 0.0
      rhat = 0.0
      q = 0.0
      p = 0.0
          
      do j = 1,n-1
        r(1:n-1,j)=200.0*dx2*(1+sin(3.14*x(1:n-1))*sin(3.14*y(j)))
      end do
      error = 1. 
      m = 0
      rho  = 0.0
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,proc,ierr) 
      loc_n = (n-1)/proc
      bn = 1+(my_rank)*loc_n
      en = bn + loc_n -1
      call mpi_barrier(mpi_comm_world,ierr)
      if (my_rank.eq.0) then
        t1 = mpi_wtime()
      end if 
      
      do while ((error>.0001).and.(m<maxit))
        m = m+1
        oldrho = rho
!	Execute Schwarz additive SSOR preconditioner.
!       This preconditioner changes with the number of processors!
	do j= bn,en
 	  do i = 1,n-1
	    rhat(i,j) = w*(r(i,j)+rhat(i-1,j)+rhat(i,j-1))*.25
	  end do
	end do
	rhat(1:n-1,bn:en) =  ((2.-w)/w)*4.*rhat(1:n-1,bn:en)
	do j= en,bn,-1
	  do i = n-1,1,-1
    	    rhat(i,j) = w*(rhat(i,j)+rhat(i+1,j)+rhat(i,j+1))*.25
	  end do
	end do       
!	rhat = r
!	Find conjugate direction.       
        loc_rho = sum(r(1:n-1,bn:en)*rhat(1:n-1,bn:en))      
        call mpi_allreduce(loc_rho,rho,1,mpi_real,mpi_sum,&
                         mpi_comm_world,ierr)
        if (m.eq.1) then
          p(1:n-1,bn:en) = rhat(1:n-1,bn:en)
        else
          p(1:n-1,bn:en) = rhat(1:n-1,bn:en) + (rho/oldrho)*p(1:n-1,bn:en)     
        endif      
!       Execute matrix product q = Ap.
!       First, exchange information between processors.        
           if (my_rank.eq.0) then
               call mpi_recv(p(0,en+1),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(p(0,en),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,ierr)
           end if
           if ((my_rank.gt.0).and.(my_rank.lt.proc-1)&
           	.and.(mod(my_rank,2).eq.1)) then
               call mpi_send(p(0,en),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,ierr)
               call mpi_recv(p(0,en+1),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(p(0,bn),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,ierr)
               call mpi_recv(p(0,bn-1),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
           end if
           if ((my_rank.gt.0).and.(my_rank.lt.proc-1)&
           	.and.(mod(my_rank,2).eq.0)) then
               call mpi_recv(p(0,bn-1),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(p(0,bn),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,ierr)
               call mpi_recv(p(0,en+1),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(p(0,en),(n+1),mpi_real,my_rank+1,50,&
                            mpi_comm_world,ierr)
           end if 
           if (my_rank.eq.proc-1) then
               call mpi_send(p(0,bn),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,ierr)
               call mpi_recv(p(0,bn-1),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
           end if 
     
           q(1:n-1,bn:en)=4.0*p(1:n-1,bn:en)-p(0:n-2,bn:en)-p(2:n,bn:en)&
         		- p(1:n-1,bn-1:en-1) - p(1:n-1,bn+1:en+1)    				
!	Find steepest descent.
        loc_ap = sum(p(1:n-1,bn:en)*q(1:n-1,bn:en))
        call mpi_allreduce(loc_ap,ap,1,mpi_real,mpi_sum,mpi_comm_world,ierr)
        alpha = rho/ap
        u(1:n-1,bn:en) = u(1:n-1,bn:en) + alpha*p(1:n-1,bn:en)
        r(1:n-1,bn:en) = r(1:n-1,bn:en) - alpha*q(1:n-1,bn:en)
        loc_error = maxval(abs(r(1:n-1,bn:en)))
        call mpi_allreduce(loc_error,error,1,mpi_real,mpi_sum,mpi_comm_world,ierr)
      end do
!     Send local solutions to processor zero.      
      if (my_rank.eq.0) then
             do source = 1,proc-1 
                    sbn = 1+(source)*loc_n
                    call mpi_recv(u(0,sbn),(n+1)*loc_n,mpi_real,source,50,&
                        mpi_comm_world,status,ierr)
             end do
         else
             call mpi_send(u(0,bn),(n+1)*loc_n,mpi_real,0,50,&
                            mpi_comm_world,ierr)
      end if
       
      if (my_rank.eq.0) then
            t2 = mpi_wtime()
            tend = t2 - t1
            print*,  'time =', tend
            print*,  'time per iteration = ', tend/m
            print*, m,error, u(512 ,512)
            print*,  'w = ',w
      end if 
      call mpi_finalize(ierr)
      end program


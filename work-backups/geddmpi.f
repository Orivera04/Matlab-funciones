      program schurdd
!  Solves algebraic system via domain decomposition and Schur complement.
!  This is for the Poisson equation with 2D space grid nx(n+1+n+1+n+1+n).
!  The solves may be done either by GE or PCG.  Use either PCG or GE for 
!  big solves, and use GE for the Schur complement solve.
      implicit none
      include 'mpif.h' 
      real, dimension(30,30):: A,Id
!  AA is only used for the GE big solve.
      real, dimension(900,900)::AA
      real, dimension(900,91,4)::AI,ZI
      real, dimension(900,91):: AII
      real, dimension(90,91) ::  Ahat
      real, dimension(90,91,4) :: WI
      real, dimension(900) :: Ones
      real, dimension(90) :: dhat,xO
      real, dimension(900,4) :: xI, dI
      real:: h
      real*8:: t1,t2
      integer:: n,i,j,loc_n,bn,en,bn1,en1      
      integer:: my_rank,p,source,dest,tag,ierr,status(mpi_status_size)
      integer :: info
!  Define the nonzero parts of the coefficient matrix with 
!  domain decomposition ordering.
        n = 30
        h = 1./(n+1)
        call matrix_def(n,A,AA,Ahat,AI,AII,WI,ZI,dhat)
!  Start MPI
        call mpi_init(ierr)
        call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
        call mpi_comm_size(mpi_comm_world,p,ierr)
        if (my_rank.eq.0) then
           t1 = mpi_wtime() 
        end if
        loc_n = 4/p
        bn = 1+my_rank*loc_n
        en = bn + loc_n -1
!  Concurrently form the Schur complement matrices.
        do i = bn,en
          call gespd(AA,AI(1:n*n,1:3*n+1,i),&
                                ZI(1:n*n,1:3*n+1,i),n*n,3*n+1)
!           call cgssor3(AI(1:n*n,1:3*n+1,i),&
!                              ZI(1:n*n,1:3*n+1,i),n*n,3*n+1,n)
           AII(1:n*n,1:3*n) = AI(1:n*n,1:3*n,i)
           WI(1:3*n,1:3*n+1,i)=matmul(transpose(AII(1:n*n,1:3*n))&
           				,ZI(1:n*n,1:3*n+1,i))
        end do
        call mpi_barrier(mpi_comm_world,ierr)
        call mpi_gather(WI(1,1,bn),3*n*(3*n+1)*(en-bn+1),mpi_real,&
                        WI,3*n*(3*n+1)*(en-bn+1),mpi_real,0,&
                        mpi_comm_world,status ,ierr)
        if (my_rank.eq.0) then  
           Ahat(1:3*n,1:3*n) = Ahat(1:3*n,1:3*n)-&
           		 WI(1:3*n,1:3*n,1)-WI(1:3*n,1:3*n,2)-&
                         WI(1:3*n,1:3*n,3)-WI(1:3*n,1:3*n,4)
           dhat(1:3*n) = dhat(1:3*n) -&
           		 WI(1:3*n,1+3*n,1)-WI(1:3*n,1+3*n,2)-&
	                 WI(1:3*n,1+3*n,3) -WI(1:3*n,1+3*n,4)
!   Solve the Schur complement system via GE
           call gespd(Ahat(1:3*n,1:3*n),dhat(1:3*n),xO(1:3*n),3*n,1)
        end if
        call mpi_bcast(xO,3*n,mpi_real,0,mpi_comm_world,ierr)
!   Concurrently solve for the big blocks.
        do i = bn,en
           dI(1:n*n,i) = AI(1:n*n,3*n+1,i)-&
           			matmul(AI(1:n*n,1:3*n,i),xO(1:3*n))
          call gespd(AA,dI(1:n*n,i),XI(1:n*n,i),n*n,1)
!          call cgssor3(dI(1:n*n,i),&
!                  xI(1:n*n,i),n*n,1,n)
        end do
        call mpi_barrier(mpi_comm_world,ierr)
        call mpi_gather(xI(1,bn),n*n*(en-bn+1),mpi_real,&
                        xI,n*n*(en-bn+1),mpi_real,0,&
                        mpi_comm_world,status ,ierr)
        call mpi_barrier(mpi_comm_world,ierr)
        if (my_rank.eq.0) then
          t2 = mpi_wtime() 
          print*, t2-t1
          print*, xO(n/2),xO(n+n/2),xO(2*n+n/2)
          print*, xI(n*n/2,1),xI(n*n/2,2),&
                  xI(n*n/2,3),xI(n*n/2,4)
        end if
        call mpi_finalize(ierr)
      end program      
! 
      Subroutine matrix_def(n,A,AA,Ahat,AI,AII,WI,ZI,dhat)
      real, dimension(30,30),intent(inout):: A
      real, dimension(30,30) :: Id
      real, dimension(900,900) ,intent(inout):: AA
      real, dimension(900,91,4),intent(inout):: AI,ZI
      real, dimension(900,91)  ,intent(inout):: AII
      real, dimension(90,91)   ,intent(inout)::  Ahat
      real, dimension(90,91,4) ,intent(inout):: WI
      real, dimension(900) :: Ones
      real, dimension(90),intent(inout) :: dhat 
      integer :: i,newi,lasti,n
      integer, intent(in) :: n
      real :: h   
      h = 1.0/(n+1)
      Id = 0.0
      Ones = 1.0
      do i=1,n
        A(i,i) = 4.
        Id(i,i) = 1.0
        if (i>1) then
           A(i,i-1) = -1.
        end if
        if (i<n) then
           A(i,i+1) = -1.
        end if
      end do
      AA = 0.
      do i = 1,n
        newi = (i-1)*n +1
        lasti = i*n
        AA(newi:lasti,newi:lasti)= A
        if (i>1) then
          AA(newi:lasti,(newi-n):(lasti-n)) = -Id
        end if
        if (i<n) then
          AA(newi:lasti,(newi+n):(lasti+n)) = -Id
        end if
      end do
      Ahat=0.
      Ahat(1:n,1:n) = A
      Ahat(n+1:2*n,n+1:2*n) = A
      Ahat(2*n+1:3*n,2*n+1:3*n) = A
      dhat(1:3*n)= 10*h*h*Ones(1:3*n)
      do i = 1,4
        ZI(1:n*n,1:3*n+1,i) = 0.
      end do
      AI(1:n*n,1:3*n+1,1) = 0.
      AI(n*n-n+1:n*n,1:n,1) = -Id(1:n,1:n)
      AI(1:n*n,1:3*n+1,2) = 0.
      AI(1:n,1:n,2) = -Id(1:n,1:n)
      AI(n*n-n+1:n*n,n+1:2*n,2) = -Id(1:n,1:n)
      AI(1:n*n,1:3*n+1,3) = 0.
      AI(1:n,n+1:2*n,3) = -Id(1:n,1:n)
      AI(n*n-n+1:n*n,2*n+1:3*n,3) = -Id(1:n,1:n)
      AI(1:n*n,1:3*n+1,4) = 0.
      AI(1:n,2*n+1:3*n,4) = -Id(1:n,1:n)
      do i = 1,4
        AI(1:n*n,3*n+1,i) = 10*Ones*h*h
      end do
      end subroutine
!      
      Subroutine gespd(a,rhs,sol,n,m)
!
!  Solves Ax = d with A a nxn SPD and d a nxm.
!
      implicit none
      real, dimension(n,n), intent(inout):: a
      real, dimension(n,m), intent(inout):: rhs
      real, dimension(n,n+m):: aa
      real, dimension(n,m) :: y
      real, dimension(n,m),intent(out)::sol
      integer ::k,i,j,l
      integer,intent(in)::n,m
      aa(1:n,1:n)= a
      aa(1:n,(n+1):n+m) = rhs
!
!  Factor A via column version and
!  write over the matrix.
!
      do k=1,n-1
        aa(k+1:n,k) = aa(k+1:n,k)/aa(k,k)
        do j=k+1,n
          do i=k+1,n
            aa(i,j) = aa(i,j) - aa(i,k)*aa(k,j)
          end do
        end do
      end do
!
!  Solve Ly = d via column version and
!  multiple right sides.
!
      do j=1,n-1
        do l =1,m
          y(j,l)=aa(j,n+l)
        end do
        do i = j+1,n
          do l=1,m
            aa(i,n+l) = aa(i,n+l) - aa(i,j)*y(j,l)
          end do
        end do
      end do
!
!  Solve Ux = y via column version and
!  multiple right sides.
!
      do j=n,2,-1
        do l = 1,m
          sol(j,l) = aa(j,n+l)/aa(j,j)
        end do
        do i = 1,j-1
          do l=1,m
            aa(i,n+l)=aa(i,n+l)-aa(i,j)*sol(j,l)
          end do
        end do
      end do
      do l=1,m
        sol(1,l) = aa(1,n+l)/a(1,1)
      end do
      end subroutine
!      
      Subroutine cgssor3(rhs,sol,n,m,nx)
!
!   Solves via PCG with SSOR preconditioner.
!   Uses sparse implementation on space grid.
!
      implicit none
      real, dimension(n,m),intent(in):: rhs
      real, dimension(n,m),intent(out)::sol
      real,dimension (0:nx+1,0:nx+1,1:m):: u,p,q,r,rhat
      real,dimension (0:nx+1) :: x,y
      real,dimension (1:m+1) :: oldrho, rho,alpha
      real :: error,dx2,w,time
      integer ::i,j,k,kk,n,nx,m,mcg
      w = 1.7
      u = 0.0
      kk = m
      r = 0.0
      rhat = 0.0
      q = 0.0
      p = 0.0
      do k = 1,kk
      do j = 1,nx
        do i = 1,nx
          r(i,j,k) = rhs(i+(j-1)*(nx),k)
        end do
      end do
      end do
      error = 1. 
      mcg = 0
      rho  = 0.0
  
      do while ((error>.0001).and.(mcg<200))
        mcg = mcg+1
        oldrho = rho
!	Execute SSOR preconditioner
        do k=1,kk
	do j= 1,nx
	  do i = 1,nx
	    rhat(i,j,k) = w*(r(i,j,k)+rhat(i-1,j,k)+rhat(i,j-1,k))*.25
	  end do
	end do
	end do
	rhat(1:nx,1:nx,1:kk) =  ((2.-w)/w)*4.*rhat(1:nx,1:nx,1:kk)
	do k = 1,kk
	do j= nx,1,-1
	  do i = nx,1,-1
	    rhat(i,j,k) = w*(rhat(i,j,k)+rhat(i+1,j,k)+rhat(i,j+1,k))*.25
	  end do
	end do
	end do
!	Find conjugate direction 
	do k = 1,kk      
        rho(k) = sum(r(1:nx,1:nx,k)*rhat(1:nx,1:nx,k))
        If (rho(k).ne.0.) then
        if (mcg.eq.1) then
          p(1:nx,1:nx,k) = rhat(1:nx,1:nx,k)
        else
          p(1:nx,1:nx,k) = rhat(1:nx,1:nx,k) + &
          			(rho(k)/oldrho(k))*p(1:nx,1:nx,k)     
        endif
!       Execute matrix product q = Ap
        q(1:nx,1:nx,k)=4.0*p(1:nx,1:nx,k)-p(0:nx-1,1:nx,k)-&
        		p(2:nx+1,1:nx,k)&
         		- p(1:nx,0:nx-1,k) - p(1:nx,2:nx+1,k)
!	Find steepest descent
        alpha(k) = rho(k)/sum(p(1:nx,1:nx,k)*q(1:nx,1:nx,k))
        u(1:nx,1:nx,k) = u(1:nx,1:nx,k) + alpha(k)*p(1:nx,1:nx,k)
        r(1:nx,1:nx,k) = r(1:nx,1:nx,k) - alpha(k)*q(1:nx,1:nx,k)
        end if
        end do
        error = maxval(abs(r(1:nx,1:nx,1:kk)))
      end do
      do k = 1,kk
      do j = 1,nx
        do i = 1,nx
          sol(i+(j-1)*(nx),k) = u(i,j,k)
        end do
      end do
      end do
!      print*, mcg ,error
      end subroutine

!      end program

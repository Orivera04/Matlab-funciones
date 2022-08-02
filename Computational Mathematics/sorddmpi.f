      program sor
!
! Solve Poisson equation via SOR.
! Uses domain decomposition to attain parallel computation.  
!    
      implicit none
      include 'mpif.h'
      real ,dimension (449,449)::u,uold
      real ,dimension (1:32)::errora
      real :: w, h, eps,pi,error,utemp
      real*8:: t1,t2
      integer :: n,maxk,maxit,it,k,i,j,jm,jp
      integer :: my_rank,p,source,dest,tag,ierr,loc_n
      integer :: status(mpi_status_size),bn,en,sbn
      n = 447
      w = 1.99
      h = 1.0/(n+1)
      u = 0.
      errora(:) = 0.0
      error = 1.
      uold = 0.
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr) 
      if (my_rank.eq.0) then
        t1 = mpi_wtime() 
      end if
      pi = 3.141592654 
      maxit = 2000
      eps = .001
      it = 0
! Begin the while loop for the parallel SOR iterations.      
      do while ((it.lt.maxit).and.(error.gt.eps))
        it = it + 1
        loc_n = (n-p+1)/p
        bn = 2+(my_rank)*(loc_n+1)
        en = bn + loc_n -1
! Do SOR for big blocks.        
        do j=bn,en
          do i =2,n+1   
            utemp = (1000.*sin((i-1)*h*pi)*sin((j-1)*h*pi)*h*h &
                    + u(i-1,j) + u(i,j-1) &
                    + u(i+1,j) + u(i,j+1))*.25
            u(i,j) = (1. -w)*u(i,j) + w*utemp
          end do
        end do
        errora(my_rank+1) = maxval(abs(u(2:n+1,bn:en)-&
                                         uold(2:n+1,bn:en)))
        uold(2:n+1,bn:en) = u(2:n+1,bn:en)
! Communicate computations to adjacent blocks.        
           if (my_rank.eq.0) then
               call mpi_recv(u(1,en+2),(n+2),mpi_real,my_rank+1,50,&
                            mpi_comm_world,status,ierr)
               call mpi_send(u(1,en+1),(n+2),mpi_real,my_rank+1,50,&
                            mpi_comm_world,ierr)
           end if
           if ((my_rank.gt.0).and.(my_rank.lt.p-1)&
           	.and.(mod(my_rank,2).eq.1)) then
               call mpi_send(u(1,en+1),(n+2),mpi_real,my_rank+1,50,&
                            mpi_comm_world,ierr)
               call mpi_recv(u(1,en+2),(n+2),mpi_real,my_rank+1,50,&
                            mpi_comm_world,status,ierr)
               call mpi_send(u(1,bn),(n+2),mpi_real,my_rank-1,50,&
                            mpi_comm_world,ierr)    
               call mpi_recv(u(1,bn-1),(n+2),mpi_real,my_rank-1,50,&
                            mpi_comm_world,status,ierr)
           end if
           if ((my_rank.gt.0).and.(my_rank.lt.p-1)&
           	.and.(mod(my_rank,2).eq.0)) then
               call mpi_recv(u(1,bn-1),(n+2),mpi_real,my_rank-1,50,&
                            mpi_comm_world,status,ierr)   
               call mpi_send(u(1,bn),(n+2),mpi_real,my_rank-1,50,&
                            mpi_comm_world,ierr)
               call mpi_recv(u(1,en+2),(n+2),mpi_real,my_rank+1,50,&
                            mpi_comm_world,status,ierr)
               call mpi_send(u(1,en+1),(n+2),mpi_real,my_rank+1,50,&
                            mpi_comm_world,ierr) 
           end if  
           if (my_rank.eq.p-1) then
               call mpi_send(u(1,bn),(n+2),mpi_real,my_rank-1,50,&
                            mpi_comm_world,ierr)
               call mpi_recv(u(1,bn-1),(n+2),mpi_real,my_rank-1,50,&
                            mpi_comm_world,status,ierr)
           end if
        if  (my_rank.lt.p-1) then
          j = en +1
! Do SOR for smaller interface blocks.          
          do i=2,n+1
            utemp = (1000.*sin((i-1)*h*pi)*sin((j-1)*h*pi)*h*h &
                    + u(i-1,j) + u(i,j-1)& 
                    + u(i+1,j) + u(i,j+1))*.25
            u(i,j) = (1. -w)*u(i,j) + w*utemp
          end do
          errora(my_rank+1) = max1(errora(my_rank+1),&
                              maxval(abs(u(2:n+1,j)-uold(2:n+1,j))))
          uold(2:n+1,j) = u(2:n+1,j)
        endif
! Communicate computations to adjacent blocks.             
        if (my_rank.lt.p-1) then
           call mpi_send(u(1,en+1),(n+2),mpi_real,my_rank+1,50,&
                                    mpi_comm_world,ierr)
        end if
        if (my_rank.gt.0) then 
           call mpi_recv(u(1,bn-1),(n+2),mpi_real,my_rank-1,50,&
                                    mpi_comm_world,status,ierr)
        end if
! Gather local errors to processor 0.        
        call mpi_gather(errora(my_rank+1),1,mpi_real,&
                                    errora,1,mpi_real,0,&
                                    mpi_comm_world,ierr)

        call mpi_barrier(mpi_comm_world,ierr)
! On processor 0 compute the maximum of the local errors.        
        if (my_rank.eq.0) then
           error = maxval(errora(1:p))
        end if
! Send this global error to all processors so that 
! they will exit the while loop when the global error
! test is satisfied.        
        call mpi_bcast(error,1,mpi_real,0,&
                                  mpi_comm_world,ierr)
      end do
! End of the while loop.      
! Gather the computations to processor 0      
      call mpi_gather(u(1,2+my_rank*(loc_n+1)),&
      				(n+2)*(loc_n+1),mpi_real,&
                    	      u,(n+2)*(loc_n+1),mpi_real,0,&
                              mpi_comm_world,ierr)
      if (my_rank.eq.0) then
        t2 = mpi_wtime() 
        print*, 'sor iterations = ',it
        print*, 'time = ', t2-t1 
        print*, 'error = ', error
        print*, 'center value of solution = ',u(225,225)
      end if
      call mpi_finalize(ierr)    
      end

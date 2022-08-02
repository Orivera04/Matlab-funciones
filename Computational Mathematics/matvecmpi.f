      program matvec 
      implicit none
      include 'mpif.h'
      real,dimension(1:1024,1:4096):: a
      real,dimension(1:1024)::prod,prodt 
      real,dimension(1:4096)::x
      real:: mflops
      real*8:: t1,t2 
      integer::  my_rank,p,n,source,dest,tag,ierr,loc_m
      integer:: i,status(mpi_status_size),bn,en,j,it,m
      data n,dest,tag/1024,0,50/
      m = 4*n
      a= 1.0
      prod = 0.0
      x = 3.0
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
      loc_m = m/p
      bn = 1+(my_rank)*loc_m
      en  = bn + loc_m  - 1
      if (my_rank.eq.0) then
        t1 = mpi_wtime() 
      end if
      do it = 1,1000
!      call mpi_bcast(a(1,bn),n*(en-bn+1),mpi_real,0,mpi_comm_world,ierr)
!      call mpi_bcast(prod(1),n,mpi_real,0,mpi_comm_world,ierr)
!      call mpi_bcast(x(bn),(en-bn+1),mpi_real,0,mpi_comm_world,ierr)
!        call sgemv('N',n,loc_m,1.0,a(1,bn),n,x(bn),1,1.0,prod,1)
        do j = bn,en
          do i = 1,n
            prod(i) = prod(i) + a(i,j)*x(j)
          end do 
        end do 
      call mpi_barrier(mpi_comm_world,ierr)
     call mpi_reduce(prod(1),prodt(1),n,mpi_real,mpi_sum,0,mpi_comm_world,ierr)
      end do
      if (my_rank.eq.0) then
        t2 = mpi_wtime()
      end if
      if (my_rank.eq.0) then
        mflops =float(2*n*m)*.001/(t2-t1)
        print*,prodt(n/3)
        print*,prodt(n/2)
        print*,prodt(n/4)
        print*,t2-t1,mflops
      end if
      call mpi_finalize(ierr)
      end program  
 


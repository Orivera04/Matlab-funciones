      program mm 
      implicit none
      include 'mpif.h'
      real,dimension(1:512,1:256):: a,b,prodt
      real,dimension(1:256,1:256):: c
      real*8:: t1,t2
      real:: mflops
      integer:: l, my_rank,p,n,source,dest,tag,ierr,loc_n
      integer:: i,status(mpi_status_size),bn,en,j,k,it,m
      data n,dest,tag/256,0,50/
      m = 2*n
      a = 0.0
      b = 2.0
      c = 3.0
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
      loc_n = n/p
      bn = 1+(my_rank)*loc_n
      en  = bn + loc_n  - 1
      call mpi_barrier(mpi_comm_world,ierr)
      if (my_rank.eq.0) then
        t1 = mpi_wtime() 
      end if
      do it = 1,10
!       call sgemm('N','N',m,loc_n,n,1.0,b(1,1),m,c(1,bn),n,1.0,a(1,bn),m)
         do j = bn,en 
           do k = 1,n 
             do i = 1,m
                a(i,j)  = a(i,j) + b(i,k)*c(k,j)
             end do
           end do
         end do
      call mpi_barrier(mpi_comm_world,ierr)
      call mpi_gather(a(1,bn),m*loc_n,mpi_real,prodt,m*loc_n,mpi_real,  &
             0,mpi_comm_world,ierr)
      end do
      if (my_rank.eq.0) then
        t2= mpi_wtime()       
      end if
      if (my_rank.eq.0) then
        mflops = 2*n*n*m*0.00001/(t2-t1)
        print*,prodt(1,1),prodt(1,2),prodt(1,3),prodt(1,4)
        print*,prodt(2,1),prodt(2,2),prodt(2,3),prodt(2,4)
        print*,prodt(3,1),prodt(3,2),prodt(3,3),prodt(3,4)
        print*,prodt(4,1),prodt(4,2),prodt(4,3),prodt(4,4)
        print*,prodt(5,1),prodt(5,2),prodt(5,3),prodt(5,4)
        print*,prodt(6,1),prodt(6,2),prodt(6,3),prodt(6,4)
        print*,prodt(7,1),prodt(7,2),prodt(7,3),prodt(7,4)
        print*,prodt(8,1),prodt(8,2),prodt(8,3),prodt(8,4)
        print*,t2-t1,mflops
      end if
      call mpi_finalize(ierr)
      end program  


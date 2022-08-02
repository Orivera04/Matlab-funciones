      program dot2mpi
! Illustrates dot product via mpi_reduce.      
      implicit none
      include 'mpif.h'
      real:: loc_dot,dot
      real, dimension(0:31):: a,b, loc_dots
      integer::  my_rank,p,n,source,dest,tag,ierr,loc_n
      integer:: i,status(mpi_status_size),en,bn
      data n,dest,tag/8,0,50/
      do i = 1,n
          a(i) = i
          b(i) = i+1
      end do
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
! Each processor computes a local dot product. 
      loc_n = n/p
      bn = 1+(my_rank)*loc_n
      en = bn + loc_n-1
      print*,'my_rank =',my_rank, 'loc_n = ',loc_n
      print*,'my_rank =',my_rank, 'bn = ',bn
      print*,'my_rank =',my_rank, 'en = ',en
      loc_dot = 0.0
      do i = bn,en
            loc_dot = loc_dot + a(i)*b(i)
      end do
      print*,'my_rank =',my_rank, 'loc_dot = ',loc_dot
! mpi_reduce is used to sum all the local dot products 
! to dot on processor 0.      
      call mpi_reduce(loc_dot,dot,1,mpi_real,mpi_sum,0,&
                        mpi_comm_world,status,ierr)
      if (my_rank.eq.0) then
        print*, 'dot product = ',dot
      end if 
      call mpi_finalize(ierr)
      end program dot2mpi


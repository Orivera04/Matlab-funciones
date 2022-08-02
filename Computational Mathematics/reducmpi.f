      program reducmpi
! Illustrates mpi_reduce.
      implicit none
      include 'mpif.h'
      real:: a,b,h,loc_a,loc_b,total,sum,prod
      real, dimension(0:31):: a_list
      integer::  my_rank,p,n,source,dest,tag,ierr,loc_n
      integer:: i,status(mpi_status_size)
      data a,b,n,dest,tag/0.0,100.0,1024,0,50/
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
! Each processor has a unique loc_n, loc_a and loc_b.
      h = (b-a)/n
      loc_n = n/p
      loc_a = a+my_rank*loc_n*h
      loc_b = loc_a + loc_n*h
      print*,'my_rank =',my_rank, 'loc_a = ',loc_a
      print*,'my_rank =',my_rank, 'loc_b = ',loc_b
      print*,'my_rank =',my_rank, 'loc_n = ',loc_n
! mpi_reduce is used to compute the sum of all loc_b 
! to sum on processor 0.      
      call mpi_reduce(loc_b,sum,1,mpi_real,mpi_sum,0,&
                        mpi_comm_world,status,ierr)
! mpi_reduce is used to compute the product of all loc_b 
! to prod on processor 0.                        
      call mpi_reduce(loc_b,prod,1,mpi_real,mpi_prod,0,&
                        mpi_comm_world,status,ierr)
      if (my_rank.eq.0) then
        print*, 'sum = ',sum
        print*, 'product = ',prod
      end if
      call mpi_finalize(ierr)
      end program reducmpi


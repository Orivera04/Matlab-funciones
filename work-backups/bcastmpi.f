      program bcastmpi
! Illustrates mpi_bcast.
      implicit none
      include 'mpif.h'
      real:: a,b,new_b
      integer::  my_rank,p,n,source,dest,tag,ierr,loc_n
      integer:: i,status(mpi_status_size)
      data n,dest,tag/1024,0,50/
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
      if (my_rank.eq.0) then
        a = .0
        b = 100.
      end if
! Each processor attempts to print a and b.     
      print*,'my_rank =',my_rank, 'a = ',a
      print*,'my_rank =',my_rank, 'b = ',b
! Processor 0 broadcasts a and b to the other processors.
! The mpi_bcast is issued by all processors.
      call mpi_bcast(a,1,mpi_real,0,&
                        mpi_comm_world,ierr)
      call mpi_bcast(b,1,mpi_real,0,&
                        mpi_comm_world,ierr)
      call mpi_barrier(mpi_comm_world,ierr)
! Each processor prints a and b. 
      print*,'my_rank =',my_rank, 'a = ',a
      print*,'my_rank =',my_rank, 'b = ',b
! Processor 0 broadcasts b to the other processors and
! stores it in new_b.
      if (my_rank.eq.0) then
        call mpi_bcast(b,1,mpi_real,0,&
                        mpi_comm_world,ierr)
      else
        call mpi_bcast(new_b,1,mpi_real,0,&
                        mpi_comm_world,ierr)
      end if
      print*,'my_rank =',my_rank, 'new_b = ',new_b       
      call mpi_finalize(ierr)
      end program bcastmpi


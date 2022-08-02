      program countmpi
! Illustrates count for arrays.      
      implicit none
      include 'mpif.h'
      real, dimension(1:4):: a
      integer, dimension(1:2,1:3):: b
      integer::  my_rank,p,n,source,dest,tag,ierr,loc_n
      integer:: i,j,status(mpi_status_size)
      data n,dest,tag/4,0,50/
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
! Define the arrays.      
      if (my_rank.eq.0) then
        a(1) = 1.
        a(2) = exp(1.)
        a(3) = 4*atan(1.)
        a(4) = 186000.
        do j = 1,3
          do i = 1,2
            b(i,j) = i+j
          end do
        end do
      end if
! Each processor attempts to print the array.     
      print*,'my_rank =',my_rank, 'a = ',a
      call mpi_barrier(mpi_comm_world,ierr)
! The arrays are broadcast via count equal to four.      
      call mpi_bcast(a,4,mpi_real,0,&
                        mpi_comm_world,ierr)
      call mpi_bcast(b,4,mpi_int,0,&
                        mpi_comm_world,ierr)                  
! Each processor prints the arrays.                        
      print*,'my_rank =',my_rank, 'a = ',a
      print*,'my_rank =',my_rank, 'b = ',b              
      call mpi_finalize(ierr)
      end program countmpi


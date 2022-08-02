      program scatmpi
      implicit none
      include 'mpif.h'
      real, dimension(0:7):: a_list,a_loc
      integer::  my_rank,p,n,source,dest,tag,ierr,loc_n
      integer:: i,status(mpi_status_size)
      data n,dest,tag/1024,0,50/
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
      if (my_rank.eq.0) then
        do i = 0,7
        	a_list(i) = i
        end do
      end if
      call mpi_scatter(a_list,2,mpi_real,a_loc,2,mpi_real,0,&
                        mpi_comm_world,status,ierr)
      print*, 'my_rank =',my_rank,'a_loc = ', a_loc
      call mpi_finalize(ierr)
      end program scatmpi


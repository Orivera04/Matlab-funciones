      program gathmpi
      implicit none
      include 'mpif.h'
      real:: a,b,h,loc_a,loc_b,total
      real, dimension(0:31):: a_list
      integer::  my_rank,p,n,source,dest,tag,ierr,loc_n
      integer:: i,status(mpi_status_size)
      data a,b,n,dest,tag/0.0,100.0,1024,0,50/
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
      h = (b-a)/n
      loc_n = n/p
      loc_a = a+my_rank*loc_n*h
      loc_b = loc_a + loc_n*h
        print*,'my_rank =',my_rank, 'loc_a = ',loc_a
        print*,'my_rank =',my_rank, 'loc_b = ',loc_b
        print*,'my_rank =',my_rank, 'loc_n = ',loc_n
      call mpi_gather(loc_a,1,mpi_real,a_list,1,mpi_real,0,&
                        mpi_comm_world,status,ierr)
      call mpi_barrier(mpi_comm_world,ierr)
      if (my_rank.eq.0) then
        do i = 0,p-1
          print*, 'a_list(',i,') = ',a_list(i)
        end do
      end if
      call mpi_finalize(ierr)
      end program gathmpi


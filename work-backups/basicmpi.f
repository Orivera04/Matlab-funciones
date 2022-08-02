      program basicmpi
! Illustrates the basic eight mpi commands.
      implicit none
! Includes the mpi Fortran library.
      include 'mpif.h'
      real:: a,b,h,loc_a,loc_b,total
      real, dimension(0:31):: a_list
      integer::  my_rank,p,n,source,dest,tag,ierr,loc_n
      integer:: i,status(mpi_status_size)
! Every processor gets values for a,b and n.      
      data a,b,n,dest,tag/0.0,100.0,1024,0,50/
! Initializes mpi, gets the rank of the processor, my_rank,
! and number of processors, p.     
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
      print*,'my_rank =',my_rank, 'a = ',a
      print*,'my_rank =',my_rank, 'b = ',b
      print*,'my_rank =',my_rank, 'n = ',n
      h = (b-a)/n
! Each processor has unique value of loc_n, loc_a and loc_b.      
      loc_n = n/p
      loc_a = a+my_rank*loc_n*h
      loc_b = loc_a + loc_n*h
! Each processor prints its loc_n, loc_a and loc_b.      
      print*,'my_rank =',my_rank, 'loc_a = ',loc_a
      print*,'my_rank =',my_rank, 'loc_b = ',loc_b
      print*,'my_rank =',my_rank, 'loc_n = ',loc_n
! Processors p not equal 0 sends a_loc to an array, a_list,
! in processor 0, and processor 0 recieves these.      
      if (my_rank.eq.0) then
        a_list(0) = loc_a
        do source = 1,p-1 
          call mpi_recv(a_list(source),1,mpi_real,source &
                          ,50,mpi_comm_world,status,ierr)
        end do    
      else
        call mpi_send(loc_a,1,mpi_real,0,50,&
                            mpi_comm_world,ierr)
      end if 
      call mpi_barrier(mpi_comm_world,ierr)
! Processor 0 prints the list of all loc_a.     
      if (my_rank.eq.0) then
        do i = 0,p-1
          print*, 'a_list(',i,') = ',a_list(i)
        end do
      end if
! mpi is terminated.      
      call mpi_finalize(ierr)
      end program basicmpi


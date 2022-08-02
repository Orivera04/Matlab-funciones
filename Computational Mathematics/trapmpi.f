      program trapezoid
! This illustrates how the basic mpi commands
! can be used to do parallel numerical integration 
! by partitioning the summation.
      implicit none
! Includes the mpi Fortran library.
      include 'mpif.h'
      real:: a,b,h,loc_a,loc_b,integral,total,x
      real*8:: t1,t2 
      integer::  my_rank,p,n,source,dest,tag,ierr,loc_n
      integer:: i,status(mpi_status_size)
! Every processor gets values for a,b and n. 
      data a,b,n,dest,tag/0.0,100.0,10240000,0,50/
! Initializes mpi, gets the rank of the processor, my_rank,
! and number of processors, p. 
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
      if (my_rank.eq.0) then
        t1 = mpi_wtime() 
      end if
      h = (b-a)/n
! Each processor has unique value of loc_n, loc_a and loc_b.
      loc_n = n/p
      loc_a = a+my_rank*loc_n*h
      loc_b = loc_a + loc_n*h
! Each processor does part of the integration.
! The trapezoid rule is used.
      integral = (f(loc_a) + f(loc_b))*.5
      x = loc_a
      do i = 1,loc_n-1
         x=x+h
         integral = integral + f(x)
      end do
      integral = integral*h
! The mpi subroutine mpi_reduce() is used to communicate
! the partial integrations, integral, and then sum 
! these to get the total numerical approximation, total.
      call mpi_reduce(integral,total,1,mpi_real,mpi_sum,0&
      			 ,mpi_comm_world,ierr)
      call mpi_barrier(mpi_comm_world,ierr)
      if (my_rank.eq.0) then
        t2 = mpi_wtime() 
      end if
! Processor 0 prints the n,a,b,total 
! and time for computation and communication. 
      if (my_rank.eq.0) then
        print*,n
        print*,a
        print*,b
        print*,total
        print*,t2-t1
      end if
! mpi is terminated. 
      call mpi_finalize(ierr)
      contains
! This is the function to be integrated.
      real function f(x)
          implicit none
          real x
          f = x*x
      end function
      end program trapezoid


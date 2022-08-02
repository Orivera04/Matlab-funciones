      program dertypempi
! Illustrates a derived type.     
      implicit none
      include 'mpif.h'
      real:: a,b
      integer::c,d
      integer::data_mpi_type
      integer::ierr
      integer, dimension(1:4)::blocks
      integer, dimension(1:4)::displacements
      integer, dimension(1:4)::addresses
      integer, dimension(1:4)::typelist
      integer::  my_rank,p,n,source,dest,tag,loc_n
      integer:: i,status(mpi_status_size)
      data n,dest,tag/4,0,50/
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
      if (my_rank.eq.0) then
        a = exp(1.)
        b = 4*atan(1.)
        c = 1
        d = 186000
      end if    
! Define the new derived type, data_mpi_type.        
        typelist(1) = mpi_real
        typelist(2) = mpi_real
        typelist(3) = mpi_integer
        typelist(4) = mpi_integer
        blocks(1) = 1
        blocks(2) = 1
        blocks(3) = 1
        blocks(4) = 1
        call mpi_address(a,addresses(1),ierr)
        call mpi_address(b,addresses(2),ierr)
        call mpi_address(c,addresses(3),ierr)
        call mpi_address(d,addresses(4),ierr)
        displacements(1) = addresses(1) - addresses(1)
        displacements(2) = addresses(2) - addresses(1)
        displacements(3) = addresses(3) - addresses(1)
        displacements(4) = addresses(4) - addresses(1)
        call mpi_type_struct(4,blocks,displacements,&
                          typelist,data_mpi_type,ierr)
        call mpi_type_commit(data_mpi_type,ierr)
! Before the broadcast of the new type data_mpi_type 
! try to print the data.       
      print*,'my_rank =',my_rank, 'a = ',a
      print*,'my_rank =',my_rank, 'b = ',b
      print*,'my_rank =',my_rank, 'c = ',c
      print*,'my_rank =',my_rank, 'd = ',d
      call mpi_barrier(mpi_comm_world,ierr)
! Broadcast data_mpi_type.      
      call mpi_bcast(a,1,data_mpi_type,0,&
                        mpi_comm_world,ierr)
! Each processor prints the data.                        
      print*,'my_rank =',my_rank, 'a = ',a
      print*,'my_rank =',my_rank, 'b = ',b
      print*,'my_rank =',my_rank, 'c = ',c
      print*,'my_rank =',my_rank, 'd = ',d           
      call mpi_finalize(ierr)
      end program dertypempi

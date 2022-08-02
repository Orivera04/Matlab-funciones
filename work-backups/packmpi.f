      program packmpi
! Illustrates mpi_pack and mpi_unpack.     
      implicit none
      include 'mpif.h'
      real:: a,b
      integer::c,d,location
      integer::ierr
      character, dimension(1:100)::numbers
      integer::  my_rank,p,n,source,dest,tag,loc_n
      integer:: i,status(mpi_status_size)
      data n,dest,tag/4,0,50/
      call mpi_init(ierr)
      call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
      call mpi_comm_size(mpi_comm_world,p,ierr)
! Processor 0 packs and broadcasts the four number.   
      if (my_rank.eq.0) then
        a = exp(1.)
        b = 4*atan(1.)
        c = 1
        d = 186000
        location = 0
        call mpi_pack(a,1,mpi_real,numbers,100,location,&
                         mpi_comm_world, ierr)
        call mpi_pack(b,1,mpi_real,numbers,100,location,&
                         mpi_comm_world, ierr)
        call mpi_pack(c,1,mpi_integer,numbers,100,location,&
                         mpi_comm_world, ierr)
        call mpi_pack(d,1,mpi_integer,numbers,100,location,&
                         mpi_comm_world, ierr)
        call mpi_bcast(numbers,100,mpi_packed,0,&
                        mpi_comm_world,ierr)
      else
        call mpi_bcast(numbers,100,mpi_packed,0,&
                        mpi_comm_world,ierr)
! Each processor unpacks the numbers.                       
        location = 0
        call mpi_unpack(numbers,100,location,a,1,mpi_real,&
                         mpi_comm_world, ierr)
        call mpi_unpack(numbers,100,location,b,1,mpi_real,&
                         mpi_comm_world, ierr)
        call mpi_unpack(numbers,100,location,c,1,mpi_integer,&
                         mpi_comm_world, ierr)
        call mpi_unpack(numbers,100,location,d,1,mpi_integer,&
                         mpi_comm_world, ierr)
      end if    
! Each processor prints the numbers.     
      print*,'my_rank =',my_rank, 'a = ',a
      print*,'my_rank =',my_rank, 'b = ',b
      print*,'my_rank =',my_rank, 'c = ',c
      print*,'my_rank =',my_rank, 'd = ',d           
      call mpi_finalize(ierr)
      end program packmpi

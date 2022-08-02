      program gridcommpi
! Illustrates grid communicators.      
      include 'mpif.h' 
      IMPLICIT NONE
      type GRID_INFO_TYPE
          integer p        ! total number of processes.
          integer comm     ! communicator for the entire grid.
          integer row_comm ! communicator for my row.
          integer col_comm ! communicator for my col.
          integer q        ! order of grid.
          integer my_row   ! my row number.
          integer my_col   ! my column number.
          integer my_rank  ! my rank in the grid communicator.
      end type GRID_INFO_TYPE
      TYPE (GRID_INFO_TYPE) :: grid_info
      integer :: my_rank, ierr 
      integer, allocatable, dimension(:,:) :: A,B,C
      integer :: i,j,k,n, n_bar
      call mpi_init(ierr)
      call Setup_grid(grid_info)
      call mpi_comm_rank(mpi_comm_world, my_rank, ierr)
      if (my_rank == 0)  then       
          n=6
      endif 
      call mpi_bcast(n,1,mpi_integer, 0, mpi_comm_world, ierr)
      n_bar = n/(grid_info%q)
      !  Allocate local storage for local matrix. 
      allocate( A(n_bar,n_bar) ) 
      allocate( B(n_bar,n_bar) )
      allocate( C(n_bar,n_bar) )
      A = 1 + grid_info%my_row + grid_info%my_col  
      B = 1 - grid_info%my_row - grid_info%my_col
      if (my_rank == 0) then
      	  print*,'n = ',n,'n_bar = ',n_bar,&
      	         'grid%p = ',grid_info%p, 'grid%q = ',grid_info%q
      end if
      print*, 'my_rank = ',my_rank,&      
          	'grid_info%my_row = ',grid_info%my_row,&
                'grid_info%my_col = ',grid_info%my_col 
      call mpi_barrier(mpi_comm_world, ierr)
      print*, 'grid_info%my_row =',grid_info%my_row,&
      	      'grid_info%my_col =',grid_info%my_col,&      
      	      'A = ',A(1,:),& 
      	      'A = ',A(2,:) 
! Uses mpi_bcast to send and recieve parts of the array, A,
! to the processors in grid_info%row_com, which was defined 
! in the call to the subroutine Setup_grid(grid_info).        
      call mpi_bcast(A,n_bar*n_bar,mpi_integer,&
                   1, grid_info%col_comm, ierr)
      print*, 'grid_info%my_row =',grid_info%my_row,&
      	      'grid_info%my_col =',grid_info%my_col,&      
      	      ' new_A = ',A(1,:),& 
      	      ' new_A = ',A(2,:)    
      call mpi_finalize(ierr)      	
      contains

          subroutine Setup_grid(grid)
          ! This subroutine defines a 2D grid communicator.
          ! And for each grid row and grid column additional
          ! communicators are defined.
          TYPE (GRID_INFO_TYPE), intent(inout) :: grid 
          integer old_rank
          integer dimensions(0:1)
          logical periods(0:1)
          integer coordinates(0:1)
          logical varying_coords(0:1) 
          integer ierr
          call mpi_comm_size(mpi_comm_world, grid%p,   ierr)          
          call mpi_comm_rank(mpi_comm_world, old_rank, ierr )          
          grid%q = int(sqrt(dble(grid%p)))
          dimensions(0) = grid%q
          dimensions(1) = grid%q
          periods(0) = .TRUE. 
          periods(1) = .TRUE.
          call mpi_cart_create(mpi_comm_world, 2,&               
          	dimensions, periods, .TRUE. , grid%comm, ierr)          
          call mpi_comm_rank  (grid%comm, grid%my_rank, ierr )          
          call mpi_cart_coords(grid%comm, grid%my_rank, 2,&               
          	coordinates, ierr )          
          grid%my_row = coordinates(0)
          grid%my_col = coordinates(1)
          !  Set up row and column communicators.
          varying_coords(0) = .FALSE.
          varying_coords(1) = .TRUE.
          call mpi_cart_sub(grid%comm,varying_coords,&              
          grid%row_comm,ierr)          
          varying_coords(0) = .TRUE.
          varying_coords(1) = .FALSE.
          call mpi_cart_sub(grid%comm,varying_coords,&           
          grid%col_comm,ierr)          
          end subroutine Setup_grid 
           
        end program gridcommpi



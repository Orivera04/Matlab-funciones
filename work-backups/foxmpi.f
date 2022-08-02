      program foxmpi
      IMPLICIT NONE
      include 'mpif.h' 
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
      real, allocatable, dimension(:,:) :: A,B,C
      integer :: i,j,k,n, n_bar
      real:: mflops
      real*8:: time,t1,t2
      call mpi_init(ierr)
      call Setup_grid(grid_info)
      call mpi_comm_rank(mpi_comm_world, my_rank, ierr)
      if (my_rank == 0)  then
      !    print *, 'What is the order of the matrices?'          
      !    read *, n          
          n = 1600          
          t1 = mpi_wtime()    
      endif 
      call mpi_bcast(n,1,mpi_integer, 0, mpi_comm_world,ierr)
      n_bar = n/(grid_info%q)
      !  Allocate storage for local matrix. 
      allocate( A(n_bar,n_bar) ) 
      allocate( B(n_bar,n_bar) )
      allocate( C(n_bar,n_bar) )
      A = 1.0  
      B = 2.0
      call Fox(n,grid_info,A,B,C,n_bar)
      if (my_rank == 0)  then
        t2 = mpi_wtime()    
        print*,t2-t1             
        print*,n,n_bar,grid_info%q          
        print*,C(5,5)       
        mflops = (2*n*n*n)*.000001/(t2-t1)          
        mflops = (2*n/100*n/100*n/100)/(t2-t1)
        print*, mflops          
      endif 
      call mpi_finalize(ierr)      	
      contains

          subroutine Setup_grid(grid)
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
          call MPI_Cart_sub(grid%comm,varying_coords,&              
          grid%row_comm,ierr)          
          varying_coords(0) = .TRUE.
          varying_coords(1) = .FALSE.
          call mpi_cart_sub(grid%comm,varying_coords,&           
          grid%col_comm,ierr)          
          end subroutine Setup_grid
!
          subroutine Fox(n,grid,local_A,local_B,local_C,n_bar)          
          integer, intent(in)               :: n, n_bar
          TYPE(GRID_INFO_TYPE), intent(in)  :: grid
          real, intent(in) , dimension(:,:) :: local_A, local_B
          real, intent(out), dimension (:,:) :: local_C
          real, dimension(1:n_bar,1:n_bar):: temp_A
          integer:: step, source, dest, request,i,j
          integer:: status(MPI_STATUS_SIZE), bcast_root
          temp_A = 0.0
          local_C = 0.0
          source = mod( (grid%my_row + 1), grid%q )
          dest   = mod( (grid%my_row + grid%q -1), (grid%q) )
          do step = 0, grid%q -1
            bcast_root = mod( (grid%my_row + step), (grid%q) )
            if (bcast_root == grid%my_col)  then
              call mpi_bcast(local_A,n_bar*n_bar,mpi_real,&
                                                      bcast_root, grid%row_comm, ierr)
!	call sgemm('N','N',n_bar,n_bar,n_bar,1.0,&            
!         local_A,n_bar,local_B,n_bar,1.0,local_C,n_bar)         
               do j = 1,n_bar
                 do k = 1,n_bar
                   do i = 1,n_bar
                     local_C(i,j)=local_C(i,j) + local_A(i,k)*&
                                           local_B(k,j)
                   end do
                 end do
               end do                  
            else
              call mpi_bcast(temp_A,n_bar*n_bar,mpi_real,& 
                                                 bcast_root, grid%row_comm, ierr)
!              call sgemm('N','N',n_bar,n_bar,n_bar,1.0,&  
!                                  temp_A,n_bar,local_B,n_bar,1.0,local_C,n_bar)
                 do j = 1,n_bar
                   do k = 1,n_bar
                      do i = 1,n_bar
                        local_C(i,j)=local_C(i,j) + temp_A(i,k)*&
                                           local_B(k,j)
                      enddo
                   enddo
                 enddo
            endif
              call mpi_sendrecv_replace(local_B,n_bar*n_bar,mpi_real,&
                              dest,  0,source, 0, &
                              grid%col_comm,status, ierr)             
          end do 
          end subroutine Fox
!          
      end program foxmpi

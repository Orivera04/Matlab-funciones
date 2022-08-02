           Program heat
           implicit none
           include 'mpif.h'
           real, dimension(2050,2050)::  unew,uold
           real :: f,cond,dt,dx,alpha,t0, timef,tend
           integer :: my_rank,p,n,source,dest,tag,ierr,loc_n
           integer :: status(mpi_status_size),bn,en,j,k
           integer :: maxk,i,sbn
           n = 2049 
           maxk = 1000
           f = 1000.0
           cond = .01
           dt = .01
           dx = 100.0/(n+1) 
           alpha = cond*dt/(dx*dx)
           uold = 0.0
           unew = 0.0
           call mpi_init(ierr)
           call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
           call mpi_comm_size(mpi_comm_world,p,ierr) 
           loc_n = (n-1)/p
           bn = 2+(my_rank)*loc_n
           en = bn + loc_n -1
           call mpi_barrier(mpi_comm_world,ierr)
           if (my_rank.eq.0) then
             t0 = timef()
           end if 
           do k =1,maxk
             do j = bn,en
              do i= 2,n
               unew(i,j) = dt*f + alpha*(uold(i-1,j)+uold(i+1,j)&
                 +  uold(i,j-1) + uold(i,j+1))&
                 +   (1- 4*alpha)*uold(i,j)
              end do
             end do 
             uold(2:n,bn:en)= unew(2:n,bn:en)
           if (my_rank.eq.0) then
               call mpi_recv(uold(1,en+1),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(uold(1,en),(n+1),mpi_real,my_rank+1,50,&
                            mpi_comm_world,ierr)
           end if
           if ((my_rank.gt.0).and.(my_rank.lt.p-1) &
                   .and.(mod(my_rank,2).eq.1)) then
               call mpi_send(uold(1,en),(n+1),mpi_real,my_rank+1,50,&
                            mpi_comm_world,ierr)
               call mpi_recv(uold(1,en+1),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(uold(1,bn),(n+1),mpi_real,my_rank-1,50,&
                            mpi_comm_world,ierr)
               call mpi_recv(uold(1,bn-1),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
           end if 
           if ((my_rank.gt.0).and.(my_rank.lt.p-1) &
                   .and.(mod(my_rank,2).eq.0)) then
               call mpi_recv(uold(1,bn-1),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(uold(1,bn),(n+1),mpi_real,my_rank-1,50,&
                            mpi_comm_world,ierr)
               call mpi_recv(uold(1,en+1),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(uold(1,en),(n+1),mpi_real,my_rank+1,50,&
                            mpi_comm_world,ierr)
           end if
           if (my_rank.eq.p-1) then
               call mpi_send(uold(1,bn),(n+1),mpi_real,my_rank-1,50,&
                            mpi_comm_world,ierr)
               call mpi_recv(uold(1,bn-1),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
           end if
           end do
             if (my_rank.eq.0) then
               do source = 1,p-1 
                    sbn = 2+(source)*loc_n
                    call mpi_recv(uold(1,sbn),(n+1)*loc_n,mpi_real,source,50,&
                        mpi_comm_world,status,ierr)
               end do
             else
               call mpi_send(uold(1,bn),(n+1)*loc_n,mpi_real,0,50,&
                            mpi_comm_world,ierr)
             end if 
           if (my_rank.eq.0) then
            tend = timef()
            print*,  'time =', tend
            print*, uold(2,2),uold(3,3),uold(4,4),uold(500,500)
           end if 
           call mpi_finalize(ierr)
           end

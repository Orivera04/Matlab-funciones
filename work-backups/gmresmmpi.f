	program gmres 
! This code approximates the solution of
!	-u_xx - u_yy + a1 u_x + a2 u_y + a3 u = f
! GMRES(m) is used with a SSOR verson of the
! Schwarz additive preconditioner.
! The sparse matrix product, dot products and updates
! are also done in parallel.                                   
	implicit none
	include 'mpif.h'  
	real, dimension(0:1025,0:1025,1:51):: v
	real, dimension(0:1025,0:1025)::  r,b,x,rhat
	real, dimension(0:1025)::  xx,yy
	real, dimension(1:51,1:51):: h
	real, dimension(1:51)::  g,c,s,y,mag
        real::  errtol,rho,hik,hipk,nu,gk,gkp,w,t0
        real*8:: tbegin, tend
        real :: loc_rho,loc_ap,loc_error,temp
        real :: hh,a1,a2,a3,ac,ae,aw,an,as,rac
	integer :: nx,ny,n,kmax,k,i,j,mmax,m,sbn
	integer :: my_rank,proc,source,dest,tag,ierr,loc_n
        integer :: status(mpi_status_size),bn,en
	nx = 1025
	ny = nx
	n = nx
	hh = 1./n
      	do i=0,n
      	  xx(i) = hh*i
      	  yy(i) = xx(i)
      	end do
      	a1 = 1.
      	a2 = 10.
      	a3 = 1.
      	ac = 4.+a1*hh+a2*hh+a3*hh*hh
      	rac = 1./ac
      	aw = 1.+a1*hh
      	ae = 1.
      	as = 1.+a2*hh
      	an = 1.
	errtol=.001
	kmax=50
	mmax=1000
	do j = 1,ny-1
          b(1:nx-1,j) = 200.0*hh*hh*(1.+sin(3.14*xx(1:nx-1))*sin(3.14*yy(j)))
        end do
	errtol = errtol*sqrt(sum(b(1:nx-1,1:ny-1)*b(1:nx-1,1:ny-1)))
	rho = 1.
	w = 1.8
	m = 0
!  Initial guess.
        rhat = 0.0 
	x = 0.0
	h = 0.0
	v= 0.0               
	c= 0.0
	s= 0.0
	g = 0.0
	y = 0.0
	call mpi_init(ierr)
        call mpi_comm_rank(mpi_comm_world,my_rank,ierr)
        call mpi_comm_size(mpi_comm_world,proc,ierr) 
        loc_n = (n-1)/proc
        bn = 1+(my_rank)*loc_n
        en = bn + loc_n -1
        call mpi_barrier(mpi_comm_world,ierr)
        if (my_rank.eq.0) then
          tbegin = mpi_wtime()
        end if 
!  Begin restart loop.
        do while ((rho>errtol).and.(m<mmax))
        m = m+1	      
	h = 0.0
	v= 0.0
	c= 0.0
	s= 0.0
	g = 0.0
	y = 0.0
! Matrix vector product for the initial residual.      
! First, exchange information between processors. 
        if (my_rank.eq.0) then
          call mpi_recv(x(0,en+1),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
          call mpi_send(x(0,en),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,ierr)
        end if
        if ((my_rank.gt.0).and.(my_rank.lt.proc-1)&
           	.and.(mod(my_rank,2).eq.1)) then
          call mpi_send(x(0,en),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,ierr)
          call mpi_recv(x(0,en+1),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
          call mpi_send(x(0,bn),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,ierr)
          call mpi_recv(x(0,bn-1),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
         end if
         if ((my_rank.gt.0).and.(my_rank.lt.proc-1)&
           	.and.(mod(my_rank,2).eq.0)) then
           call mpi_recv(x(0,bn-1),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
           call mpi_send(x(0,bn),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,ierr)
           call mpi_recv(x(0,en+1),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
           call mpi_send(x(0,en),(n+1),mpi_real,my_rank+1,50,&
                            mpi_comm_world,ierr)
         end if 
         if (my_rank.eq.proc-1) then
           call mpi_send(x(0,bn),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,ierr)
           call mpi_recv(x(0,bn-1),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
         end if  
	r(1:nx-1,bn:en)=b(1:nx-1,bn:en)+aw*x(0:nx-2,bn:en)+&
			ae*x(2:nx,bn:en)+as*x(1:nx-1,bn-1:en-1)+&
			an*x(1:nx-1,bn+1:en+1)-ac*x(1:nx-1,bn:en)	
!       This preconditioner changes with the number of processors!
        do j= bn,en
 	  do i = 1,n-1
	    rhat(i,j) = w*(r(i,j)+aw*rhat(i-1,j)+as*rhat(i,j-1))*rac
	  end do
	end do
	rhat(1:n-1,bn:en) =  ((2.-w)/w)*ac*rhat(1:n-1,bn:en)
	do j= en,bn,-1
	  do i = n-1,1,-1
    	    rhat(i,j) = w*(rhat(i,j)+ae*rhat(i+1,j)+an*rhat(i,j+1))*rac
	  end do
	end do
	r(1:n-1,bn:en) = rhat(1:n-1,bn:en)     	                     
	loc_rho=(sum(r(1:nx-1,bn:en)*r(1:nx-1,bn:en)))
	call mpi_allreduce(loc_rho,rho,1,mpi_real,mpi_sum,&
				mpi_comm_world,ierr)
	rho = sqrt(rho)
	g(1) =rho
	v(1:nx-1,bn:en,1)=r(1:nx-1,bn:en)/rho
	k=0
! Begin gmres loop.
	do while((rho > errtol).and.(k < kmax))          
   		k=k+1 	         
! Matrix vector product.      
! First, exchange information between processors.         
           if (my_rank.eq.0) then
               call mpi_recv(v(0,en+1,k),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(v(0,en,k),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,ierr)
           end if
           if ((my_rank.gt.0).and.(my_rank.lt.proc-1)&
           	.and.(mod(my_rank,2).eq.1)) then
               call mpi_send(v(0,en,k),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,ierr)
               call mpi_recv(v(0,en+1,k),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(v(0,bn,k),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,ierr)
               call mpi_recv(v(0,bn-1,k),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
           end if
           if ((my_rank.gt.0).and.(my_rank.lt.proc-1)&
           	.and.(mod(my_rank,2).eq.0)) then
               call mpi_recv(v(0,bn-1,k),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(v(0,bn,k),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,ierr)
               call mpi_recv(v(0,en+1,k),(n+1),mpi_real,my_rank+1,50,&
                        mpi_comm_world,status,ierr)
               call mpi_send(v(0,en,k),(n+1),mpi_real,my_rank+1,50,&
                            mpi_comm_world,ierr)
           end if 
           if (my_rank.eq.proc-1) then
               call mpi_send(v(0,bn,k),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,ierr)
               call mpi_recv(v(0,bn-1,k),(n+1),mpi_real,my_rank-1,50,&
                        mpi_comm_world,status,ierr)
           end if 
   	v(1:nx-1,bn:en,k+1)=-aw*v(0:nx-2,bn:en,k)-ae*v(2:nx,bn:en,k)&
   			    -as*v(1:nx-1,bn-1:en-1,k)-an*v(1:nx-1,bn+1:en+1,k)&
   			    +ac*v(1:nx-1,bn:en,k)
!       This preconditioner changes with the number of processors!
        do j= bn,en
 	  do i = 1,n-1
	    rhat(i,j) = w*(v(i,j,k+1) + aw*rhat(i-1,j) + as*rhat(i,j-1))*rac
	  end do
	end do
	rhat(1:n-1,bn:en) =  ((2.-w)/w)*ac*rhat(1:n-1,bn:en)
	do j= en,bn,-1
	  do i = n-1,1,-1
    	    rhat(i,j) = w*(rhat(i,j)+ae*rhat(i+1,j)+an*rhat(i,j+1))*rac
	  end do
	end do
	v(1:n-1,bn:en,k+1) = rhat(1:n-1,bn:en)    		                     	
! Begin modified GS. May need to reorthogonalize.   
		do j=1,k                               
      			temp=sum(v(1:nx-1,bn:en,j)*v(1:nx-1,bn:en,k+1))
      			call mpi_allreduce(temp,h(j,k),1,mpi_real,mpi_sum,&
      						mpi_comm_world,ierr)
      			v(1:nx-1,bn:en,k+1)=v(1:nx-1,bn:en,k+1)-&
      						h(j,k)*v(1:nx-1,bn:en,j)
	
   		end do
       		temp=(sum(v(1:nx-1,bn:en,k+1)*v(1:nx-1,bn:en,k+1)))
       		call mpi_allreduce(temp,h(k+1,k),1,mpi_real,mpi_sum,&
       						mpi_comm_world,ierr)
       		h(k+1,k) = sqrt(h(k+1,k))
       		if (h(k+1,k).gt.0.0.or.h(k+1,k).lt.0.0) then
           		v(1:nx-1,bn:en,k+1)=v(1:nx-1,bn:en,k+1)/h(k+1,k)
       		end if
       		if (k>1)  then                           
! Apply old Givens rotations to h(1:k,k).
       			do i=1,k-1
         			hik    =c(i)*h(i,k)-s(i)*h(i+1,k)
         			hipk   =s(i)*h(i,k)+c(i)*h(i+1,k)
         			h(i,k) = hik
         			h(i+1,k) = hipk
      			end do
    		end if
    		nu=sqrt(h(k,k)**2 + h(k+1,k)**2)                
! May need better Givens implementation.
! Define and Apply new Givens rotations to h(k:k+1,k).  
    		if (nu.gt.0.0) then
                        c(k)=h(k,k)/nu
		        s(k)=-h(k+1,k)/nu
		        h(k,k)=c(k)*h(k,k)-s(k)*h(k+1,k)
		        h(k+1,k)=0
		        gk    =c(k)*g(k) -s(k)*g(k+1)
        		gkp  =s(k)*g(k) +c(k)*g(k+1)
        		g(k) = gk
        		g(k+1) = gkp
		end if
		rho=abs(g(k+1))
    		mag(k) = rho
! End of gmres loop.
	end do
! h(1:k,1:k) is upper triangular matrix in QR.                                        
	y(k) = g(k)/h(k,k)
	do i = k-1,1,-1
		y(i) = g(i)
		do j = i+1,k
			y(i) = y(i) -h(i,j)*y(j)
		end do
		y(i) = y(i)/h(i,i)
	end do
! Form linear combination.
         do i = 1,k                                   
	   x(1:nx-1,bn:en) = x(1:nx-1,bn:en) + v(1:nx-1,bn:en,i)*y(i)
	 end do
! Send the local solutions to processor zero.	 
	 if (my_rank.eq.0) then
             do source = 1,proc-1 
                    sbn = 1+(source)*loc_n
                    call mpi_recv(x(0,sbn),(n+1)*loc_n,mpi_real,source,50,&
                        mpi_comm_world,status,ierr)
             end do
         else
              call mpi_send(x(0,bn),(n+1)*loc_n,mpi_real,0,50,&
                            mpi_comm_world,ierr)   
         end if
	
! End restart loop. 	
	end do
	if (my_rank.eq.0) then
	   tend = mpi_wtime() 
	   print*, m, mag(k)
	   print*, m,k,x(513,513)
           print*,  'time =', tend-tbegin
        end if 
      call mpi_finalize(ierr)
	end program

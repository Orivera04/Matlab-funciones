      program por2d
      implicit none
      real , dimension(0:51,0:51) :: u
      real , dimension(0:51) :: x,y
      real:: cond,dx,dy,W,L,uleft,uright
      real :: eps,error,ww,utemp,utempp,rdx,rdx2,rdy,rdy2
      real :: well,xw,yw  
      integer nx,ny,i,j,numi,nunkno,maxm,m,iw,jw,iwp,jwp 
      maxm = 500
      eps = .1
      ww = 1.7
      open(6,file='c:\matlab\outpors',recl = 612)
!
!     Porous Medium Data.
!      
      nx = 50
      ny = 10
      cond = 10.
      iw = 15
      jw = 4
      iwp = 32
      jwp = 3
      well = -.05
      uleft = 100. 
      uright = 100.
      do j=0,ny
          u(0,j) = uleft
          u(nx,j) = uright
      end do
      do j =0,ny
          do i = 1,nx
             u(i,j) = 100.
          end do
      end do
      W = 1000.
      L = 5000.
      dx = L/nx
      rdx = 1./dx
      rdx2 = cond/(dx*dx)
      dy = W/ny
      rdy = 1./dy
      rdy2 = cond/(dy*dy)
      xw = (iw)*dx
      yw = (jw)*dy
      do i = 0,nx
          x(i) = dx*i
      end do
      do j = 0,ny
          y(j) = dy*j
      end do
!
!     Execute SOR Algorithm
!
      nunkno = (nx-1)*(ny+1)
      m = 1
      do while ((numi.lt.nunkno).and.(m.lt.maxm))
         numi = 0
!     Interior         
         do j = 1,ny-1   
            do i=1,nx-1
                utemp = rdx2*(u(i+1,j)+u(i-1,j))
                utempp = utemp + rdy2*(u(i,j+1)+u(i,j-1))
                utemp = utempp/(2.*rdx2 + 2.*rdy2)
                if ((i.eq.iw).and.(j.eq.jw)) then  
                    utemp =(utempp + well)/(2.*rdx2+2.*rdy2) 
                end if 
!                if ((i.eq.iwp).and.(j.eq.jwp)) then  
!                    utemp =(utempp + well)/(2.*rdx2+2.*rdy2) 
!                end if
                utemp = (1.-ww)*u(i,j) + ww*utemp
                error = abs(utemp - u(i,j)) 
                u(i,j) = utemp
                if (error.lt.eps) then
                    numi = numi +1
                end if
            end do
         end do
!     Bottom          
         j = 0  
            do i=1,nx-1
                utemp = rdx2*(u(i+1,j)+u(i-1,j))
                utemp = utemp + 2.*rdy2*(u(i,j+1))
                utemp = utemp/(2.*rdx2 + 2.*rdy2 )
                utemp = (1.-ww)*u(i,j) + ww*utemp
                error = abs(utemp - u(i,j)) 
                u(i,j) = utemp
                if (error.lt.eps) then
                    numi = numi +1
                end if
            end do
            
!     Top          
         j = ny  
            do i=1,nx-1
                utemp = rdx2*(u(i+1,j)+u(i-1,j))
                utemp = utemp + 2.*rdy2*(u(i,j-1))
                utemp = utemp/(2.*rdx2 + 2.*rdy2)
                utemp = (1.-ww)*u(i,j) + ww*utemp
                error = abs(utemp - u(i,j)) 
                u(i,j) = utemp
                if (error.lt.eps) then
                    numi = numi +1
                end if
            end do
      m = m+1      
      end do
!
!     Output to Terminal and Matlab
!     
      print*, m 
      do j = 0,ny
         write(6,'(51f12.4)') (u(i,j),i=0,nx)
      end do
      close(6)
      end program

          

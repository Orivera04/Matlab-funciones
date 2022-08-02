      program fin2d
      implicit none
      real ,dimension (0:51,0:51)::u
      real ,dimension (0:51)::x,y
      real ::cond,dx,dy,csur,usur,T,W,L,uleft,cc
      real ::eps,error,ww, utemp,rdx,rdx2,rdy,rdy2  
      integer ::nx,ny,i,j,nunkno,maxm,m,numi 
      maxm = 500
      eps = .01
      ww = 1.8
      open(6,file='c:\matlab\outfin')
!
!     Fin Data.
!      
      nx = 20
      ny = 20
      cond = .001
      csur = .001000
      usur = 70.
      uleft = 200.
      do j=0,ny
          u(0,j) = uleft
      end do
      do j =0,ny
          do i = 1,nx
             u(i,j) = 200.
          end do
      end do
      T = .15
      W = 1
      L = .5
      dx = L/nx
      rdx = 1./dx
      rdx2 = cond/(dx*dx)
      dy = W/ny
      rdy = 1./dy
      rdy2 = cond/(dy*dy)
      cc = csur*2./T
      do i = 0,nx
          x(i) = dx*i
      end do
      do j = 0,ny
          y(j) = dy*j
      end do
!
!     Execute SOR Algorithm
!
      nunkno = (nx)*(ny+1)
      m = 1
      do while ((numi.lt.nunkno).and.(m.lt.maxm))
         numi = 0
!     Interior         
         do j = 1,ny-1   
            do i=1,nx-1
                utemp = cc*usur + rdx2*(u(i+1,j)+u(i-1,j))
                utemp = utemp + rdy2*(u(i,j+1)+u(i,j-1))
                utemp = utemp/(2.*rdx2 + 2.*rdy2 + CC)
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
                utemp = (cc+2*csur/dy)*usur + rdx2*(u(i+1,j)+u(i-1,j))
                utemp = utemp + 2.*rdy2*(u(i,j+1))
                utemp = utemp/(2.*rdx2 + 2.*rdy2 + cc +2.*csur/dy)
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
                utemp = (cc+2*csur/dy)*usur + rdx2*(u(i+1,j)+u(i-1,j))
                utemp = utemp + 2.*rdy2*(u(i,j-1))
                utemp = utemp/(2.*rdx2 + 2.*rdy2 + cc +2.*csur/dy)
                utemp = (1.-ww)*u(i,j) + ww*utemp
                error = abs(utemp - u(i,j)) 
                u(i,j) = utemp
                if (error.lt.eps) then
                    numi = numi +1
                end if
            end do
!     Bottom Right Corner
         j = 0 
            i = nx
                utemp = (cc+2.*csur*(rdy+rdx))*usur+2.*rdx2*u(i-1,j)
                utemp = utemp + 2.*rdy2*(u(i,j+1))
                utemp = utemp/(2.*rdx2+2.*rdy2+cc+2.*csur*(rdy+rdx))
                utemp = (1.-ww)*u(i,j) + ww*utemp
                error = abs(utemp - u(i,j)) 
                u(i,j) = utemp
                if (error.lt.eps) then
                    numi = numi +1
                end if
!     Top Right Corner
         j = ny 
            i = nx
                utemp = (cc+2.*csur*(rdy+rdx))*usur+2.*rdx2*u(i-1,j)
                utemp = utemp + 2.*rdy2*(u(i,j-1))
                utemp = utemp/(2.*rdx2+2.*rdy2+cc+2.*csur*(rdy+rdx))
                utemp = (1.-ww)*u(i,j) + ww*utemp
                error = abs(utemp - u(i,j)) 
                u(i,j) = utemp
                if (error.lt.eps) then
                    numi = numi +1
                end if
!     Right          
         i = nx  
            do j=1,ny-1
                utemp = (cc+2*csur/dx)*usur + 2.*rdx2*u(i-1,j)
                utemp = utemp + rdy2*(u(i,j+1)+u(i,j-1))
                utemp = utemp/(2.*rdx2 + 2.*rdy2 + cc +2.*csur/dx)
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
         write(6,'(21f10.4)') (u(i,j),i=0,nx)
      end do
      close(6)
      end program

          

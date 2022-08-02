      program heatl
      implicit none
      real ,dimension (1:11,1:101) ::u
      real ,dimension (1:101) ::t
      real ,dimension (1:11)  ::x
      real :: cond,f,alpha,dt,dx,csur,usur,r
      integer ::n,maxk,k,i 
      open(6,file="c:\matlab\outheatl")
      n = 10
      maxk = 100
      f = 1.0
      cond = .001
      dt = 5.
      dx = .1
      alpha = cond*dt/(dx*dx)
      csur = .0005
      usur = -10.
      r = .05
      do k = 1,maxk 
        t(k+1) = dt*(k-1)
        do i = 1,n+1
          x(i) = dx*(i-1)
          u(i,k) = 0.0
        end do
      end do
      do k = 1,maxk
        do i = 2,n
          u(i,k+1) = dt*(f+csur*(2./r)*usur) &
                      + alpha*(u(i-1,k) + u(i+1,k)) &
                      + (1. - 2.*alpha - dt*csur*(2./r))*u(i,k)
        end do
        write(6,'(11f12.4)') (u(i,k+1),i=1,n+1)
        write(*,'(11f12.4)') (u(i,k+1),i=1,n+1)
      end do
      close(6)
      end program

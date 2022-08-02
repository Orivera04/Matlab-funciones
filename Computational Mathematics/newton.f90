      program newton
      implicit none
      real ::eps, res,fnewt,fnewtp
      real ,dimension (1:100)::x
      integer :: m,maxm 
!                 
!     INPUT eps, initial guess.
!
      x(1) = 100.0
      eps = .0001
      res = 1.0
!
!     The Newton algorithm is executed.
!
      m = 1
      do while (m.lt.50.and.res.gt.eps)
        x(m+1) = x(m) - fnewt(x(m))/fnewtp(x(m))
        res =abs(fnewt(x(m+1)))
        maxm = m+1
        m = m+1
      end do 
!
!     OUTPUT is listed in table.
!
      do m=1,maxm
        write(*,'(f10.4)') x(m)
      end do
      print*, maxm, x(maxm)    
      write(*,'(a15,i4)') 'num. of iter.=',maxm
      write(*,'(a15,f10.4)') 'fixed point=',x(maxm)
      end program
!     
!     Fixed point function for falling problem
!      
      function fnewt(x) result(ffnewt)
      	implicit none
        real:: ffnewt,x
        ffnewt = -x+100.+.005*(32.-.5*x*x +(32.-.5*100*100))
      end function
!      
      function fnewtp(x) result(ffnewtp)
        implicit none
        real:: ffnewtp,x
        ffnewtp = -1+.005*(-.25*x)
      end function  

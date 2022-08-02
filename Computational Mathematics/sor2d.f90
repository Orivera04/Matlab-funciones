      program sor 
      implicit none
      real ,dimension(1:101,1:101) :: u,newu
      real :: w,h,eps,err,to,utemp
      integer :: n,maxit,it,i,j
      n = 100
      w = 1.94
      h = 1.0/n
      maxit = 10000
      it = 0
      eps = .001
      err = 1.
      u = 0.
      newu = 0.
      do while ((err.gt.eps).and.(it.lt.maxit))
        do j=2,n
          do i=2,n
          	utemp = (100.*h*h+u(i-1,j)+u(i,j-1)+u(i+1,j)+u(i,j+1))*.25
          	u(i,j) = (1. -w)*u(i,j) + w*utemp
         end do
        end do 
        err = maxval(abs(u - newu))
        newu = u
        it = it +1
      end do
      print*, it
      end
   

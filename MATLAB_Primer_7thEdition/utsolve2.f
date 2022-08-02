      subroutine mexFunction
     $ (nargout, pargout, nargin, pargin)
      integer nargout, nargin
      integer pargout (*), pargin (*)
      integer mxGetN, mxGetPr
      integer mxCreateDoubleMatrix
      integer n
      integer nmax
      parameter (nmax = 5000)
      real*8 A(nmax,nmax), x(nmax), b(nmax)

      n = mxGetN (pargin (1))

      if (n .gt. nmax) then
        call mexErrMsgTxt ("n too big")
      endif

      pargout (1) =
     $ mxCreateDoubleMatrix (n, 1, 0)

      call mxCopyPtrToReal8
     $ (mxGetPr (pargin (1)), A, n**2)
      call mxCopyPtrToReal8
     $ (mxGetPr (pargin (2)), b, n)
      call utsolve (n, x, A, b)
      call mxCopyReal8ToPtr
     $ (x, mxGetPr (pargout (1)), n)

      return
      end

      subroutine utsolve (n, x, A, b)
      integer n
      real*8 x(n), A(n,n), b(n), xi
      integer i, j
      do 1 i = 1,n
        xi = b(i)
        do 2 j = 1,i-1
          xi = xi - A(j,i) * x(j)
2       continue
        x(i) = xi / A(i,i)
1     continue
      return
      end

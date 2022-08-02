      subroutine mexFunction
     $ (nargout, pargout, nargin, pargin)
      integer nargout, nargin
      integer pargout (*), pargin (*)
      integer mxGetN, mxGetPr
      integer mxCreateDoubleMatrix
      integer n
      n = mxGetN (pargin (1))
      pargout (1) =
     $ mxCreateDoubleMatrix (n, 1, 0)
      call utsolve (n,
     $ %val (mxGetPr (pargout (1))),
     $ %val (mxGetPr (pargin (1))),
     $ %val (mxGetPr (pargin (2))))
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

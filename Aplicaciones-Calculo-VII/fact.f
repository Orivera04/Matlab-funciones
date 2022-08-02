C--------------------------------------------------------------
C     fact.f  - returns the factorial of a non-negative integer.
C
C      MATLAB usage:   p = fact(n)
      
      subroutine mexFunction(nlhs, plhs, nrhs, prhs)
C---These are pointers: integer*4 (integer*8 on 64-bit CPUs)---
      integer plhs(*), prhs(*)
      integer mxGetPr, mxCreateFull
      integer y_pr
C--------------------------------------------------------------
      integer nlhs, nrhs
      integer i
      real*8  x, y, mxGetScalar
C--------------------------------------------------------------
      x = mxGetScalar(prhs(1))
      plhs(1) = mxCreateDoubleMatrix(1, 1, 0)
      y_pr = mxGetPr(plhs(1))
C     
      y = 1.0
      do 10 i=x,1,-1
         y = y * i
 10   continue
C
      call mxCopyReal8ToPtr(y, y_pr, 1)     
      return
      end

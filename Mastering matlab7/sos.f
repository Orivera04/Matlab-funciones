C 
C   sos.f - Calculate the sum of the squares of the elements of a vector.
C 
C   Mastering MATLAB Engine Example
C
C    B.R. Littlefield, University of Maine, Orono, ME 04469
C    7/17/00
C    Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
C  
C==============================================================
      program main
C--------------------------------------------------------------
C     Pointers
C
      integer engOpen, engGetMatrix, mxCreateFull, mxGetPr
      integer mat, mydata, sqdata 
C--------------------------------------------------------------
C     Other variable declarations here
C
      double precision dataset(10), sqrs(10), x
      integer engPutMatrix, engEvalString, engClose, engOutputBuffer
      integer temp, status
      character*256 buf
      data dataset / 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0 /
C
C     Start the MATLAB engine on the local computer.
C
      mat = engOpen('matlab ')
      if (mat .eq. 0) then
         write(6,*) 'Cannot open connection to MATLAB!'
         stop
      endif
C
C     Create an mxArray, associate a MATLAB variable name with the
C       mxArray, and copy the data into the array.
C
      mydata = mxCreateFull(1, 10, 0)
      call mxSetName(mydata, 'newdata')
      call mxCopyReal8ToPtr(dataset, mxGetPr(mydata), 10)
C
C     Pass the variable mydata into the MATLAB workspace.
C
      status = engPutMatrix(mat, mydata)
      if (status .ne. 0) then 
         write(6,*) 'Cannot pass mydata to the Engine!'
         stop
      endif
C
C     Square the elements of the array.
C
      if (engEvalString(mat, 'sqdata = newdata.^2;') .ne. 0) then
         write(6,*) 'engEvalString failed'
         stop
      endif
C
C     Create an output buffer to capture MATLAB text output.
C
      if (engOutputBuffer(mat, buf) .ne. 0) then
         write(6,*) 'engEvalString failed'
         stop
      endif
C
C     Calculate the sum of the squares and capture the result.
C
      if (engEvalString(mat, 'disp(sum(sqdata))') .ne. 0) then
         write(6,*) 'engEvalString failed'
         stop
      endif
C
C     Retrieve the mxArray of squares from the engine,
C     copy the data into an array of doubles, and print.
C
      sqdata = engGetMatrix(mat, 'sqdata')
      call mxCopyPtrToReal8(mxGetPr(sqdata), sqrs, 10)
C
 20   format(' ', G8.3, G8.3, G8.3, G8.3, G8.3, G8.3, 
     & G8.3, G8.3, G8.3, G8.3)
      print *, 'The inputs are:'
      print 20, dataset
      print *, 'The squares are:'
      print 20, sqrs
      print *,  'The sum of the squares is ', buf(3:10)
C   
C     Free the mxArray memory and quit MATLAB.
C     
      call mxFreeMatrix(mydata)
      call mxFreeMatrix(sqdata)
      status = engClose(mat)
C      
      if (status .ne. 0) then 
         write(6,*) 'engClose failed'
         stop
      endif
C
      stop
      end

C 
C   writemat.f - Create a binary MAT file.
C 
C   Mastering MATLAB MAT-file Example
C 
C  

C    B.R. Littlefield, University of Maine, Orono, ME 04469
C    7/20/00
C    Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9
C  

      program writemat
C--------------------------------------------------------------
C     Pointers.
C
      integer matOpen, mxCreateFull, mxCreateString
      integer matGetMatrix, mxGetPr
      integer mfile, mdata, mstr
C--------------------------------------------------------------
C     Other variables
C     
      integer status, matClose
      double precision dat(12)
      data dat / 1.0, 5.5, -4.0, 
     &           2.0, 6.6, -3.0, 
     &           3.0, 7.7, -2.0, 
     &           4.0, 8.8, -1.0 /
C
C     Open MAT-file for writing.
C
      mfile = matOpen('mmtest.mat', 'w')
      if (mfile .eq. 0) then
         write(6,*) 'Cannot open ''mmtest.mat'' for writing.'
         stop
      end if
C
C     Create the mxArray to hold the numeric data.
C
      mdata = mxCreateFull(4,3,0)
      call mxSetName(mdata, 'mydata')
C
C     Copy the data to the mxArray. 
C
      call mxCopyReal8ToPtr(dat, mxGetPr(mdata), 12)
C
C     Create the string array and set the variable name.
C
      mstr = mxCreateString('Mastering MATLAB Rocks!')
      call mxSetName(mstr, 'mystr')
C
C     Write the mxArrays to the MAT file.
C
      call matPutMatrix(mfile, mdata)
      call matPutMatrix(mfile, mstr)
C
C     Free the mxArray memory.
C
      call mxFreeMatrix(mdata)
      call mxFreeMatrix(mstr)
C
C     Close the MAT file.
C
      status = matClose(mp)
      if (status .ne. 0) then
         write(6,*) 'Cannot close mmtest.mat.'
         stop
      end if
C
      stop
      end

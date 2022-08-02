THE COMPUTER EXPLORATIONS TOOLBOX
---------------------------------

This directory contains the Computer Explorations Toolbox, which is
the set of M-files and data files which accompany the textbook
"Computer Explorations in Signals and Systems using MATLAB" by John
Buck, Michael Daniel, and Andrew Singer, Prentice Hall, 1997, 2002.  All the
M-files are copyrighted, 1996, 2001, by the aforementioned authors.  You are
free to modify any of the files, provided that you acknowledge the
source in any publication and do not sell the modified file.

All of the data and M-files have been created and/or tested using
MATLAB Version 6. Instructors or professional engineers who have any 
problems with these files should contact one of the authors at the 
following e-mail addresses:

	jbuck@umassd.edu 	(John Buck)
	mdaniel@alum.mit.edu 	(Michael Daniel)
	singer@ifp.uiuc.edu 	(Andrew Singer)

However, as the software is distributed free of charge, neither The
MathWorks nor the authors can guarantee technical support.  (See
also the MathWorks disclaimer below.)

The remainder of this file contains a brief description of the MATLAB
M-files (*.m) and data files (*.mat) which are contained in this
directory.  The Exercise number in which the M-file is listed (or the
Exercise number in the data file is used) is also included.

I. M-files
------------
CTFTS.M		Exercise 7.1
  Calculates the continuous-time Fourier transform of a periodic
  signal.

DF2CF.M		Exercise 10.3
  Converts a direct form filter into a series connection of
  second-order filters.

DPZPLOT.M	Exercises 10.1
  Plots the poles and zeros of a discrete-time linear system.

DTFTSINC.M	Exercise 5.1
  Calculates samples of the discrete-time sinc function.

EYEDIAGRAM.M	Exercise 8.4
  Plots the eye diagram for a pulse-amplitude-modulated (PAM) system.

PLOTPZ.M	Exercises 9.1
  Plots the poles and zeros of a continuous-time linear system function.
  (Note: In the first edition of this book, this file was called PZPLOT.M)

QUANT.M		Exercise 10.3
  Returns the quantization of a vector.

II. Data files
----------------
CTFTMOD.MAT	Exercise 4.7
  A Morse code signal and the coefficients of a lowpass filter used to
  process this signal. 
  
DJIA.MAT	Exercise 6.6
  The weekly values of the Dow Jones Industrial Average over a period
  of approximately 94 years.

LINEUP.MAT	Exercise 2.10
  The speech signal of the phrase "line up" with an echo added. The
  signal is sampled at 8192 Hz.

ORIG.MAT	Exercise 7.3
  A speech signal sampled at 8192 Hz.

ORIG10K.MAT	Exercise 7.3
  The speech signal of ORIG.MAT sampled at 10240 Hz.

ORIGBL.MAT	Exercise 8.3
  The speech signal of ORIG.MAT bandlimited to 1000 Hz.

PHDIST.MAT	Exercise 6.4
  A noise corrupted version of the speech signal contained in
  ORIG.MAT, as well as the coefficients of three lowpass filters used
  to process this noisy signal. 

PLUS.MAT	Exercise 6.2
  A 32-by-32 element gray-scale image of the "plus" sign.

PROTOH.MAT	Exercise 6.3
  The impulse response of an approximation to an ideal lowpass filter
  with cutoff frequency pi/5.

ROAD.MAT	Exercise 6.1
  A signal mimicking the contour of a road surface.

TOUCH.MAT	Exercise 5.2
  Telephone numbers encoded with the signals used by touch-tone
  telephones. 



MathWorks Disclaimer: These files are User Contributed Routines which
are being redistributed by The MathWorks upon request, on an "as is"
basis. A User Contributed Routine is not a product of The MathWorks,
Inc. and The MathWorks assumes no responsibility for any errors that
may exist in these routines.

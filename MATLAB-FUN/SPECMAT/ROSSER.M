function R = rosser();
%ROSSER	A classic symmetric eigenvalue test problem.
%	This matrix was a challenge for many matrix eigenvalue algorithms.
%	But the Francis QR algorithm, as perfected by Wilkinson and 
%	implemented in EISPACK and MATLAB has no trouble with it.
%	The matrix is 8-by-8 with integer elements.
%	It has:
%	    * A double eigenvalue.
%	    * Three nearly equal eigenvalues.
%	    * Dominant eigenvalues of opposite sign.
%	    * A zero eigenvalue.
%	    * A small, nonzero eigenvalue.

%	C. Moler, 6-22-91.
%	Copyright (c) 1984-94 by The MathWorks, Inc.

R  = [ 611.  196. -192.  407.   -8.  -52.  -49.   29.
       196.  899.  113. -192.  -71.  -43.   -8.  -44.
      -192.  113.  899.  196.   61.   49.    8.   52.
       407. -192.  196.  611.    8.   44.   59.  -23.
        -8.  -71.   61.    8.  411. -599.  208.  208.
       -52.  -43.   49.   44. -599.  411.  208.  208.
       -49.   -8.    8.   59.  208.  208.   99. -911.
        29.  -44.   52.  -23.  208.  208. -911.   99.];

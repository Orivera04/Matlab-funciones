               NUMERICAL METHODS:
               MATLAB Programs
           (c) 1995 by John H. Mathews

                 To Accompany

               NUMERICAL  METHODS
            for Mathematics, Science,
                and Engineering
                Second Edition
               PRENTICE HALL, INC.
			   ISBN 0-13-624990-6
               ISBN 0-13-625047-5
          Englewood Cliffs, NJ 07632
               (c) 1992, 1987 by
                John H. Mathews
     California State University, Fullerton
         E-mail  in%"mathews@fullerton.edu"



   This free software is complements of the author.
It is permissible to copy this software for educational purposes, provided
that it is used with the textbook. The software may not be sold for profit and
may only be sold in such a way that the cost of reproduction are recovered.



                       PREFACE

  This disk contains numerical methods software coded in 
MATLAB.  The algorithms are described in the text NUMERICAL 
METHODS for Mathematics, Science, and Engineering.  
  A printed version of this material is titled 
"MATLAB Programming Guidebook for NUMERICAL METHODS."
  The author appreciates correspondence regarding both the
textbook and the supplements. You are welcome to correspond
by mail or electronic mail.

Prof.  John  H.  Mathews
Department of Mathematics
California State University Fullerton
Fullerton, CA  92634
(714) 773-3631
(714) 773-3196
FAX: (714) 773-3972
E-mail:  in%"mathews@fullerton.edu"

                    INSTRUCTIONS

1. For the PC version:  
    Move to the appropriate directory:  chap_1, chap_2, ... etc.

    For the Macintosh version:  
    Move to the appropriate folder:  chap_1, chap_2, ... etc.

2. All of the algorithms for the text have been coded in
    Matlab's programming language and stored as subroutines.  
    The example files for  chap_1  are named  a1_1.m, a1_2.m, ... etc.
    For Chapter 1 the examples are illustrations of the theorems.

3. The textbook discusses the following algorithm:

    Algorithm 11.1 (Power Method).
    Section	11.2, The Power Method, Page 557
    Assume that A is an n by n real matrix and that it
    has a full set of eigenvectors  V , V  ,..., V .
                                     1   2        n
    The power method of iteration is used to find the
    dominant eigenvalue and its corresponding eigenvector.

    To run the example for Algorithm 11.1 the user needs to use the script file 
    named a11_1.m.  This is accomplished by executing the Matlab command:

    a11_1 

4. The Matlab script in  a11_1.m  will call the subroutine named  power.m 
    which is included in the sub directory or folder named  chap_11.

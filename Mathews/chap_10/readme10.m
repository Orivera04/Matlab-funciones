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

    Algorithm 10.1 (Finite-Difference Solution for the Wave Equation).
    Section	10.1, Hyperbolic Equations, Page 507
    Finite difference solution for the wave equation
                          2
           u  (x,t)   =  c  u  (x,t)     with
            tt               xx
    u(0,t) = 0     and   u(a,t) = 0      for 0  t  b.
    u(x,0) = f(x)  and  u (x,0) = g(x)   for  0 < x < a.
                         t
    A numerical approximation is computed over the rectangle
                0  x  a ,   0  t  b.


    To run the example for Algorithm 10.1 the user needs to use the script file 
    named a10_1.m.  This is accomplished by executing the Matlab command:

    a10_1 

4. The Matlab script in  a10_1.m  will call the subroutine named  finedif.m 
    which is included in the sub directory or folder named  chap_10.
    Also, for the above example, the following function must exist as a 
    M-files named  f.m & g.m.

    function z = f(x)
    z = sin(pi*x) + sin(2*pi*x);

    function z = g(x)
    z = 0;

    For demonstration purposes, I have used a special Matlab feature which 
    opens and writes to a file to ensure that the above M-files f.m & g.m will exist
    in the proper sub directory or folder along with the script file a10_1.m  and
    function (subroutine) file  finedif.m.  These commands are:

    delete f.m
    diary  f.m; disp('function z = f(x)');...
                disp('z = sin(pi*x) + sin(2*pi*x);');...
    diary off;
    delete g.m
    diary  g.m; disp('function z = g(x)');...
                disp('z = 0;');...
    diary off;

5. Once the process of writing a function M-files has been mastered,
    it is not necessary to use the diary commands mentioned above 
    to create this function M-files named f.m & g.m.  The user can then
    delete these lines from the script file  a10_1.m.



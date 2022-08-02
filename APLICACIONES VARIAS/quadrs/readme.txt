    Below I present some new MATLAB programs for
  1-dimensional integration which I believe are faster,
  more reliable and more universal than those currently
  available. They are both vectorized in the best MATLAB
  sense while fully adaptive to local function behavior.
    There are two core routines:
  QUADR - integration of regular function (without
  singularities). It is accurate, fast and reliable.
  QUADS  in addition is designed to handle functions
  having singularities. It is capable to detect, analyze,
  report and if possible integrate "normal" singularities,
  such as poles of arbitrary order.
    Both functions can also conveniently accept expressions
  as well as function names.


Hello,

  A few weeks ago there was a good discussion of integration
of 1-dimensional functions in MATLAB. In particular it dealt
with integration of some functions with mild singularities
and some general limitations of MATLAB routines.

  Although QUAD or QUAD8 are capable of integrating most of
the "normal" functions, they can be slow, relatively
inefficient and unreliable in some cases. For example,
they can be confused by an ordinary periodic function:

>> quad('sin',0,210)
Recursion level limit reached in quad.  Singularity likely.
Recursion level limit reached in quad.  Singularity likely.
Recursion level limit reached in quad.  Singularity likely.
........

does not stand a chance, I had to stop it.
  The higher order routine QUAD8 is not running scared from a
long sinusoid; instead it happily returns after only 33
function evaluations with (of course) incorrect answer:

>> [Q,c]=quad8('sin',0,200)

Q =

  -96.5812

 c =

    33

(The QUAD can fail in a similar case much earlier).

  Another drawback is strictly local adaptiveness of QUAD*
routines (as it was already pointed out by Prof. Robert Riche).
They are trying to reach relative accuracy in every small
interval. Therefore they can waste time integrating something
tiny, like exp(-1/x) near 0, and even exceed recursion level,
although such a function is perfectly smooth and integrable.
  For example:

>> quad('exp',-10,0,[],1)

ans =

    1.0000

retuns a correct answer, but one can see that it
spends the same time evaluating integral in the
[-10 -5] interval as in [-5 0], while former is less than
1% of the latter, which is quite inefficient.

  Some people (one can try the Prof. Riche's ADAPQUAD.M or
toolbox NIT at The MathWorks FTP site) submitted their
replacements of QUAD* which are better in various respects.
However I haven't seen integration routines that will combine
two very important properties: be fully vectorized (and make a
small number of function calls) which is essential for speed
and at the same time be adaptive to a possibly complicated
behavior of evaluated function.


  I believe that such a fundamental mathematical operation
as quadrature in a general-purpose math package like MATLAB
should not just "usually work" but be as reliable, efficient,
and accurate as possible.

  Below I present my attempt to accomplish this goal.

  The functions QUADR and QUADS (for "regular" and "singular"
functions) are fully vectorized and conscious of "global"
properties (the function norm is estimated as mean of absolute
of all evaluated function values at each recursion level).
  At the same time they are fully adaptive to the local function
properties. At each recursion level the new points are entered
with a variable rate calculated from local accuracy estimates.

  One can easily see that QUADR does not have any problems
integrating a function with very many periods:

>> quadr('sin',0,2001*pi)

ans =

    2.0000


  Now let's try to integrate some relatively FLOP-intensive
function:
-----------
function y = quadfun(x)
y = bessel(0,x).*tanh(x+1).^1/3;
-----------

tic,[Q,c]=quad8('quadfun',1,200);toc

elapsed_time =

    7.2320

>> c

c =

   529

  QUADR does not even require a special m-file; it can accept
a string expression:

>> tic,[Q,x,y]=quadr('bessel(0,x)*tanh(x+1)^1/3',1,200);toc

elapsed_time =

    2.1548


>> length(x)

ans =

        1929


  One can see that in this case QUADR was about 3 times faster
than QUAD8 while performing about 4 times more function
evaluation. This is because it is fully vectorized and makes
just a few function calls (typically 3-5), with much longer
X vectors. More function evaluations make it more accurate
and robust: it is not going to be confused by a function with
many periods or miss narrow peaks and troughs.


  Functions can come in all shapes and forms and many of
them can have singularities. Some singularities are integrable
and in any case a good integration routine should be able to
find, analyze and possibly integrate them.
  For this purpose I suggest a separate function  QUADS.
It is similar to QUADR, just slightly slower and have additional
block for analyzing detected singularities.
  Let's have a look at how it works:

>> [Q,xo,fo,s] = quads('1/x',-1,2);
 Singularity at x = -0.000000, integrable in a principal value sense

  Check the accuracy:

>> Q/log(2)-1

ans =

  -1.1324e-06

(LOG(2) is a value of integral from 1 to 2. Integral from -1
to 1 is zero in a principal value sense).

  The additional output argument -  s  is "singularity matrix",
whose each column contains a description of each singularity
encountered:

>> s

s =

   -0.0000
    1.0000
    1.0000
   -1.0000
    1.0000
    2.0000

  In this case there is just one column. The first number is an
estimated singularity position, 2-nd and 3-rd are left and
right power indices and 4-th and 5-th are left and right
multipliers in an asymptotic aproximation  y(x) = b/(x-x0)^n.
The 6-th number is an inferred singularity type:
1-integrable, 2-integrable as a principal value,
3 - non-integrable, 4 - undetermined type.

  Let's try a function with several singularities of different
types:

>> [Q,xo,fo,s] = quads('1/sqrt(x)/(x-2)/(x-4)^2',0,5);
 Singularity at x = 0.000008, integrable
 Singularity at x = 2.000000, integrable in a principal value sense
 Singularity at x = 4.000000, non-integrable

  Now try a function which is not strictly polynomial or
rational:

>> [Q,xo,fo,s] = quads('x*tan(x)',0,pi*4);
 Singularity at x = 1.570796, integrable in a principal value sense
 Singularity at x = 4.712389, integrable in a principal value sense
 Singularity at x = 7.853982, integrable in a principal value sense
 Singularity at x = 10.995574, integrable in a principal value sense

One can easily check that singularities are at the points
pi/2, 3*pi/2, 5*pi/2, 7*pi/2:

>> s(1,:)/pi

ans =

    0.5000    1.5000    2.5000    3.5000


  Now let's see how accurately we calculated the integral
(in the principal value sense, of course):

>> Q

Q =

  -8.7111


  This integral can be divided into a sum of 4 integrals
over intervals [0 pi], [pi 2*pi] ...
Each of them can be expressed as a sum of integrals of
a simple TAN function which is antisymmetric over these
intervals and cancels in a principal value sense, and
a symmetric function  tan(x)*(x-pi/2), which is regular
So our original integral should be equal to 4 integrals
of this latter regular function:

>> [Q0,xo,fo,s] = quads('tan(x)*(x-pi/2)',0,pi,1e-6);
>> Q0

Q0 =

  -2.1776

 Check the accuracy:

>> Q/Q0/4-1

ans =

   8.4272e-05


  Pretty good.

  And now the package itself. It consists of two main functions
QUADR.M and QUADS.M and three auxillary ones: LININSRT.M,
QUAD3P.M, VICINITY.M.

  I hope you'll find it useful.

  Regards, Kirill


``````````````````````````````````````````````````````````
  Kirill Pankratov, Ph.D.

  Department of Earth, Atmospheric & Planetary Sciences,
  Massachusetts Institute of Technology
  Cambridge, MA, 02139

  kirill@plume.mit.edu
  Office (617)-253-5938
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

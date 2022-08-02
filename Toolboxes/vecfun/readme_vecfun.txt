Multivariable Calculus Toolbox Ver. 1.9
=======================================
Date: 2002-12-06.
Author: B. Rasmus Anthin.



WHAT IS IT
----------

This toolbox contains two classes for the moment: "scalar" and "vector". A
scalar object is a function of three variables in either Cartesian
(x,y,z), spherical (R,theta,phi) or cylindrical (r,phi,z) coordinates.
The constructor can be used in many different ways. It is adviceable to
first run "vecinit" in order to create some easy to use variables
(type "help vecinit" for more info).

If you have typed "vecinit cart" then you can use the three variable
objects x,y and z to create new objects lik this:

» f=sin(x+y)-z*y^2

     Scalar function:
     f(x,y,z) = sin(x+y)-z*y^2

Vector objects are 3D-vector functions of three variables, ie three
dimensional fields:

» H=[-y x 0]

will produce a "magnetic field" which can easily be plotted
by writing:

» H=setrange(H,[-2 2],[-1 1],[-1 1 2]);
» plot(H([],[],0))
» axis equal

This was a few samples of what you can establish with this toolbox. It is
designed so that it should be so simple to use as possible. The classes
saves both memory and time for you. Also your variable space will
not be as filled with variables as it was before.



INSTALLATION
------------

0. UNINSTALLATION: If you already have one of the earlier distributions,
then the best thing would be if you could remove the earlier archive and
then go proceed to the next step (2) below. To remove the archive simply
enter the "vecfun" directory and in Unix/Linux write "rm -rf". Please be
sure that you REALLY are in the current directory or else other valuable
files may be lost FOREVER! So use "rm -rf" with great caution!!! You
should not have any of your own files located in this directory if you are
running Matlab under Unix/Linux!
If you are running Matlab under Windows then use either "Windows
Commander" or the Windows built in "File Explorer" in order to delete the
earier installed archive.

1. Enter your matlab directory or the directory where you want to put the
toolbox.

2. Place the vecfun.#.#.tar.gz archive file in this directory.

3. Linux/Unix: Install by writing "gtar -xvzf vecfun.#.#.tar.gz" (you can
also use "gnutar" or "tar").
   Windows: Copy the entire archive to the directory using
Windows Commander available from "http://www.ghisler.com".
You should then end up with a file structure like this:
/vecfun/
  @scalar/
  @vector/
  demo/
  cplxread.m
  curl.m
  div.m
  findfunc.m
  grad.m
  index.m
  integral.m
  .
  .
  . etc... (25 m-files here)

4. Update your matlab path using the command "pathtool" or "editpath" if
you have not done this already.

If you would encounter any problems during the above steps, the please
contact me "e8rasmus@etek.chalmers.se" and I'll do my best to help you
through.



GETTING STARTED
---------------

It is highly adviceable to write "help scalar" and "help vector".
Try also to run the script "vectest.m" which contains a few examples.
Also try "help vecfun" for a full list of commands/functions to use.



UPDATES AND VERSIONS
--------------------

It should be noticed however that this is a beta version and that the
classes will still need some work with. This is my plans:

1. Complete the int() function.
2. Making an alternative for @scalar and @vector so that you can switch
   from room-coordinates to parameter "t", e.g. vector(t) or scalar(t)
   (scalar(t) will be the same as "scalar=inline('fun(t)','t')" but since
   it is a scalar object it will have access to all the tools and  
   functions available in the @scalar class). All in accordance to point 3.
3. Equip the function vector/plot with another feature 'curve' which will
   write space curves in three coordinates for vectors parametrisized
   with variable t (see point 2)
4. Maybe include a partial differential equation solver.

I think that would be all...

So there will be more updates coming that's for sure. Until next update,
have fun!!!


Ver 1.1:
I have fixed some bugs and added a new method for both of the classes,
called "resize" which enables you to easily set the number of points for a
certain function. A major change is that I have changed coordinates for
vectors in that way that each component of a vector function is translated
for that coordinate system. E.g.
» E=vector([0 4],[0 pi],[0 2*pi],'R+sin(theta)','cos(phi)','R*phi','sph')
will produce:
    E.R(R,theta,phi)     = ...
    E.theta(R,theta,phi) = ...
    E.phi(R,theta,phi)   = ...
instead of
    E.x(R,theta,phi) = ...
    E.y(R,theta,phi) = ...
    E.z(R,theta,phi) = ...
Also some heavy code "optimizations" have been performed in order to keep
the m-files as small (and elegant) as possible.

Ver 1.2:
Some bugs are fixed. You can now assign to separate vector components in
all possible ways, e.g. V.x=3+4*i-y*V.z . I have started out with the
correction of the differentiation tools like "curl", "div" and
"grad" etc. Will hopefully be finished out till next version.

Ver 1.3:
More bugs are fixed. Enhanced some functions also.
Have made an expression parser which purpose is to simplify string
expressions, e.g. simplify('1/(1*r*1)') gives '1/r'. But it isn't working
yet (the frontend is done but the backend is unfinished).

Ver 1.4:
I've almost completed the "int" function for the scalar class.
Simplified the plot functions: You no longer need to explicitly type
'2d', 'slice' and 'surf' as parameters to plot.
Fixed some bugs on the "strrepx" function and extended it (I have also
reprogrammed larger parts of its subroutines).
I have beautified the output from "curl", "grad" and "cross".
A new operator is added: "ctranspose" which will work as a
"differentiator".
I have also fixed some serious coordinate transformation bugs in both
the coordinate transformers and the arithmetic operators.
The plots are enhanced.

Ver 1.5:
Fixed some minor bugs. I have implemented plotting of constant vectors.
I have also changed the vector functions "abs" and "angle" (see help
for more info).
Entering values for all three parameters will not return numerics no
longer, for that you have to use the new function "value" on the
function.

Ver 1.6:
Fixed the bug in vector/mtimes that produces the wrong output for the
x-component. I have also implemented idexing by a vector function:
V(W) where both V and W are vector functions.
The vector/mtimes have been updated so that it will perform a vector
cross product if both operands are vector functions.
The new vector/times are now implemented which will work as the
"dot" function.
The cross product symbol has been enhanced in the case when
computer=='PCWIN'.

Ver 1.7:
Bug fixed; scalar/horzcat could not handle other objects than scalar
objects.

Ver 1.8
Bugfix; texstring now compensates for eta-character properly and removed
statements with strrepx which I don't remember why I implemented.
scalar/lapl was having a statement with "1/(h1*h2*h3)(*..." which I instead
changed into "1/(h1*h2*h3)*(...". scalar/lapl also contained the string "Lapl"
which wasn't properly interpreted by texstring, thus changed it to "lapl".

Ver 1.9
Enhanced the "pdiffev" function; using "gradient" function rather than
doing it the hard way.
Changed the look of the output for the differentiating operators slightly.
It seems like UNIX supports superscripted 2 and 3 and the "cdot" character
and the "times" character, so i commented the lines testing if it is PC or
not. However if you experience problems then just restore the commented
lines around the lines containing "char(...)" ..something.


EOF.

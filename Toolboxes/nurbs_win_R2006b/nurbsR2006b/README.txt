                     NURBS toolbox for MATLAB
                     ========================
                           Version 1.0
                           ===========

The NURBS toolbox is collection of routines for the creation, and
manipulation of Non-Uniform Rational B-Splines (NURBS). NURBS have
to some extent become the de facto industry standard for representing
complex geometric information in CAD, CAE and CAM, and are an integral
part of many standard data exchange formats such as IGES, STEP and PHIGS. 

For a detailed explanation of NURBS and how to manipulate them, I can
strongly recommend the book by Les Piegl and Wayne Tiller called 'The NURBS
Book' ISBN 3-540-61545-8. Please note that the 'C' code algorithms is this
library are modified versions of the pseudo-code within the book.

Contributions to the library
============================

Thanks to Bill Lionheart for compiling the mex files for Windows, and
Solaris.

Installation
============

To Install this library:

Which ever platform you use two options are available:

   - unzip or untar the nurbs toolbox to the directory matlab uses
     to store all the standard toolboxes:

           .../matlab/toolbox

     and add the path to the file:

           .../matlab/toolbox/local/pathdef.m 

     like:

           matlabroot,'/toolbox/nurbs',...

   - unzip or untar the nurbs toolbox to a convenient directory in your
     own workspace and add the path to a startup.m file with the addpath
     command (see matlab documentation). 

Contents
========

The directory contains matlab script files and mex files. We have compiled
the library successfully on Linux, Windows and Solaris and the precompiled
mex files are included for these platforms.

All the nurbs routines are prefix with 'nrb' to differentiate them from 
any other similar sounding matlab script files by other authors. The 
data structure used to represent the NURBS is compatible with that used
in the 'Splines Toolbox' by C. de Boor and The MathWorks, Inc and can
be manipulated as four dimensional univariate or multivariate B-Splines.

The demonstration programs all start with the prefix 'demo' and can all
be run separately. I have also included a demo script that uses matlabs
demo routines type:

             demos      (in matlab and choose the nurbs toolbox)

Documentation
=============

Currently the only documentation is the matlab help files type:

               help nurbs               (in matlab)

and the short description of each function at the beginning of each
library function and the demonstration examples type:

               demos                    (in matlab and choose nurbs)

I will produce a manual sometime in the future when I have the time.

License
=======

All the software within this tool is covered by the GPL Version 2 license
which is stated in the file 'LICENSE'.

APPLICATIONS
============

I've developed this library for my own research work and as apart of a 
larger collaborative project called EIDORS (http://www.ma.umist.ac.uk/bl
/eidors/). If you find a useful application this software, have suggestions
for improvements, or bug reports please let me know.

Happy NURBS'ing.

Mark Spink
dmspink@aria.uklinux.net  













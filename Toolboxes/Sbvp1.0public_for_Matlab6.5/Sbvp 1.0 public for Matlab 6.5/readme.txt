The Matlab SBVP-package (Version SBVP 1.0 for Matlab 6.5 - Release 1/2003)

TABLE OF CONTENTS
*) Problem setting
*) Installation
*) Files in this package
*) About the package and the underlying algorithm
*) Getting acquainted
*) Hints for troubleshooting
*) Release History
*) Contact

***********************************************************************
***********************************************************************

Problem setting

The SBVP-package contains functions for solving boundary value 
problems for systems of nonlinear ODEs of first order,

    y' = f(t,y) , t \in (a,b) , R(y(a),y(b))=0.

The right hand side of the differential equation may contain a singularity
of the first kind, that is 

    f(t,y) =  1/(t-a) * M(t) + g(t,y),

where M is a matrix which depends continuously on t and g is a smooth function.

***********************************************************************
***********************************************************************

Installation

Create a directory for the SBVP-package and unzip SBVP.zip into this
directory. Then add it to the Matlab search path. This is done by
inserting the line

addpath('The full path of the directory you created');

into the Matlab startup-file startup.m. You can locate this file by
typing 

>> which startup

at the Matlab command line.

If no startup-file exists, you should create one in

  ...\Matlab\toolbox\local (Windows systems) 

or

  your own Matlab directory, e.g. /home/username/matlab (Multiuser systems)
 
Now add search paths for the subdirectories OUTPUTFUNCTIONS and DEMO, too.
When you call 'startup' or restart Matlab all SBVP functions will be
available.

***********************************************************************
***********************************************************************

Files in this package

SBVP             driver routine (adaptive mesh selection) 
SBVPCOL          collocation solver (fixed mesh) 
SBVPSET          tool for setting solution options
SBVPERR          error estimation routine (private to SBVP)

SBVPPLOT         output routine 
SBVPPHAS2        output routine 
SBVPPHAS3        output routine 

DEMOFILE1 - 6    demo-files

SBVP_DOC.PDF     detailed description of the package

***********************************************************************
***********************************************************************

About the package and the underlying algorithm

The package provides a mesh adaptation routine based on collocation with
piecewise polynomials for the solution of two-point ODE-boundary value
problems.
Meshes are  selected according to the smoothness of the solution 
(rather than to the smoothness of the direction field). 
The mesh selection is based on a new, global error estimate for collocation 
schemes, which has recently been developed at our Institute and proves robust 
with respect to the singularity (see also SBVP_DOC.PDF).

***********************************************************************
***********************************************************************

Getting acquainted

* Read SBVP_DOC.PDF or the help texts of SBVP and SBVPSET to 
  understand how to use the package.

* Look up and run the DEMOFILEs.

***********************************************************************
***********************************************************************

Hints for troubleshooting

If you encounter troubles solving your own problems, here is a checklist
you might want to follow.

* Check if the problem was formulated correctly, i.e. whether
  the file containing the problem formulation returns correct outputs.
  
* If you do not find any errors, solve the problem with 'CheckJac' set to 1
  (See SBVPSET if you do not know how to do this).
  The analytic derivatives you supplied will be compared
  with a finite difference approximation of these derivatives.

* Furthermore, if the problem is nonlinear, you might 
  get a better understanding of what is going wrong if you set the 
  zerofinder Display to 'iter' (see SBVPSET and OPTIMSET if you don´t 
  know how to do this). This provides some information about the zerofinding 
  process.

* Try to find a better initial approximation. 

* Check if your problem is well-posed, i.e. if there exists a solution
  of the analytic problem that is locally unique and depends continuously 
  on the problem parameters. 

***********************************************************************
***********************************************************************

Release History

* 1/2003 Release for Matlab 6.5
    * Adaptation to new handling of empty matrices in Matlab 6.5
    * Improved mesh selection strategy
    * Fix of a bug in the error estimation routine
    * New status messages for more convenient debugging of bvpfiles

* 6/2001 Initial Release for Matlab 6.1

***********************************************************************
***********************************************************************


Contact

Guenter Kneisl
email: eomer@gmx.at
URL: http://connect.to/eomer

or

Winfried Auzinger 
email: w.auzinger@tuwien.ac.at
URL: http://www.math.tuwien.ac.at/~winfried/

Othmar Koch
email: othmar@fsmat.at
URL: http://fsmat.at/~othmar/

Ewa Weinmueller
email: e.weinmueller@tuwien.ac.at
URL: http://www.math.tuwien.ac.at/~ewa/

All:
Department of Applied Mathematics and Numerical Analysis
Vienna University of Technology
Austria
URL: http://www.anum.tuwien.ac.at

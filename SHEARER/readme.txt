All M-files are copyrighted, 1997 by John F. Gardner.

These M-files are User Contributed Routines that have been contributed 
to the MathWorks, Inc. and which are being redistributed by the MathWorks,
upon request, on an "as is" basis.  A User Contributed Routine is not
a product of the MathWorks and The MathWorks assumes no repsonsibitility 
for any errors that may exist in the toolbox.

These files were written for Version 4.2c1 of MATLAB and 1.3c of SIMULINK.  
All files were subsequently tested under Version 5.0 of Matlab and 2.0 of 
SIMULINK and they were found to work as expected.  A few of the files will
generate warning messages under MATLAB 5.0, but they operate properly. 

While the files weren't tested extensively with the Student Edition of MATLAB,
it is anticipated that there will be no problem with it.  

No other toolboxes (other than SIMULINK) are required for these files.

Summary by chapter of files for "Dynamic Modeling and Response of Engineering
Systems, 2nd ed." by Shearer, Kulakowski and Gardner. Those files marked with an
asterisk (*) are utility files, called by the other files and not intended for 
direct access.

Chapter 1:

lin1.m
*plotnl.m

These files generate a GUI to allow the student to explore the issue
of linearization.  A cubic is ploted and the student chooses a point
on which to draw a tangent line. Then the student chooses an error
tolerance an the program draws lines indicated the range over which 
the linearization meets the tolerance.

Chapter 3:

step1.m
step2.m 
*plotit.m
*sorder.m
*forder.m

The first two files (step1 and step2) create a GUI to allow the student
to explore first and second order step responses. (No prizes for figuring
out which is which).

Chapter 5:

eulmeth.m 	Table 5.1 (Euler's method integration)
rkmeth.m	Table 5.4 (Runge-Kutta)
Meuler.m	Table 5.6 (Euler for multiple equations)

Chapter 6:

fig6_1.m	SIMULINK model in Figure 6.1
fig6_3.m	SIMULINK model in Figure 6.3
fig6_6.m	SIMULINK model in Figure 6.6
fig6_11.m	SIMULINK model in Figure 6.11
fig6_14.m	SIMULINK model in Figure 6.14
desnub.m	Table 6.3, script for snubber design,generates Fig 6.15
fsnub.m		Table 6.2, function to compute snubber force

Chapter 15:

ex15_1.m	MATLAB script to implement the solution of
		example 15.1


Matlab scripts and functions.

[*** To read this file, first select Word Wrap in the Edit menu ***]

These M-files are User Contributed Routines which are being redistributed 
by The MathWorks, upon request, on an "as is" basis. A User Contributed 
Routine is not a product of The MathWorks, Inc. and The MathWorks assumes no 
responsibility for any errors that may exist in these routines.

These M-files are supplied as an additional help to purchasers of the book: 
"Numerical Methods using Matlab, 2nd Edition". 

They allow the user to experiment with the relatively small examples given in 
the book and also apply the functions to the solution of similar problems 
they have developed themselves and which may have real applications. 
However, it must be stressed that the functions, as presented, may not be the 
most reliable or robust implementation of the methods involved nor can they 
be guaranteed to provide the solution of large scale problems. We hope they 
will provide a useful support for the learning process and allow 
experimentation. 

The scripts and functions are arranged in three folders as follows: 

Folder na_funcs
This folder contains the main functions listed in appendix 2 of the book. The 
comments at the beginning of each function and can be accessed as normal 
using the Matlab help command. 

Folder na_scripts
This folder contains the scripts given in the book. The name of a script 
consists of the characters e2pg followed by the 3 digits corresponding to the 
page number where the script occurs in the book. If there are two scripts on 
a page the letter a or b is added to the end of the script name. 

Folder f_funcs
This folder contains the mathematical functions that are called by the 
numerical method functions and scripts. 

THE FUNCTIONS AND SCRIPTS IN THIS DISK DIFFER FROM THOSE GIVEN IN THE CURRENT 
VERSION OF THE BOOK IN THAT THE FOLLOWING MODIFICATIONS HAVE BEEN MADE: 
Page 22: In the script e2pg022, the superfluous characters: 
h= 
have been removed from the last line. 
--------- 
Page 144: The function solveq has been modified. The line: 
r1=-a1; im1=0; 
has been changed to 
r1=-a1; im1=0; r2=0; im2=0; 
--------- 
Page 238: The script e2pg238 has been modified by inserting: 
global a 
at the beginning of the script. 
--------- 
Page 240: The script e2pg240 has been corrected to use: 
gallery('rosser') 
replacing the erroneous gallery(8). 
--------- 
Page 276: In the script e2pg276, the line: 
om(1:5); mesh(a) 
has been replaced by: 
om(1:5), mesh(a) 
to allow the eigenvalues to be output. 
--------- 
Page 323: In the script e2pg323, the statement: 
al=zeros(2,11); 
has been replaced by: 
al=zeros(2,15); 
The calculation of yy has been changed to 
yy=b(1)*sin(1./(xx+0.2))+b(2)*xx; 
--------- 
Page 328: The following changes have been made to the last four lines of the 
function lfit: 
yp1=b1*xp.^a1; yp2=b2*exp(a2*xp); 
plot(x,y,'ko',xp,yp1,'k',xp,yp2,'k:') 
xlabel('x') 
ylabel('f(x)') 
--------- 
Pages 353 and 354: There are inconsistencies between the script e2pg353, its 
ouput, the data in script e2pg354 and the plot in Figure 8.4.2! This has 
arisen because each of these has been accidentally taken from a different 
execution of the script with different initial conditions and tolerances. To 
obtain a consistent example the following modifications must be made:
In e2pg353 make: 
x0=[1 0.5]'; 
The script will now produce an output very close to that shown on page 353.
In e2pg354 make: 
x1=[1 2.8121 -2.8167 -2.9047 -2.9035]; 
y1=[0.5 -2.0304 -2.0295 -2.9080 -2.9035]; 
These data points are consistent with the iterative steps taken in the 
revised version of e2pg353. Running e2pg354 generates a new Figure 8.4.2. A 
new search path is plotted. 
--------- 
Page 394: The script e2pg394 has been modified to make the scalar 
substitutions rather than a vector substitution in the Matlab function subs. 
--------- 
Page 408: the script e2pg408 calls the function f519. This function was not 
defined. It has now been renamed f901 and is defined as follows: 
function fv=f901(t,x) 
fv=zeros(2,1); 
fv(1)=x(2); 
fv(2)=3*t-4*x(1); 
---------

OTHER COMMENTS AND WARNINGS
It is advisable to use the Matlab statement, clear, at the start of scripts 
and at the beginning of interactive sessions to clear arrays and to reset 
pre-defined special values. For example running the script e2pg112a gives 
erroneous results if i is not set to the square root of -1.
Execution times and flops will vary from machine to machine due to machine 
processing speed, software implementation or both. A partcularly striking 
example is the output of script e2pg094 where the number of flops quoted in 
the book was determined on a Macintosh. However, PCs give a very different 
result. Similarly we get a significantly different result in the output of 
the script e2pg163 on different machines. Although this result is expected to 
be heavily in error (as explained in the book) it is interesting that the 
actual results are not even of the same sign.
Page 189: In some implementations, warning messages are output from the 
Matlab function quad8. The results however, are not effected.
Page 193: The script e2pg192 exceeds the Student Edition array size 
restriction. Executes correctly only up to and including n=64.
***WARNING***

Although every effort has been made to avoid errors in the scripts and 
functions the authors cannot guarantee this and cannot be responsible for any 
loss incurred in using them.

George Lindfield & John Penny.
For further information, contact
Dr J E T Penny 
School of Engineering and Applied Science 
Aston University 
Aston Triangle 
Birmingham B4 7ET 
UK
e-mail: j.e.t.penny@aston.ac.uk

Nov 1999.
FOR USERS OF THE FIRST EDITION OF Numerical Methods in Matlab.
If you are using the 1st edition of this book you must use this disc with 
care!! (There was a disc specifically designed for use with the 1st edition). 
The scripts and functions in the 1st edition were written for Matlab 4. 

NA functions
Many of these are the same as in the 1st edition but a small number are new 
and some have been modified to work in Matlab 5 and will not work in Matlab 
4. For example, look carefully at the differences in the functions used to 
solve ordinary differential equations. A small number of functions that are 
in the 1st edition have been dropped from the 2nd edition. 

f functions
The same as the first edition, with some additions.

scripts. 
In both editions, scripts are named by the page on which they are printed. 
Whilst many of the scripts are identical to those of the 1st edition they are 
on a different page in the 2nd edition and therefore have a different name. 
For example, script e2pg111.m in the 2nd edition is the same as the script 
page79.m in the first edition. This will be clear to the reader on comparing 
equivalent scripts.





README.TXT  Advanced Engineering Mathematics using MATLAB
   by Harman, Dabney, Richert - Version 5 Update to disk files 
   April 1998

Contact:
Thomas L. Harman
harman@cl.uh.edu

The M-files on the disk were created using the Student Edition
of MATLAB, Version 5. 

Some scripts require the Symbolic Math Toolbox.


From the MATHWORKS:
These M-files are User Contributed Routines which are being
redistributed by The MathWorks, upon request, on an "as is" basis.
A User Contributed Routine is not a product of The MathWorks, Inc.
and The MathWorks assumes no responsibility for any errors that
may exist in these routines.


CONTENTS:
1. INTRODUCTION

2. MATLAB FILES

	MATLAB DISK DIRECTORIES

	MATLAB DISK FILES

	USE OF THE SCRIPTS

	INVENTORY OF MATLAB DISK FILES

%---------------------------------------

1. INTRODUCTION:
These disk files are Version 5 MATLAB files for each chapter of
the textbook. In general, the MATLAB files contain the scripts
that created the examples in the book and scripts that are 
answers for the Reinforcement Exercises.

2. MATLAB FILES
This disk contains MATLAB scripts for all the examples that use
MATLAB and also scripts for the answers to Reinforcement Exercises
that lend themselves to MATLAB solution. These scripts were 
developed using the Student Edition of MATLAB, Version 5, 
on a computer system using Windows. In some of the scripts,
a comment indicates the changes from the version 4 script. 

WARNING: Execution of the files with another version of MATLAB or 
another operating system may lead to error messages. If this occurs, 
please consult the MATLAB User's Guide for the version you are using.
Usually, the problems can be resolved by modifying the scripts
appropriately. 

Please read the comments in a script. Usually, the comments indicate 
any special requirements and other functions that may be called. 
For example, some of the scripts require the Symbolic Math Toolbox.
These scripts will not work with the professional version of MATLAB
unless the toolbox is available. 

Users with a Unix-based system may have problems with some of the
naming conventions allowed by DOS or Windows. MATLAB is case
sensitive for naming of variables but not for disk files. 
Some operating systems may use case sensitive naming for files.      

MATLAB DISK DIRECTORIES:
The disk has a directory that contains two subdirectories 
for each chapter except Chapter 4. The directory structure
 is as follows:
ch01
 clflch1
 ansch1
ch02
 clflch2
 ansch2
  .
  .   

The subdirectories are as follows:

1. clflchn (n=1, 2, ..., 13) contain the MATLAB files that created
MATLAB examples in the text. The prefix "clfl" means Clear Lake 
Files with the name reflecting the fact that these files were
created near Clear Lake in Houston where our university is located. 
   
2. anschn (n=1, 2, ..., 13) contain MATLAB files that are answers
to the Reinforcement Exercises that require MATLAB scripts or problems
for which MATLAB scripts are helpful. 

MATLAB DISK FILES:
The M-files (.m) are executable by MATLAB. The prologue comments
in the script explain the purpose and use of the script. Diary 
files (.dir) are for information only. They may be displayed
but not executed. A file such as clex95.mat is a data file.

The files in the clflchn directories that are M-files from the 
examples generally have the prefix EX. In a few cases, diary files
(.dir) and M-files that answer What If? questions are included.
Files are occasionally given names that reflect the purpose of the
script such as SINSQ.M which returns the square of the sine of a
variable. Those files with a CL (Clear Lake) prefix are so
named to avoid conflict with M-files provided with MATLAB or 
to indicate that the script solves a problem of a more general
nature and thus may be useful in various applications.     

The files in the anschn directories mainly are solutions 
to Reinforcement Exercises that require MATLAB programs. 
These files generally have the prefix P. In a few cases,
a MATLAB script is given for another exercise. In some cases,
the file is named to indicate the purpose of the script or
the prefix CL is used when the file contains a function.

USE OF THE SCRIPTS:
We attempted to design the examples in this book with the motto
``The purpose of computing is insight, not numbers'' in mind. 
This is the motto from R.W. Hamming's book Numerical Methods
for Scientists and Engineers, McGraw-Hill, Inc. Also, the 
MATLAB scripts are written with clarity as the primary goal. 
Therefore, it is intended that the reader modify and improve
the scripts in some cases, particularly with respect to the
efficiency of the program in solving a specific problem. 

Please read the prologue comments and the comments in the 
program carefully before using a script. When executing a script,
it is useful to execute the script with the ECHO ON option
which displays each statement as it executes. Occasionally, 
comments are added at the end of a script to suggest 
modifications and improvements.

% -----------------------------------------------------------------

INVENTORY OF MATLAB DISK FILES

Chapter 1
CLFLCH1: ex1_5.m ex1_6.m ex1_7.m ex1_8.m ex1_9.m quadrat.m  
         clxfunct.m         
ANSCH1:  p1_1.m p1_2.m p1_3.m p1_10.m p1_4.m p1_5.m p1_6.m p1_7.m 
         p1_8.m p1_9.m pfun.m triratio.m 
% -----------------------------
Chapter 2
CLFLCH2: ex2_15.m sinsq.m clbindec.m 
ANSCH2:  p2_16.m p2_17.m p2_18.dir p2_19.m p2_20.dir p2_21.m    
         fnuvec.m fcross.m  foct2dec.m  
% -----------------------------
Chapter 3
CLFLCH3: clcondno.m clxrotz.m  clxrotzf.m ex317wif.m   
ANSCH3:  p3_19.m p3_20.dir p3_21.m p3_22.m p3_23.dir p3_24.m  p3_25.m     
         p3_26.m p3_27.m  p3_28.m is_sqr.m is_sym.m  vrot.m   
% -----------------------------
Chapter 4
CLFLCH4: ex4_2.m ex4_3.m ex4_4.m ex4_5.m ex4_6.m ex4_7.m ex4_9.m 
         ex4_10.m ex4_11.m ex4_12.m ex4_13.m ex4_14.m ex4_15.m 
         ex4_18.m clmodal.m %
 -----------------------------
Chapter 5 
CLFLCH5: ex5_1.m ex5_2.m ex5_3.m ex5_4.m ex5_5.m ex5_5.dir ex5_7.m 
         ex5_7.dir ex5_8.m ex5_9.m ex5_9.dir ex5_10.dir ex5_11.m
         ex5_11.dir ex5_12.m ex5_12.dir ex5_14.m ex5_14.dir 
         ex5_17.m ex5_18.m cl2ordf.m cldesf.m cl2ord.m cl2ord.dir
         whatif5_1.m whatif5_1.dir             
ANSCH5:  p5_2.m p5_3.m p5_5.m p5_14.m p5_15.m p5_16.m p5_17.m p5_18.m
         p5_19.m p5_19.dir mx3ordf.m    
% ---------------------------
Chapter 6
CLFLCH6: ex6_6.m ex6_7.m ex6_13.m ex6_13.dir ex6_16.m ex6_16.dir
         cl2ordpf.m cl2ordp.dir clrk4.m clrk4pj.m 
         clprojex.m clrk4ex.m cl2ordp.m clprojf.m clrk4exf.m    
ANSCH6:  p6_4.m p6_7.m p6_16.m p617f.m p6_17.m p6_18.m p6_19.m p6_20.m 
         p6_21.m p6_22.m p6_23.m p6_23.dir p6_24.m p6_25.m bes2f.m 
         efunc.m 
% ---------------------------
Chapter 7
CLFLCH7: ex7_1.m ex7_2.m ex7_3.m 
ANSCH7:  p7_1.m p7_2.m p7_3.m p7_4.m p7_9.m p7_10.m p7_11.m p7_12.m     
% -------------------------
Chapter 8
CLFLCH8: ex8_2.m ex8_10.m ex8_12.m ex8_14.m clptdscf.m clspec2.m        
         clspec1.m        
ANSCH8:  p8_16.m p8_17.m clptdscf.m  
% ----------------------------------------
Chapter 9
CLFLCH9: ex9_3.m ex9_5.m clex95.mat clfex91.m clfex91b.m     
         clex95dt.m clfex91a.m clfftf.m       
ANSCH9:  p9_4.m p9_6.m p9_7.m p9_8.m p9_9.m 
% ----------------------------------------
Chapter 10
CLFLCH10: ex10_1.m ex10_7.m  clint2d.m  clplot2.m     
..        clopt.m  clpolydv.m    
ANSCH10:  p10_15.m p10_16.m p10_16.dir p10_17.m p10_18.m 
% ----------------------------------------
Chapter 11
CLFLCH11: ex11_2.m ex11_4.m 
ANSCH11:  p11_17.m p11_18.m 
% ----------------------------------------
Chapter 12
CLFLCH12: ex12_8.m  exfflow.m 
ANSCH12:  p12_16.m  p12_30.m  p12_30.dir p12_31.m p12_31.dir
          p12_32.m  p12_32.dir
          arclenf.m normdist.m      
% ----------------------------------------
Chapter 13
CLFLCH13: ex13_3.m 
ANSCH13:  p13_12.m p13_13.m 
%--------------------------------------------------------------------------

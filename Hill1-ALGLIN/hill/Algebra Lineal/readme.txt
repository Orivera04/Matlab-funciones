                      Linear Algebra LABS Toolbox

                      By: David R. Hill
                            Mathematics Department 
                            Temple University

An M-file supplement for MATLAB to accompany Linear Algebra LABS
with MATLAB, Second Edition, by D. Hill and D. Zitarelli, Prentice
Hall, Upper Saddle River, New Jersey, 1996.

The instructional M-files on this diskette are designed to harness
the power of MATLAB so students can interact with the software in
a way that requires no programming and only basic MATLAB commands.
These M-files provide instructional tools for the student that
focus on the development of conceptual linear algebra skills.

The names of the M-files are listed below and give an indication
of their purpose. More detailed information is supplied by the 
help facility imbedded in each routine. Once these routines have
been copied to your computer system, to obtain detailed 
information on an M-file in MATLAB type help name, where name is
the name of the M-file. (See also file alldesc.txt which is on 
the disk.)

                     Instructional M-files

             doctor            lsqline            rowech
             dotprod           m1500run           rowop
             evecsrch          mapcirc            rrefquik
             gschmidt          matdat1            rrefstep
             highjump          matdat2            rrefview
             homsoln           matops             symrowop
             igraph            matvec             symrref
             invert            modn               uball
             lincombo          planelt            vaultlsq
             lineexp           project            vizrowop
             lisub             projxy             w100dash
             longjump          rational           w100free
             lsqgame           reduce

          Utilities: mat2strh, findcomh.m, symelemh.m, 
                     symenth.m, symsizeh.m

We suggest that these M-files be put into their own subdirectory
(or folder), possibly named LABBOX, and that the name of the
subdirectory be added to the MATLAB path. (See your MATLAB manual
for directions on altering the MATLAB path or the suggestion 
given at the end of this document.)

General note: These M-files were developed for MATLAB 4.2 for 
Windows. However, they are compatible with other platforms when
converted to the file structure of the platform.

The M-files included on this diskette can be used on stand-alone
machines or mounted on a network file server. (Copies can be given
to students for their own use.) You may modify these files as long
as you acknowledge the original authorship. These files and any
modifications are not to be sold. Permission from the author must
be requested before inclusion in other works is permitted.

The author, The MathWorks, Inc., and Prentice Hall
make no warranty of any kind, expressed or implied, with regard to
the programs (M-files) or the documentation contained herein. The
author, The MathWorks, Inc., and Prentice Hall shall
not be liable in any event for incidental or consequential damages
in connection with, or arising out of, furnishing, performance, or
use of these programs.

Address any questions, comments, or suggestions to

        Dr. David R. Hill
        Mathematics Department 038-16
        Temple University
        Philadelphia, Pa. 19122
        215-204-1654
        hill@math.temple.edu
        davehill@vm.temple.edu

March 1996

<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

         Suggested Installation of Linear Algebra Files 

Make a subdirectory in your \matlab subdirectory called labbox.

Copy the contents of the diskette into \matlab\labbox.

Now you need to set the path that MATLAB uses to find files.
That path is in a file called matlabrc.m

Get into MATLAB

Select the File pull-down menu.

Select Open m-file.

   > Find the matlabrc.m file and open it up.

   > Scroll down until you see the matlabpath statement and go to
     the end of it.

   >We want to add a line to this statement.
    After the last line, but before the  ]);
    type   'c:\matlab\labbox',...

    or a line that gives the full path to the subdirectory
    you stored the linear algebra files in.

   > Now go to the File pull down menu in Notepad 
     (or whatever editor you are using)and select Save.

   > Exit your editor.

   > In MATLAB type command matlabrc to reset the path you just
     defined.
     
   > To check things, type path in MATLAB. You should see that 
     subdirectory \labbox is in the path displayed. 
     If not, carefully repeat the above procedure.

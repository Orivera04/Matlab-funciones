-README.TXT 
  
   Numerical Analysis and Graphic Visualization Toolbox
   Version 2.0 
   (Updated and tested with both MATLAB 4 and MATLAB 5)

   Prepared by S. Nakamura
   	Version 1.0  November 24, 1995
   	Version 2.0  September 15, 1997

   Mailing address:
	Professor Shoichiro Nakamura
	Dept. of Mechanical Engineering
	The Ohio State University
	206 West 18th Avenue
	Columbus, OH  43210-1107
	USA

	fax      614-292-3163

   The M-files in this Toolbox are User Contributed 
   Routines which are being redistributed by The MathWorks, 
   upon request, on an "as is" basis.  User Contributed 
   Routines are not products of The MathWorks, Inc.
   The MathWorks assumes no responsibility for any errors 
   that may exist in these routines.

This note includes the following material:

[2] Alterations of M-file and data names
[3] File names of lists in the book
[4] Commands to reproduce figures in the book

All the M-files in this disk have been updated and tested
with both MATLAB 4 and MATLAB 5.

Answer keys for the exercise problems in the book may
be found in anskey.txt

-----.-----.-----.-----.-----.-----.-----.-----.-----.-----.-----
[1]  HOW TO USE THE M-FILES IN THE DISK

  Create a new folder in an appropriate directory of the hard disk.  
Copy all the files from the disk to the disrectory.  We now assume 
your directory is named, for example, d.nmtool in d.xxx in drive 
c:, namely

	c:\d.xxx\d.nmtool

After copying all the files, unzip the files.  The procedure is 
explained in readme in the main directory of the disk. 

  When you open MATLAB, set

>>path(path,'c:\d.xxx\d.nmtool')

then, you can run any m-files copied from the disk from your MATLAB 
command window.



[2] ALTERATIONS OF M-FILE AND DATA NAMES

  The following M-file and data names in the disk  
have been changed:

   car_da  -> car_.dat
   cell_da -> cell_.dat
   func1   -> func1_.dat
   func2   -> func2_.dat
   GC_interp.m   -> gc_inter.m
   human_capt.m  -> human_c.m
   human_captf.m -> h_captf.m
   kids1.m  -> kids1_.m       (Use also kids2_.m)
   point_da -> point_.dat
   phi_da   -> f_.dat
   resistor_.m -> resist_.m
   stream_da   -> stream_.dat
   vort_da     -> vort_.dat
   wing_2d.m   -> wing_.m   (used in plane_.m See List B.4)

  On the unix system, all commands and M-file names should be
typed in lower case even when capital letters are used in the 
M-file and data names in the book. For example:
   
   Lagran_  -> lagran_
   Cheby_pw -> cheby_pw
   Newt_n   -> newt_n
   GuiDm_1  -> guidm_1

[3] FILE NAMES OF LISTS IN THE BOOK
  
  The M-file name of List x.y (where x is the chapter 
number and y is the list number) is Lx_y.m where "L" must be 
typed in lower case for unix computers.
  Most Lx_y files are executable.  They can be executed
simmply by typing Lx_y as a command.  The M-files under 
FM numbers in the back of chapters are found by the 
original name unless it has been changed. See Section [1]
for possible changes.


[4] COMMANDS TO PLOT FIGURES OF THE BOOK

("L" must be typed in lower case for unix computers.)
-----------------------------------------------------------
Figure          Commands
-----------------------------------------------------------
Figure 2.1      f2_1    L2_1 or L2_2  
Figure 2.2      f2_2    L2_3    
Figure 2.3      f2_3    L2_4   
Figure 2.4      f2_4    L2_1 or L2_2 and use axis('square')  
Figure 2.5      f2_5    L2_5  
Figure 2.6      f2_6    L2_6   
Figure 2.7      f2_7    L2_7  
Figure 2.8      f2_8    L2_13  
Figure 2.9      f2_9    L2_15A  
Figure 2.10     f2_10   L2_15B  
Figure 2.11     f2_11   L2_16  
Figure 2.12     f2_12   L2_17  
Figure 2.13     f2_13   L2_18    
Figure 2.14     f2_14   L2_19   
Figure 2.15     f2_15   L2_20 
Figure 2.16     f2_16   (May not run on some MATLAB version)
Figure 2.17(a)  f2_17a  L2_21  
Figure 2.17(b)  f2_17b  L2_22 
Figure 2.18     f2_18   L2_23    
Figure 2.19     f2_19   L2_23  (SAME)   
Figure 2.20     f2_20   
Figure 2.21     f2_21   L2_24     
Figure 2.22     f2_22 
Figure 2.23     f2_23  
Figure 2.24     f2_24   L2_25   
Figure 2.25     (No script)
Figure 2.26     f2_26   L2_26   
Figure 2.27     f2_27   L2_27     
Figure 2.28     f2_28   L2_28 
Figure 2.29     f2_29   L2_29   
Figure 2.30(a)  f2_30A     
Figure 2.30(b)  insect_t   
Figure 2.31     (No script)
Figure 2.32     f2_32   L2_30  
Figure 2.33     f2_33   kids1_     
Figure 2.34     f2_34   kids2_     
Figure 2.35     f2_35   L2_31   
Figure 2.36     f2_36   human_c

Figure 3.1      f3_1 
Figure 3.2      f3_2
Figure 3.3      f3_3 
Figure 3.4      f3_4

Figure 4.1      f4_1
Figure 4.2      f4_2
Figure 4.3      f4_3    L4_1
Figure 4.4      f4_4 
Figure 4.5      f4_5
Figure 4.6      f4_6
Fiugre 4.7      f4_7 
Figure 4.8      f4_8
Figure 4.9      f4_9a
		f4_9b
Figure 4.10     f4_10
Figure 4.11     f4_11
Figure 4.12     f4_12
Figure 4.13     f4_13
Figure 4.14     f4_14
Figure 4.15     f4_15   L4_5
Figure 4.16     f4_16
Figure 4.17     f4_17

Figure 5.1      f5_1      
Figure 5.2      f5_2
Figure 5.3      f5_3
Figure 5.4      f5_4    
Figure 5.5      f5_5
Figure 5.6      f5_6
Fiugre 5.7      f5_7
Figure 5.8      f5_8
Figure 5.9      f5_9
Figure 5.10     f5_10
Figure 5.11     f5_11
Figure 5.12     f5_12
Figure 5.13     f5_13
Figure 5.14     f5_14

Figure 6.1      f6_1                                
Figure 6.2      f6_2
Figure 6.3      f6_3

Figure 7.1      f7_1       
Figure 7.2      f7_2
Figure 7.3      f7_3    L7_1
Figure 7.4      f7_4
Figure 7.5      f7_5    bisec_g   
Figure 7.6      f7_6 
Figure 7.7      f7_7    bisec_g     
Figure 7.8      f7_8 
Figure 7.9      f7_9 
Figure 7.10     f7_10   L7_3
Figure 7.11     f7_11 

Figure 8.1      f8_1
Figure 8.2      f8_2
Figure 8.3      f8_3
Figure 8.4      f8_4    L8_2
Figure 8.5      f8_5    L8_3

Figure 9.1      f9_1         
Figure 9.2      f9_2    
Figure 9.3      f9_3    L9_1
Figure 9.4      f9_4    L9_2
Figure 9.5      f9_5
Figure 9.6      f9_6
Figure 9.7      f9_7    L9_3
Figure 9.8      f9_8    L9_4
Figure 9.9      f9_9    L9_5       
Figure 9.10     f9_10   k_wheel
Figure 9.11     f9_11   k_wheel
Figure 9.12     f9_12   L9_6   
Figure 9.13     f9_13   L9_7
Figure 9.14     f9_14     
Figure 9.15     f9_15   L9_9 

Figure 10.1     f10_1    
Figure 10.2     f10_2   L10_1    
Figure 10.3     f10_3   L10_2      
Figure 10.4     f10_4     
Figure 10.5     f10_5   L10_3        
Figure 10.6     f10_6       
Figure 10.7     f10_7   L10_4       
Figure 10.8     f10_8     
Figure 10.9     f10_9   L10_5      
Figure 10.10    f10_10  L10_6       
Figure 10.11    f10_11      
Figure 10.12    f10_12  L10_7    
Figure 10.13    f10_13  L10_8      
Figure 10.14    f10_14  L10_9       
Figure 10.15    f10_15         
Figure 10.16    f10_16  L10_10           
Figure 10.17    f10_17      
Figure 10.18    f10_18  L10_11      
Figure 10.19    f10_19       
Figure 10.20    f10_20       
Figure 10.21  Not available 
Figure 10.22    f10_22  L10_13       
Figure 10.23    f10_23      
Figure 10.24    f10_24       

Figure A.1      rgbplot(hsv)
Figure A.2      col_bar   L_a1

Figure B.1      fan_rot
Figure B.2      pipe_
Figure B.3      plane_
Figure B.4      lobe_

Appendix C
movie           movei_1

Figure D.1    Not available
Figure D.2    Not available
Figure D.3      disk_ptn
Figure D.4      disk_edg   (Run after disk_ptn)
Figure D.5      edge_dif   (Run after disk_edg)
Figure D.6      fractal_

Figure E.2      guidm_1
Figure E.3      guidm_2
Figure E.4      guidm_3
		guidm_4
Figure E.5      guidm_5
Figure E.6      guidm_6
Figure E.7      guidm_8
Figure E.8      guidm_9

Figure E.9      guidm_10
Figure E.10     guidm_11
Figure E.11     guidm_12
Figure E.12     guidm_13
Figure E.13     guidm_14
Figure E.14     guidm_15
Figure E.15     guidm_16
Figure E.16     guidm_17
Figure E.17     guidm_18

Color Plates
Figure cp-1     col_bar
Figure cp-2     fract_cp
Figure cp-3     Not available
Figure cp-4     Not available
Figure cp-5     disk_ptn
Figure cp-6     edge_dif
Figure cp-7     Not available
Figure cp-8     Not available
Figure cp-9     fan_rot
Figure cp-10    pipe_
Figure cp_11    stream_
		vort_

Figure on the front cover:
		Not available
Figures on the back cover:
		fract_cv
		cav_plot
		k_wheel
-----------------------------------------------------------

   Note: 
	  Some m-files to plot figures may not work properly 
	  depending on the MATLAB version as well as the 
	  computer used.

	  The difficulties are sometimes related to errors in
	  MATLAB: for example, the plane in Figure B.3 may
	  be broken when plotted by plane_ using an earlier
	  version of MATLAB.   The fan blades in Figure B.1 
	  may become broken if the fan rotor is viewed from 
	  a certain view angle.  The col_bar may not be plotted 
	  correctly on a PC-compatible that has 16 bit color.
	  The same problem may occur with movie_1.

	  Program f2_16 may not work on a PC version of MATLAB 
	  because of errors in xyzchk.m, if xyzchk.m is dated 
	  3/18/95 or earlier. In this case, get an updated 
	  M-file of xyzchk.m  











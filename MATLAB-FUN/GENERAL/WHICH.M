%WHICH	Locate functions and files.
%	WHICH FCN displays the full pathname of the specified function.
%	The function can be an M-file, MEX-file, SIMULINK Graphical function,
%	or built in.  Built in functions and SIMULINK functions display a 
%	message indicating that they are built in or part of SIMULINK.
%
%	For example, "which inv" reveals that INV is a built in function and
%	"which pinv" indicates that PINV is in directory toolbox/matlab/linalg.
%	On the other hand "which inverse" probably says "inverse cannot be
%	found" because there is no file "inverse.m" on the default MATLABPATH.
%	Contrast this with "lookfor inverse" which takes longer to run, but
%	which finds several matches to the keyword "inverse" in its search
%	through all the HELP entries.  (If "inverse.m" does exist in the 
%	current directory, or in some private directory that has been added
%	to MATLABPATH, "which inverse" would find it.)
%
%	See also DIR, HELP, WHO, WHAT, EXIST, LOOKFOR.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.

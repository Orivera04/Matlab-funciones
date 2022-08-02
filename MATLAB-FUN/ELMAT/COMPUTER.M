%COMPUTER Inquire computer type.
%	COMPUTER returns a string containing the name of the computer
%	on which MATLAB is executing. Possibilities are:
% 
%	PCWIN - MS-Windows             DEC_RISC - DecStation
%	MAC2  - Macintosh              VAX_VMSD - VAX/VMS D_float
%	SUN4 - Sun SPARC               VAX_VMSG - VAX/VMS G_float
%	SOL2 - Solaris 2               ALPHA - Dec Alpha
%	HP700 - HP 9000/700            HP300 - HP 9000/300  
%	SGI - Silicon Graphics         CRAY - Cray
%	IBM_RS - IBM RS6000            CONVEX - Convex
% 
%	[C,MAXSIZE] = COMPUTER returns also integer MAXSIZE which 
%	contains the maximum number of elements allowed in a matrix
%	on this version of MATLAB.
%
%	See also ISIEEE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	Built-in function.

function LU = forcesizeunlock(LU)
%FORCESIZEUNLOCK Forcefully remove the size locks in a table
%
%  OBJ = FORCESIZEUNLOCK(OBJ) removes all of the tale size locking keys
%  from the table.  This function should only be used as a last resort when
%  you suspect that one of the locking keys has been "lost".  Removing
%  locks in this way may open up the possibility of CAGE data corruption.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:14 $ 

LU.sizelocks = guidarray(0);